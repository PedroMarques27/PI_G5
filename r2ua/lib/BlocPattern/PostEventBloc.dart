import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:r2ua/Entities/Event.dart';
import 'BrbBloc.dart';

class PostEventsBloc {
  StreamController<List<Event>> unavailableEventsStreamController =
      StreamController<List<Event>>.broadcast();
  Stream get getListOfEvents => unavailableEventsStreamController.stream;

  void update(List<Event> b) {
    unavailableEventsStreamController.sink
        .add(b); // add whatever data we want into the Sink
  }

  void dispose() {
    unavailableEventsStreamController
        .close(); // close our StreamController to emory leak
  }

  void stop() {}

  Future<bool> postEvent(
      String name,
      String startTime,
      String endTime,
      int day,
      int eventType,
      int numStudents,
      String email,
      String weekStartDate,
      int classId) async {
    int weekId = await this.getWeekId(weekStartDate);
    debugPrint("IDDDDD" + weekId.toString());

    var uri = Uri.https(BASE_URL, ("/api/ThirdPartyEvents "));
    final response = await http.post(uri,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          HttpHeaders.contentTypeHeader: "application/json",
          "Access-Control-Allow-Origin": "*"
        },
        body: jsonEncode({
          "name": name,
          "code": (name + "_" + email).toLowerCase().replaceAll(" ", "_"),
          "startTime": startTime,
          "endTime": endTime,
          "day": day,
          "eventTypeId": eventType,
          "numStudents": numStudents.toString(),
          "requestedBy": email,
          "eventWeeks": [
            {
              "model": {"weekId": weekId},
              "status": 1
            }
          ],
          "eventClassrooms": [
            {
              "model": {"classroomId": classId},
              "status": 1
            }
          ],
          "propertyBags": [
            {"key": "string", "value": "string"}
          ]
        }));

    debugPrint("\n\npost  " +
        jsonEncode({
          "name": name,
          "code": name.toLowerCase().replaceAll(" ", "_"),
          "startTime": startTime,
          "endTime": endTime,
          "day": day,
          "eventTypeId": eventType,
          "numStudents": numStudents.toString(),
          "requestedBy": email,
          "eventWeeks": [
            {
              "model": {"weekId": weekId},
              "status": 1
            }
          ],
          "eventClassrooms": [
            {
              "model": {"classroomId": classId},
              "status": 1
            }
          ],
          "propertyBags": [
            {"key": "string", "value": "string"}
          ]
        }));

    debugPrint("Status code" + response.statusCode.toString());
    if (response.statusCode == 201) return true;

    return false;
  }

  Future<int> getWeekId(String weekDate) async {
    debugPrint("heeelooo " + weekDate);
    var uri = Uri.https(BASE_URL, "/api/Weeks/starting/" + weekDate);
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        HttpHeaders.contentTypeHeader: "application/json",
        "Access-Control-Allow-Origin": "*"
      },
    );

    debugPrint("WEEEEK " + response.body);
    debugPrint("\nWEEEEK " + json.decode(response.body)['data'][0].toString());
    debugPrint(
        "\nWEEEEK " + json.decode(response.body)['data'][0]['id'].toString());
    return json.decode(response.body)['data'][0]['id'];
  }
}
