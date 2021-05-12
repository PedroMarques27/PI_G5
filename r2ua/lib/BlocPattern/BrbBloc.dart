import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:r2ua/Entities/Building.dart';
import 'package:r2ua/Entities/ClassroomGroups.dart';
import 'package:r2ua/Entities/Classrooms.dart';
import 'package:r2ua/Entities/User.dart';

import 'BuildingBloc.dart';
import 'ClassroomGroupsBloc.dart';
import 'ClassroomsBloc.dart';
import 'UsersBloc.dart';

String token =
    "eyJhbGciOiJSUzI1NiIsImtpZCI6IjQ4M2YzZWI0YzA3N2RjMDFmMjQ5MzIyNDk5NDM3NGJmIiwidHlwIjoiSldUIn0.eyJuYmYiOjE2MjA3MjI3MTQsImV4cCI6MTYyMzMxNDcxNCwiaXNzIjoiaHR0cHM6Ly9idWxsZXQtaXMuZGV2LnVhLnB0IiwiYXVkIjpbImh0dHBzOi8vYnVsbGV0LWlzLmRldi51YS5wdC9yZXNvdXJjZXMiLCJiZXN0bGVnYWN5X2FwaV9yZXNvdXJjZSJdLCJjbGllbnRfaWQiOiJyb29tX2Rpc3BsYXllciIsImNsaWVudF9jcmVhdGVfY2xhaW0iOiJ0cnVlIiwiY2xpZW50X3VwZGF0ZV9jbGFpbSI6InRydWUiLCJjbGllbnRfZGVsZXRlX2NsYWltIjoidHJ1ZSIsImNsaWVudF9yZWFkX2NsYWltIjoidHJ1ZSIsInNjb3BlIjpbImJlc3RsZWdhY3lfYXBpX3Njb3BlIl19.cFimUrako7Kj1ZnVs2WV-lO19fh4pbXAnYc4YbKVLK07J0TuTRHphQVwStbmhn_lzb97OnATtZ5MtSPvm61-VNNxaR5sIEZVZt6szqdrCTH2EG35R8NEh4X0SLyDxIWDtJ6lFbMKgklORHLpkbC1RFALJmTlBsB0D6gR6PRQcG8D0Dj3Vm2ioDRFhst9YYzbvP8In_pb-TldkISqBSWzDjj-y3tLpngiQaRHqKjl4-LAosCq9-AdNaKSb6c3pIO2yFW8s6bf2xqGdZvC-wNlQ4RdA8mi2vkGVyuhJTicycEdaOPkiDKFq-lWIEm8MCivwUnoiaCW1jL8PIcU-Iw4UQ";
String BASE_URL = 'bullet-api.dev.ua.pt';

class BrbBloc {
  StreamController<List<BuildCount>> buildCountStreamController =
      StreamController<List<BuildCount>>.broadcast();
  Stream get getBuildCount => buildCountStreamController.stream;

  void update(List<BuildCount> b) {
    buildCountStreamController.sink
        .add(b); // add whatever data we want into the Sink
  }

  void dispose() {
    buildCountStreamController
        .close(); // close our StreamController to emory leak
  }

  User currentUser;
  Stream<User> userSubscription = usersBloc.getUser;
  void initialize(String email) {
    userSubscription.listen((newuser) {
      this.currentUser = newuser as User;
      getClassroomGroupsBuildings(currentUser.classroomGroupsId);
    });
    usersBloc.getCurrentUser(email);
  }

  void getClassroomGroupsBuildings(List<String> groupsIds) async {
    HashMap<int, int> buildings = new HashMap<int, int>();
    HashMap<int, List<int>> buildingsClassrooms = new HashMap<int, List<int>>();

    for (var id in groupsIds) {
      ClassroomGroup csg =
          await classroomGroupsBloc.getCurrentClassroomGroup(id);
      for (int classId in csg.classrooms) {
        Classroom cls = await classroomsBloc.getClassroomById(classId);
        int count = 0;
        List<int> classIDs = new List<int>();
        if (buildings.containsKey(cls.building)) {
          count = buildings[cls.building];
          classIDs = buildingsClassrooms[cls.building];
        }
        buildings[cls.building] = count + 1;
        classIDs.add(cls.id);
        buildingsClassrooms[cls.building] = classIDs;
        debugPrint(count.toString() + "--------");
      }
    }

    HashMap<Building, int> _buildings = new HashMap<Building, int>();
    List<BuildCount> counting = new List<BuildCount>();
    for (int item in buildings.keys) {
      Building b = await buildingBloc.getBuildingById(item);
      debugPrint(buildings[b].toString() + "--------");
      counting.add(BuildCount(
          building: b,
          count: buildings[b.id],
          classroomsIDs: buildingsClassrooms[b.id]));
    }

    update(counting);
  }
}

class BuildCount {
  Building building;
  int count;
  List<int> classroomsIDs;
  BuildCount({this.building, this.count, this.classroomsIDs});
}

final usersBloc = UsersBloc();
final buildingBloc = BuildingBloc();
final classroomGroupsBloc = ClassroomGroupsBloc();
final classroomsBloc = ClassroomsBloc();
final brbBloc = BrbBloc();
