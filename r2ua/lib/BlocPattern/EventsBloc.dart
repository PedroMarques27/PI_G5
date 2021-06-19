import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:r2ua/Entities/Event.dart';
import 'package:r2ua/Entities/Week.dart';
import 'BrbBloc.dart';

class EventsBloc {
  StreamController<List<Event>> eventsStreamController =
      StreamController<List<Event>>.broadcast();
  Stream get getListOfEvents => eventsStreamController.stream;

  void update(List<Event> b) {
    eventsStreamController.sink
        .add(b); // add whatever data we want into the Sink
  }

  void dispose() {
    eventsStreamController.close(); // close our StreamController to emory leak
  }

  void stop() {}

  StreamController<List<Event>> pastEventsStreamController =
      StreamController<List<Event>>.broadcast();
  Stream get getListOfPastEvents => pastEventsStreamController.stream;

  void updatePast(List<Event> b) {
    pastEventsStreamController.sink
        .add(b); // add whatever data we want into the Sink
  }

  void disposePast() {
    pastEventsStreamController
        .close(); // close our StreamController to emory leak
  }

  void stopPast() {}

  Future<List<Event>> searchEventsByUser(String email) async {
    var uri = Uri.https(BASE_URL, ('/api/Events/search'));
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
              'type': 1,
              'not': false,
              'value': email,
              'path': 'EventUser.User.UserName'
            },
            {
              'and': true,
              'type': 6,
              'not': false,
              'value': DateTime.now().toString(),
              'path': 'EventWeek.Week.StartDate'
            },
          ],
          'groups': [],
          'aggregates': []
        }));

    List<Event> userEvents;
    List<Event> userEvents1;

    if (json.decode(response.body)['data']['data'] != []) {
      Iterable l = json.decode(response.body)['data']['data'];
      userEvents = List<Event>.from(l.map((model) => Event.fromJson(model)));
    }

    final response1 = await http.post(uri,
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
              'type': 1,
              'not': false,
              'value': email,
              'path': 'EventUser.User.UserName'
            },
            {
              'and': true,
              'type': 0,
              'not': false,
              'value': DateTime.now()
                  .subtract(Duration(days: DateTime.now().weekday - 1))
                  .toIso8601String()
                  .split('T')[0],
              'path': 'EventWeek.Week.StartDate'
            },
            {
              'and': true,
              'type': 8,
              'not': false,
              'value': DateTime.now().weekday - 1,
              'path': 'Day'
            }
          ],
          'groups': [],
          'aggregates': []
        }));

    if (json.decode(response1.body)['data']['data'] != []) {
      Iterable l = json.decode(response1.body)['data']['data'];
      userEvents1 = List<Event>.from(l.map((model) => Event.fromJson(model)));
    }


    var array = <int>[];
    for (var e in userEvents) {
      array.add(e.id);
    }

    for (var e in userEvents1) {
      if (!array.contains(e.id)) {
        userEvents.add(e);
      }
    }

    for (var j = 0; j < userEvents.length; j++) {
      var event = userEvents[j];
      if (event.weeks.length > 1) {
        for (var w = 0; w < event.weeks.length; w++) {
          if (initWeekDay_before(event.weeks[w].getFormattedBegin())) {
            event.weeks.remove(event.weeks[w]);
          }
        }
      }
    }

    for (var j = 0; j < userEvents.length; j++) {
      var e = userEvents[j];
      for (var w = 0; w < e.weeks.length; w++) {
        if (sameDate(e.day, e.weeks[w].getFormattedBegin())) {
          if (eventDateBeforeDateNow(
              e.day, e.weeks[w].getFormattedBegin(), e.startTime)) {
            userEvents.removeAt(j);
          }
        }
      }
    }

    update(userEvents);

    return userEvents;
  }

  DateTime convertToDateTime(int day, String week, String startTime) {
    var weekDate = week.split('/');
    var hourMin = startTime.split(':');
    var parseDt = DateTime(
        int.parse(weekDate[2]),
        int.parse(weekDate[1]),
        int.parse(weekDate[0]) + day,
        int.parse(hourMin[0]),
        int.parse(hourMin[1]));
    return parseDt;
  }

  bool initWeekDay_before(String week) {
    var now = DateTime.now();
    var currentDay = now.weekday;
    var firstDayOfPresentWeek = now.subtract(Duration(days: currentDay - 1));
    var weekDate = week.split('/');
    var parseDt = DateTime(
        int.parse(weekDate[2]), int.parse(weekDate[1]), int.parse(weekDate[0]));
    if (DateTime.parse(DateFormat('yyyy-MM-dd').format(parseDt)).isBefore(
        DateTime.parse(
            DateFormat('yyyy-MM-dd').format(firstDayOfPresentWeek)))) {
      return true;
    }
    return false;
  }

  bool sameDate(int day, String week) {
    var now = DateTime.now();
    var dateNow = DateTime(now.year, now.month, now.day);

    var weekDate = week.split('/');
    var parseDt = DateTime(int.parse(weekDate[2]), int.parse(weekDate[1]),
        int.parse(weekDate[0]) + day);
    if (DateTime.parse(DateFormat('yyyy-MM-dd').format(dateNow)).compareTo(
            DateTime.parse(DateFormat('yyyy-MM-dd').format(parseDt))) ==
        0) {
      return true;
    }

    return false;
  }

  bool eventDateBeforeDateNow(int day, String week, String startTime) {
    var date = convertToDateTime(day, week, startTime);
    if (date.isBefore(DateTime.now())) {
      return true;
    }
    return false;
  }

  bool eventDateAfterDateNow(int day, String week, String startTime) {
    var date = convertToDateTime(day, week, startTime);
    if (date.isAfter(DateTime.now())) {
      return true;
    }
    return false;
  }

  Future<List<Event>> searchPastEventsByUser(String email) async {
    var uri = Uri.https(BASE_URL, ('/api/Events/search'));
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
              'type': 1,
              'not': false,
              'value': email,
              'path': 'EventUser.User.UserName'
            },
            {
              'and': true,
              'type': 9,
              'not': false,
              'value': DateTime.now()
                  .subtract(Duration(days: DateTime.now().weekday - 1))
                  .toString(),
              'path': 'EventWeek.Week.StartDate'
            },
          ],
          'groups': [],
          'aggregates': []
        }));

    List<Event> userEvents;

    if (json.decode(response.body)['data']['data'] != []) {
      Iterable l = json.decode(response.body)['data']['data'];
      userEvents = List<Event>.from(l.map((model) => Event.fromJson(model)));
    }

    final response1 = await http.post(uri,
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
              'type': 1,
              'not': false,
              'value': email,
              'path': 'EventUser.User.UserName'
            },
            {
              'and': true,
              'type': 0,
              'not': false,
              'value': DateTime.now()
                  .subtract(Duration(days: DateTime.now().weekday - 1))
                  .toIso8601String()
                  .split('T')[0],
              'path': 'EventWeek.Week.StartDate'
            },
            {
              'and': true,
              'type': 7,
              'not': false,
              'value': DateTime.now().weekday - 1,
              'path': 'Day'
            }
          ],
          'groups': [],
          'aggregates': []
        }));

    List<Event> userEvents1;
    if (json.decode(response1.body)['data']['data'] != []) {
      Iterable l = json.decode(response1.body)['data']['data'];
      userEvents1 = List<Event>.from(l.map((model) => Event.fromJson(model)));
    }

    var array = <int>[];
    for (var e in userEvents) {
      array.add(e.id);
    }

    for (var e in userEvents1) {
      if (!array.contains(e.id)) {
        userEvents.add(e);
      }
    }

    for (var j = 0; j < userEvents.length; j++) {
      var e = userEvents[j];
      for (var w = 0; w < e.weeks.length; w++) {
        if (sameDate(e.day, e.weeks[w].getFormattedBegin())) {
          if (eventDateAfterDateNow(
              e.day, e.weeks[w].getFormattedBegin(), e.startTime)) {
            userEvents.removeAt(j);
          }
        }
      }
    }

    updatePast(userEvents);

    return userEvents;
  }

  Future<bool> removeEvent(int eventId, String email) async {
    var uri = Uri.https(BASE_URL, ('/api/ThirdPartyEvents/removecollection'));

    final response = await http.post(uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
          'Access-Control-Allow-Origin': '*'
        },
        body: jsonEncode({
          'identifiers': [eventId],
          'propertyBags': [
            {'key': 'string', 'value': 'string'}
          ]
        }));

    if (response.statusCode == 204) {
      return true;
    }
    return false;
  }

  Future<List<Event>> getAllClassroomEventsByTime(
      int classId, Week week) async {
    var uri = Uri.https(
        BASE_URL,
        'all/' +
            week.beginning.toIso8601String() +
            '/' +
            week.ending.toIso8601String() +
            '/' +
            classId.toString());
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
    );
    if (response.body.isNotEmpty) {
      var v = json.decode(response.body)['data'];
      Iterable l = v;
      var events = List<Event>.from(l.map((model) => Event.fromJson(model)));

      update(events);
      return events;
    }
    var events = <Event>[];
    update(events);
    return events;
  }
}

class UserEvents {
  UserEvents({this.futureEvents, this.pastEvents});
  List<Event> futureEvents;
  List<Event> pastEvents;
}
