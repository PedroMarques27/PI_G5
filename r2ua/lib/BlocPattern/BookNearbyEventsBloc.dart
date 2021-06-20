import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:r2ua/Entities/Classrooms.dart';
import 'package:r2ua/Entities/Event.dart';
import 'package:r2ua/Entities/Building.dart';
import 'BrbBloc.dart';

class BookNearbyEventsBloc {
  StreamController<Map<Building, List<AvailableClassroomOnTime>>>
      classNearbyStreamController = StreamController<
          Map<Building, List<AvailableClassroomOnTime>>>.broadcast();
  Stream get getNearbyMap => classNearbyStreamController.stream;

  void update(Map<Building, List<AvailableClassroomOnTime>> b) {
    classNearbyStreamController.sink
        .add(b); // add whatever data we want into the Sink
  }

  void dispose() {
    classNearbyStreamController
        .close(); // close our StreamController to emory leak
  }

  void stop() {}

/*
  FUNÇAO: searchClassroomsBuildings
    faz um classrooms search por cada building que retorna as salas de cada building
    cada uma dessas salas é uma a que o user tem acesso
  
  FUNÇAO: unavailableTimes
    para cada sala tem que se chamar a função unavailableEventsBloc.searchUnavailableEventsByWeekByClassroom 
    de forma a obter a lista de eventos já reservados nessa semana

  FUNÇAO: availableTimes
    com essa lista (eventos reservados) fazemos a função availableTimes, que percorre os eventos do dia em questão
    e cria uma lista com todos os tempos vagos dessa sala nesse dia
    com essa lista podemos ver se existe o startTime:
      se sim:
        vejo se existe um endTime
      se não
        vejo a meia hora seguinte, se existir um endTime, retorno-o
    esse endTime é retornado

  Apos estas 3 funçoes tenho o necessário para criar instancias de AvailableClassroomOnTime
*/

// esta lista deve estar ordenada por proximidade
  Future<Map<Building, List<AvailableClassroomOnTime>>>
      searchClassroomsBuildings(
          List<Building> buildings, DateTime date, String startTime) async {
    var map = <Building, List<AvailableClassroomOnTime>>{};

    var uri = Uri.https(BASE_URL, ('/api/Classrooms/search'));
    for (var i = 0; i < buildings.length; i++) {
      final response = await http.post(uri,
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            'Access-Control-Allow-Origin': '*'
          },
          body: jsonEncode({
            'page': 1,
            'pageSize': 10,
            'sorts': [],
            'filters': [
              {
                'and': true,
                'type': 0,
                'not': false,
                'value': buildings[i].id,
                'path': 'Building.Id'
              },
            ],
            'groups': [],
            'aggregates': []
          }));

      var classes = <Classroom>[];

      if (json.decode(response.body)['data']['data'] != []) {
        Iterable l = json.decode(response.body)['data']['data'];
        classes =
            List<Classroom>.from(l.map((model) => Classroom.fromJson(model)));
      }
      var availableClassesperBuilding =
          await unavailableTimes(classes, date, startTime, buildings[i].id);

      if (availableClassesperBuilding != null) {
        map[buildings[i]] = availableClassesperBuilding;
      }
    }

    update(map);
    return map;
  }

// só preciso do id, será q vou precisar para outras cenas a classroom inteira?
  Future<List<AvailableClassroomOnTime>> unavailableTimes(
      List<Classroom> classes,
      DateTime date,
      String startTime,
      int buildingId) async {
    var weekBeginning = date.subtract(Duration(days: date.weekday - 1));
    var weekday = date.weekday - 1;
    var availableClasses = <AvailableClassroomOnTime>[];

    for (var c in classes) {
      var unavEvents =
          await unavailableEventsBloc.searchUnavailableEventsByWeekByClassroom(
              weekBeginning.toString(), c.id);
      var availableClass = getAvailableClass(
          unavEvents, weekday, startTime, buildingId, c, date);
      if (availableClass != null) {
        availableClasses.add(availableClass);
      }
    }

    return availableClasses.isEmpty ? null : availableClasses;
  }

  AvailableClassroomOnTime getAvailableClass(List<Event> unavailable, int day,
      String startTime, int buildingId, Classroom classroom, DateTime date) {
    var availableTimes = [
      '08:00',
      '08:30',
      '09:00',
      '09:30',
      '10:00',
      '10:30',
      '11:00',
      '11:30',
      '12:00',
      '12:30',
      '13:00',
      '13:30',
      '14:00',
      '14:30',
      '15:00',
      '15:30',
      '16:00',
      '16:30',
      '17:00',
      '17:30',
      '18:00',
      '18:30',
      '19:00',
      '19:30',
      '20:00',
      '20:30',
      '21:00',
      '21:30',
      '22:00'
    ];

    var thirtyMinAfterStartTime =
        availableTimes[availableTimes.indexOf(startTime) + 1];

    var used = false;

    for (var e in unavailable) {
      if (e.day == day) {
        var ind1 = availableTimes.indexOf(e.startTime.substring(0, 5));
        var ind2 = availableTimes.indexOf(e.endTime.substring(0, 5));

        if (ind1 != -1 && ind2 != -1) {
          for (var i = ind2 - 1; i >= ind1; i--) {
            availableTimes.removeAt(i);
          }
          availableTimes.insert(ind1, '-');
        }
      }
    }

    var endTime = '';

    if (availableTimes.contains(startTime)) {
      for (var i = availableTimes.indexOf(startTime) + 1;
          i < availableTimes.length;
          i++) {
        if (availableTimes[i] == '-') {
          break;
        } else {
          endTime = availableTimes[i];
        }
      }
    }
    if (endTime == '' && availableTimes.contains(thirtyMinAfterStartTime)) {
      used = true;
      for (var i = availableTimes.indexOf(thirtyMinAfterStartTime) + 1;
          i < availableTimes.length;
          i++) {
        if (availableTimes[i] == '-') {
          break;
        } else {
          endTime = availableTimes[i];
        }
      }
    }
    if (endTime != '') {
      var availableClass = AvailableClassroomOnTime(
          buildingId: buildingId,
          classroom: classroom,
          startTime: used ? thirtyMinAfterStartTime : startTime,
          endTime: endTime,
          thirtyMinAfter: used,
          date: date);
      return availableClass;
    }

    return null;
  }
}

class AvailableClassroomOnTime {
  AvailableClassroomOnTime(
      {this.buildingId,
      this.classroom,
      this.startTime,
      this.endTime,
      this.thirtyMinAfter,
      this.date});

  int buildingId;
  Classroom classroom;
  String startTime;
  String endTime;
  bool thirtyMinAfter;
  DateTime date;
}
