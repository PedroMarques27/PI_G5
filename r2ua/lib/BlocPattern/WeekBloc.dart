import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:r2ua/Entities/Week.dart';
import 'BrbBloc.dart';

class WeekBloc {
  StreamController<List<Week>> usersStreamController =
      StreamController<List<Week>>.broadcast();
  Stream get getWeekList => usersStreamController.stream;
  List<Week> latest = <Week>[];
  void update(List<Week> b) {
    usersStreamController.sink
        .add(b); // add whatever data we want into the Sink
  }

  void dispose() {
    usersStreamController.close(); // close our StreamController to emory leak
  }

  void stop() {}

  Future<List<Week>> getWeeks() async {
    var uri =
        Uri.https(BASE_URL, '/api/Weeks/starting/' + DateTime.now().toString());
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
    );

    Iterable l = json.decode(response.body)['data'];
    var weeks = List<Week>.from(l.map((model) => Week.fromJson(model)));
    latest = weeks;
    update(weeks);
    return weeks;
  }
}
