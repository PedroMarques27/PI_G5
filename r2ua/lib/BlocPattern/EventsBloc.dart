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

/*   Future<List<Event>> getData(String url) async {
    debugPrint('EVENTS BLOC - getData\n');
    var uri = Uri.https(BASE_URL, url);
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
    );
    Iterable l = json.decode(response.body)['data'];
    var events = List<Event>.from(l.map((model) => Event.fromJson(model)));
    update(events);
    return events;
  } */

/*   Future<Event> getEventById(int id) async {
    debugPrint('EVENTS BLOC - getEventById\n');
    var uri = Uri.https(BASE_URL, ('/api/ThirdPartyEvents/' + id.toString()));
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
    );
    return Event.fromJson(json.decode(response.body)['data']);
  } */

// ver se está a ser usado
/*   Future<Event> getEventByIdAndWeek(int id) async {
    var uri = Uri.https(BASE_URL, ('/api/Events/' + id.toString()));
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
    );
    return Event.fromJson(json.decode(response.body)['data']);
  } */

  Future<List<Event>> searchEventsByUser(String email) async {
    debugPrint('EVENTS BLOC - searchEventsByUser\n');
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
          'sorts': [
            {'path': 'Day', 'ascending': true}
          ],
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

        /* debugPrint('FUTURE 1+\N'+jsonEncode({
          'page': 1,
          'pageSize': 10,
          'sorts': [
            {'path': 'Day', 'ascending': true}
          ],
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
        })); */

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
        /* debugPrint('FUTURE 2\n'+jsonEncode({
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
        })); */

    if (json.decode(response1.body)['data']['data'] != []) {
      Iterable l = json.decode(response1.body)['data']['data'];
      userEvents1 = List<Event>.from(l.map((model) => Event.fromJson(model)));
    }

    for (var e in userEvents1) {
      if (!userEvents.contains(e)) {
        userEvents.add(e);
      }
    }

    // 1o ciclo for
      // se o lenght de weeks >1
        // ver se alguma dessas semanas é antes de hoje -  eliminar week
        // se for a semana de hoje - ignorar
        // se for semana futura - criar evento (entity Event) com todos os parametros iguais e essa week e adicionar ao userEvents

    // 2o ciclo for 
      // se data = today
        // vês se a start time é inferior à hora atual
          // se sim eliminar evento
    
    
    update(userEvents);

    return userEvents;
  }

  Future<List<Event>> searchPastEventsByUser(String email) async {
    debugPrint('EVENTS BLOC - searchPastEventsByUser\n');

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
          'sorts': [
            {'path': 'Day', 'ascending': true}
          ],
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
              'value': DateTime.now().subtract(Duration(days: DateTime.now().weekday-1)).toString(),
              'path': 'EventWeek.Week.StartDate'
            },
          ],
          'groups': [],
          'aggregates': []
        }));

        /* debugPrint('PAST 0 \n'+ jsonEncode({
          'page': 1,
          'pageSize': 10,
          'sorts': [
            {'path': 'Day', 'ascending': true}
          ],
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
              'value': DateTime.now().subtract(Duration(days: DateTime.now().weekday-1)).toString(),
              'path': 'EventWeek.Week.StartDate'
            },
          ],
          'groups': [],
          'aggregates': []
        }));
 */
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
        /* debugPrint('PAST2\n'+jsonEncode({
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
        })); */

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

    // 2o ciclo for 
      // se data = today
        // vês se a start time é superior à hora atual
          // se sim eliminar evento

    updatePast(userEvents);

    return userEvents;
  }

/*   Future<UserEvents> bookingsEvents(String email, int number) async {
    var uE = UserEvents(
        futureEvents: await searchEventsByUser(email, number),
        pastEvents: await searchPastEventsByUser(email));

    return uE; */
  //}

  Future<bool> removeEvent(int eventId, String email) async {
    debugPrint('EVENTS BLOC - removeEvent\n');
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
      debugPrint('------------------------------------------------------');
      return true;
    }
    return false;
  }

  Future<List<Event>> getAllClassroomEventsByTime(
      int classId, Week week) async {
    debugPrint('EVENTS BLOC - getAllClassroomEventsByTime\n');
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

      for (var item in events) {
        debugPrint(item.name);
      }
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
