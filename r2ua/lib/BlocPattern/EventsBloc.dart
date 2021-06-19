import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
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

    for (var e in userEvents1) {
      if (!userEvents.contains(e)) {
        userEvents.add(e);
      }
    }

    update(userEvents);

    return userEvents;
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

    for (var e in userEvents1) {
      if (!userEvents.contains(e)) {
        userEvents.add(e);
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
      //await bookingsEvents(email, 3);
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
