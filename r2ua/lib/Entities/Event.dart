import 'dart:core';

import 'package:intl/intl.dart';
import 'package:r2ua/Entities/Week.dart';

class Event {
  Event({
    this.id,
    this.name,
    this.startTime,
    this.endTime,
    this.duration,
    this.sectionName,
    this.observations,
    this.day,
    this.numberPeople,
    this.eventTypeId,
    this.weeks,
    this.classId,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    Iterable l = json['weeks'];
    var _weeks = List<Week>.from(l.map((model) => Week.fromJson(model)));

    return Event(
        id: json['id'],
        name: json['name'],
        startTime: json['startTime'],
        endTime: json['endTime'],
        duration: json['duration'],
        sectionName: json['sectionName'],
        observations: json['observations'],
        day: json['day'],
        numberPeople: json['numStudents'],
        eventTypeId: json['eventType']['id'],
        weeks: _weeks,
        classId: json['classrooms'][0]['id']);
  }
  String name, startTime, endTime, duration, sectionName, observations;
  int id, day, numberPeople, eventTypeId, classId;
  DateFormat date = DateFormat('yyyy-MM-dd');
  List<Week> weeks;
}

class EventType {
  EventType({
    this.id,
    this.name,
    this.active,
    this.setToAplication,
  });

  factory EventType.fromJson(Map<String, dynamic> json) {
    var a = json['active'].toString().toLowerCase() == 'true';
    var b = json['setToAplication'].toString().toLowerCase() == 'true';
    return EventType(
        id: int.parse(json['name']),
        name: json['name'],
        active: a,
        setToAplication: b);
  }
  int id;
  String name;
  bool active, setToAplication;
}
