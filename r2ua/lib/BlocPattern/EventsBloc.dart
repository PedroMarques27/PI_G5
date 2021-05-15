import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:r2ua/Entities/Event.dart';
import 'BrbBloc.dart';

class EventsBloc {
  StreamController<Event> eventsStreamController =
      StreamController<Event>.broadcast();
  Stream get getUser => eventsStreamController.stream;

  void update(Event b) {
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

    return events;
  }

  Future<Event> getEventById(int id) async {
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

  Future<List<Event>> getAllClassroomEventsByTime(
      int classId, String startTime, String endTime) async {
    List<Event> events = await getData("/api/Events/all/" +
        classId.toString() +
        "/" +
        startTime +
        "/" +
        endTime);
    return events;
  }
}
