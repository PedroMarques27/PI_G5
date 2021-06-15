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
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
    );

    // final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    // pattern.allMatches(response.body).forEach((match) => print(match.group(0)));

    Iterable l = json.decode(response.body)['data'];
    var users = List<User>.from(l.map((model) => User.fromJson(model)));

    // Map<String, dynamic> myMap = json.decode(response.body);
    // List<dynamic> entitlements = myMap["data"][0]["Entitlements"];
    // entitlements.forEach((entitlement) {
    //   (entitlement as Map<String, dynamic>).forEach((key, value) {
    //     print(key);
    //     (value as Map<String, dynamic>).forEach((key2, value2) {
    //       print(key2);
    //       print(value2);
    //     });
    //   });
    // });
    debugPrint('FINISH');
    return users;
  }

  void getCurrentUser(String email) async {
    debugPrint(
        'HERE---------------------------------------------------------------');
    var users = await getData('/api/Users');
    var x = users.length;
    debugPrint('no USERs: $x');
    for (var u in users) {
      if (u.email == email) {
        update(u);
        var y = u.userName;
        debugPrint('USER: $y');
        return;
      }
    }
  }
}
