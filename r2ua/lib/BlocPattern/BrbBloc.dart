import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:r2ua/BlocPattern/WeekBloc.dart';
import 'package:r2ua/Entities/Building.dart';
import 'package:r2ua/Entities/ClassroomGroups.dart';
import 'package:r2ua/Entities/Classrooms.dart';
import 'package:r2ua/Entities/User.dart';

import 'BuildingBloc.dart';
import 'ClassroomGroupsBloc.dart';
import 'ClassroomsBloc.dart';
import 'EventsBloc.dart';
import 'UsersBloc.dart';

String token =
    "eyJhbGciOiJSUzI1NiIsImtpZCI6IjQ4M2YzZWI0YzA3N2RjMDFmMjQ5MzIyNDk5NDM3NGJmIiwidHlwIjoiYXQrand0In0.eyJuYmYiOjE2MjE4NzY0NDcsImV4cCI6MTYyNDQ2ODQ0NywiaXNzIjoiaHR0cHM6Ly9idWxsZXQtaXMuZGV2LnVhLnB0IiwiYXVkIjoiYmVzdGxlZ2FjeV9hcGlfcmVzb3VyY2UiLCJjbGllbnRfaWQiOiJyb29tX2Rpc3BsYXllciIsImNsaWVudF9jcmVhdGVfY2xhaW0iOiJ0cnVlIiwiY2xpZW50X3VwZGF0ZV9jbGFpbSI6InRydWUiLCJjbGllbnRfZGVsZXRlX2NsYWltIjoidHJ1ZSIsImNsaWVudF9yZWFkX2NsYWltIjoidHJ1ZSIsInNjb3BlIjpbImJlc3RsZWdhY3lfYXBpX3Njb3BlIl19.gV9fhL3sm88Ehgt1UbBDrsSR-guHINIdusVEdckvF15DfOd2P2ANKMuCCU4YhNcMylCnrc9WCl5qt4rYk-_-3iytJDJKLoIIsiybfWB6EfWliJyVAkwOKkmizhOX8gFR9nZ3bRq-2RKRYRPBEqu3J7A2fVii3TERn4m6U9K2I0X8krgUG2LujeCHXoiZcLTrXu7v6kXFarR4NPYsFyKiWkhclIvunUb0CuPO7Bn9Qu3xBMcX1vsQK1Dfx9Mgq9o7T98cjHMsp53lkUCkHVa4zvJdTYU20eIKk4rcXrrchUQ9cH9OYMGOo1ELBD0gPGUlrr7EmYWawk0HgWD07souJg";
String BASE_URL = 'bullet-api.dev.ua.pt';

class BrbBloc {
  StreamController<List<BuildCount>> buildCountStreamController =
      StreamController<List<BuildCount>>.broadcast();
  Stream get getBuildCount => buildCountStreamController.stream;

  void update(List<BuildCount> b) {
    buildCountStreamController.sink.add(b);
  }

  void dispose() {
    buildCountStreamController.close();
  }

  User currentUser;
  Stream<User> userSubscription = usersBloc.getUser;
  void initialize(String email) {
    userSubscription.listen((newuser) {
      this.currentUser = newuser as User;
      getClassroomGroupsBuildings(currentUser.classroomGroupsId);
    });
    usersBloc.getCurrentUser(email);
    debugPrint(
        'CurrentUser: $currentUser'); //-----------------------------------------------------
  }

  void getClassroomGroupsBuildings(List<int> groupsIds) async {
    List<ClassroomGroup> classGroups = new List<ClassroomGroup>();
    for (var id in groupsIds) {
      classGroups.add(await classroomGroupsBloc.getCurrentClassroomGroup(id));
    }
    HashSet<int> classroomsIds = new HashSet<int>();
    for (var classG in classGroups) {
      classroomsIds.addAll(classG.classrooms);
    }

    HashSet<Classroom> classes = new HashSet<Classroom>();
    HashMap<int, Building> codesBuildings = new HashMap();
    List<BuildCount> data = new List<BuildCount>();
    for (var classId in classroomsIds) {
      Classroom cs = (await classroomsBloc.getClassroomById(classId));

      Building currentBuilding;
      if (codesBuildings.containsKey(cs.building)) {
        currentBuilding = codesBuildings[cs.building];
        for (var d in data) {
          if (d.building.id == cs.building) {
            d.classrooms.add(cs);
            d.count = d.classrooms.length;
          }
        }
      } else {
        currentBuilding = await buildingBloc.getBuildingById(cs.building);
        codesBuildings[cs.building] = currentBuilding;
        List<Classroom> _temp = new List<Classroom>();
        _temp.add(cs);
        data.add(new BuildCount(
            building: currentBuilding, classrooms: _temp, count: 1));
      }
      update(data);
    }
    var x = getWeek();
  }

  String getWeek() {
    String date = DateTime.now().toString();
    String firstDay = date.substring(0, 8) + '01' + date.substring(10);
    int weekDay = DateTime.parse(firstDay).weekday;
    int todayDay = DateTime.now().day;
    int wholeWeeksSinceDayOne = ((todayDay - 1) / 7).floor();
    int beginningOfThisWeek = weekDay + 7 * wholeWeeksSinceDayOne;

    return beginningOfThisWeek.toString() +
        "/" +
        DateTime.now().month.toString() +
        "/" +
        DateTime.now().year.toString();
  }
}

class BuildCount {
  Building building;
  int count;
  List<Classroom> classrooms;
  BuildCount({this.building, this.count, this.classrooms});
}

final weekBloc = new WeekBloc();
final eventsBloc = new EventsBloc();
final usersBloc = UsersBloc();
final buildingBloc = BuildingBloc();
final classroomGroupsBloc = ClassroomGroupsBloc();
final classroomsBloc = ClassroomsBloc();
final brbBloc = BrbBloc();
