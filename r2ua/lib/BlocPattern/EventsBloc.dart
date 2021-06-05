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

  Future<List<Event>> getData(String url) async {
    var uri = Uri.https(BASE_URL, url);
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        HttpHeaders.contentTypeHeader: "application/json",
        "Access-Control-Allow-Origin": "*"
      },
    );
    Iterable l = json.decode(response.body)['data'];
    List<Event> events =
        List<Event>.from(l.map((model) => Event.fromJson(model)));
    update(events);
    return events;
  }

  Future<Event> getEventByIdAndWeek(int id) async {
    var uri = Uri.https(BASE_URL, ("/api/Events/" + id.toString()));
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        HttpHeaders.contentTypeHeader: "application/json",
        "Access-Control-Allow-Origin": "*"
      },
    );
    return Event.fromJson(json.decode(response.body)['data']);
  }

  Future<List<Event>> searchEventsByUser(String email, int number) async {
    debugPrint("numebr" + number.toString());
    var uri = Uri.https(BASE_URL, ("/api/Events/search"));
    final response = await http.post(uri,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          HttpHeaders.contentTypeHeader: "application/json",
          "Access-Control-Allow-Origin": "*"
        },
        body: jsonEncode({
          "page": 1,
          "pageSize": number,
          "sorts": [
            {"path": "Day", "ascending": true}
          ],
          "filters": [
            {
              "and": true,
              "type": 1,
              "not": false,
              "value": email,
              "path": "EventUser.User.UserName"
            },
            {
              "and": true,
              "type": 8,
              "not": false,
              "value": DateTime.now().toIso8601String(),
              "path": "EventWeek.Week.StartDate"
            }
          ],
          "groups": [],
          "aggregates": []
        }));

    List<Event> userEvents;

    if (json.decode(response.body)['data']['data'] != []) {
      Iterable l = json.decode(response.body)['data']['data'];
      userEvents = List<Event>.from(l.map((model) => Event.fromJson(model)));
    }
    update(userEvents);

    return userEvents;
  }

  Future<List<Event>> searchPastEventsByUser(String email) async {
    var uri = Uri.https(BASE_URL, ("/api/Events/search"));
    final response = await http.post(uri,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          HttpHeaders.contentTypeHeader: "application/json",
          "Access-Control-Allow-Origin": "*"
        },
        body: jsonEncode({
          "page": 1,
          "pageSize": 10,
          "sorts": [
            {"path": "Day", "ascending": true}
          ],
          "filters": [
            {
              "and": false,
              "type": 1,
              "not": false,
              "value": email,
              "path": "EventUser.User.UserName"
            },
            {
              "and": true,
              "type": 7,
              "not": false,
              "value": DateTime.now().toIso8601String(),
              "path": "EventWeek.Week.StartDate"
            },
            {
              "and": true,
              "type": 6,
              "not": false,
              "value":
                  DateTime.now().subtract(Duration(days: 30)).toIso8601String(),
              "path": "EventWeek.Week.StartDate"
            }
          ],
          "groups": [],
          "aggregates": []
        }));

    List<Event> userEvents;

    if (json.decode(response.body)['data']['data'] != []) {
      Iterable l = json.decode(response.body)['data']['data'];
      userEvents = List<Event>.from(l.map((model) => Event.fromJson(model)));
    }

    return userEvents;
  }

  Future<UserEvents> bookingsEvents(String email, int number) async {
    UserEvents uE = UserEvents(
        futureEvents: await this.searchEventsByUser(email, number),
        pastEvents: await this.searchPastEventsByUser(email));

    return uE;
  }

  Future<bool> removeEvent(int eventId) async {
    var uri = Uri.https(BASE_URL, ("/api/ThirdPartyEvents/removecollection"));

    final response = await http.post(uri,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          HttpHeaders.contentTypeHeader: "application/json",
          "Access-Control-Allow-Origin": "*"
        },
        body: jsonEncode({
          "identifiers": [eventId],
          "propertyBags": [
            {"key": "string", "value": "string"}
          ]
        }));
    if (response.statusCode == 201) return true;

    return false;
  }

  Future<List<Event>> getAllClassroomEventsByTime(
      int classId, Week week) async {
    var uri = Uri.https(
        BASE_URL,
        "all/" +
            week.beginning.toIso8601String() +
            "/" +
            week.ending.toIso8601String() +
            "/" +
            classId.toString());
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        HttpHeaders.contentTypeHeader: "application/json",
        "Access-Control-Allow-Origin": "*"
      },
    );
    if (response.body.isNotEmpty) {
      var v = json.decode(response.body)['data'];
      Iterable l = v;
      List<Event> events =
          List<Event>.from(l.map((model) => Event.fromJson(model)));

      for (var item in events) {
        debugPrint(item.name);
      }
      update(events);
      return events;
    }
    List<Event> events = new List<Event>();
    update(events);
  }
}

class UserEvents {
  List<Event> futureEvents;
  List<Event> pastEvents;

  UserEvents({this.futureEvents, this.pastEvents});
}
