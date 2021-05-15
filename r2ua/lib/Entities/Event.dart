import 'dart:core';

class Event {
  String name, startTime, endTime, duration, sectionName, observations;
  int id, day, numberPeople, eventTypeId;
  List<Week> weeks;

  Event(
      {this.id,
      this.name,
      this.startTime,
      this.endTime,
      this.duration,
      this.sectionName,
      this.observations,
      this.day,
      this.numberPeople,
      this.eventTypeId,
      this.weeks});

  factory Event.fromJson(Map<String, dynamic> json) {
    Iterable l = json['weeks'];
    List<Week> _weeks = List<Week>.from(l.map((model) => Week.fromJson(model)));

    return Event(
      id: json['id'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      duration: json['duration'],
      sectionName: json['sectionName'],
      observations: json['observations'],
      day: json['day'],
      numberPeople: json['numberPeople'],
      eventTypeId: json['eventType']['id'],
      weeks: _weeks,
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

class Week {
  int id;
  String startDate;

  Week({
    this.id,
    this.startDate,
  });

  factory Week.fromJson(Map<String, dynamic> json) {
    return Week(id: int.parse(json['name']), startDate: json['startDate']);
  }
}
