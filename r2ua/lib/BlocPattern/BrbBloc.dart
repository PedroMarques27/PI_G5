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
    buildCountStreamController.sink.add(b);
  }

  void dispose() {
    buildCountStreamController.close();
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
    List<ClassroomGroup> classGroups = new List<ClassroomGroup>();
    for (var id in groupsIds) {
      classGroups.add(await classroomGroupsBloc.getCurrentClassroomGroup(id));
    }
    HashSet<int> classroomsIds = new HashSet<int>();
    for (var classG in classGroups) {
      classroomsIds.addAll(classG.classrooms);
    }

    HashSet<Classroom> classes = new HashSet<Classroom>();
    HashMap<int, Building> codesBuildings = new HashMap();
    List<BuildCount> data = new List<BuildCount>();
    for (var classId in classroomsIds) {
      Classroom cs = (await classroomsBloc.getClassroomById(classId));

      Building currentBuilding;
      if (codesBuildings.containsKey(cs.building)) {
        currentBuilding = codesBuildings[cs.building];
        for (var d in data) {
          if (d.building.id == cs.building) {
            d.classrooms.add(cs);
            d.count = d.classrooms.length;
          }
        }
      } else {
        currentBuilding = await buildingBloc.getBuildingById(cs.building);
        codesBuildings[cs.building] = currentBuilding;
        List<Classroom> _temp = new List<Classroom>();
        _temp.add(cs);
        data.add(new BuildCount(
            building: currentBuilding, classrooms: _temp, count: 1));
      }

      update(data);
    }
  }
}

class BuildCount {
  Building building;
  int count;
  List<Classroom> classrooms;
  BuildCount({this.building, this.count, this.classrooms});
}

final usersBloc = UsersBloc();
final buildingBloc = BuildingBloc();
final classroomGroupsBloc = ClassroomGroupsBloc();
final classroomsBloc = ClassroomsBloc();
final brbBloc = BrbBloc();
