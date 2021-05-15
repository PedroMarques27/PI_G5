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
  String getCurrentWeek() {
    // Seg: 1
    // assumindo que domingo é 7

    String date = DateTime.now().toString();
    String firstDay = date.substring(0, 8) + '01' + date.substring(10);
    int weekDay = DateTime.parse(firstDay).weekday;
    int todayDay = DateTime.now().day;
    int wholeWeeksSinceDayOne = ((todayDay - 1) / 7).floor();
    int beginningOfThisWeek = weekDay + 7 * wholeWeeksSinceDayOne;

    print("BEGINNING OF WEEK     " + beginningOfThisWeek.toString());

    return beginningOfThisWeek.toString() +
        "/" +
        DateTime.now().month.toString() +
        "/" +
        DateTime.now().year.toString();
  }
}
