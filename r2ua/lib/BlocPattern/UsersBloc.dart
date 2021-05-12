import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:r2ua/Entities/User.dart';
import 'BrbBloc.dart';

class UsersBloc {
  StreamController<User> usersStreamController =
      StreamController<User>.broadcast();
  Stream get getUser => usersStreamController.stream;

  void update(User b) {
    usersStreamController.sink
        .add(b); // add whatever data we want into the Sink
  }

  void dispose() {
    usersStreamController.close(); // close our StreamController to emory leak
  }

  void stop() {}

  Future<List<User>> getData(String url) async {
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
    List<User> users = List<User>.from(l.map((model) => User.fromJson(model)));

    return users;
  }

  void getCurrentUser(String email) async {
    List<User> users = await getData("/api/Users");

    for (User u in users) {
      if (u.email == email) {
        update(u);
        return;
      }
    }
  }
}
