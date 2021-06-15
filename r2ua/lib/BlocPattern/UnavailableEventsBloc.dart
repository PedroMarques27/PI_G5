import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:r2ua/Entities/Event.dart';
import 'BrbBloc.dart';

class UnavailableEventsBloc {
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

  Future<List<Event>> searchUnavailableEventsByWeekByClassroom(
      String weekStartDate, int classId) async {
    var uri = Uri.https(BASE_URL, ('/api/Events/search'));
    final response = await http.post(uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
          'Access-Control-Allow-Origin': '*'
        },
        body: jsonEncode({
          'page': 1,
          'pageSize': 100,
          'sorts': [
            {'path': 'Day', 'ascending': true},
            {'path': 'StartTime', 'ascending': true}
          ],
          'filters': [
            {
              'and': true,
              'type': 0,
              'not': false,
              'value': weekStartDate,
              'path': 'EventWeek.Week.StartDate'
            },
            {
              'and': true,
              'type': 0,
              'not': false,
              'value': classId,
              'path': 'EventClassroom.Classroom.Id'
            }
          ],
          'groups': [],
          'aggregates': []
        }));

    List<Event> userEvents;

    if (json.decode(response.body)['data']['data'] != []) {
      Iterable l = json.decode(response.body)['data']['data'];
      userEvents = List<Event>.from(l.map((model) => Event.fromJson(model)));
    }
    update(userEvents);

    return userEvents;
  }
}
