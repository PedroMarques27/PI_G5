import 'dart:convert';

import 'Week.dart';

EventPost eventPostFromJson(String str) => EventPost.fromJson(json.decode(str));

String eventPostToJson(EventPost data) => json.encode(data.toJson());

class EventPost {
  EventPost({
    this.name,
    this.startTime,
    this.endTime,
    this.day, //[ 0, 1, 2, 3, 4, 5, 6 ]
    this.eventTypeId,
    this.numStudents,
    this.requestedBy,
    this.weekId,
    this.statusWeek, // [ 0, 1, 2, 3 ]
    this.classroomId,
    this.statusClassroom, //[ 0, 1, 2, 3 ]
  });

  factory EventPost.fromJson(Map<String, dynamic> json) {

    return EventPost(
      name: json['name'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      day: json['day'],
      eventTypeId: json['eventTypeId'],
      numStudents: json['numStudents'],
      requestedBy: json['requestedBy'],
      weekId: json['weekId'],
      classroomId: json['classroomId'],
    );
  }

  String name, startTime, endTime, day, sectionName, observations, requestedBy;
  int id,
      numStudents,
      eventTypeId,
      weekId,
      statusWeek,
      classroomId,
      statusClassroom;
  List<Week> weeks;

  Map<String, dynamic> toJson() => {
        'name': name,
        'code': name + '_r2UA',
        'startTime': startTime,
        'endTime': endTime,
        'day': day,
        'eventTypeId': eventTypeId,
        'numStudents': numStudents,
        'requestedBy': requestedBy,
        'eventWeek': [
          {
            'model': {'weekId': weekId},
            'status': statusWeek
          }
        ],
        'eventClassrooms': [
          {
            'model': {'classroomId': classroomId},
            'status': statusClassroom
          }
        ],
        'propertyBags': [
          {'key': 'string', 'value': 'string'}
        ]
      };
}
