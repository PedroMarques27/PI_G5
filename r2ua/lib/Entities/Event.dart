import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:r2ua/Entities/Classrooms.dart';
import 'package:r2ua/Entities/Week.dart';

class Event {
  String name, startTime, endTime, duration, sectionName, observations;
  int id, day, numberPeople, eventTypeId;
  DateFormat date = new DateFormat('yyyy-MM-dd');
  List<Week> weeks;
  List<Classroom> classes;

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
    this.classes,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    Iterable l = json['weeks'];
    List<Week> _weeks = List<Week>.from(l.map((model) => Week.fromJson(model)));

    Iterable c = json['classrooms'];
    List<Classroom> _classes = List<Classroom>.from(c.map((model) => Classroom.fromJson(model)));

    return Event(
      id: json['id'],
      name: json['name'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      duration: json['duration'],
      sectionName: json['sectionName'],
      observations: json['observations'],
      day: json['day'],
      numberPeople: json['numberPeople'],
      eventTypeId: json['eventType']['id'],
      weeks: _weeks,
      classes: _classes
    );
  }
}

class EventType {
  int id;
  String name;
  bool active, setToAplication;

  EventType({
    this.id,
    this.name,
    this.active,
    this.setToAplication,
  });

  factory EventType.fromJson(Map<String, dynamic> json) {
    bool a = json['active'].toString().toLowerCase() == 'true';
    bool b = json['setToAplication'].toString().toLowerCase() == 'true';
    return EventType(
        id: int.parse(json['name']),
        name: json['name'],
        active: a,
        setToAplication: b);
  }
}
