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

String token =
    "eyJhbGciOiJSUzI1NiIsImtpZCI6IjQ4M2YzZWI0YzA3N2RjMDFmMjQ5MzIyNDk5NDM3NGJmIiwidHlwIjoiSldUIn0.eyJuYmYiOjE2MjA3MjI3MTQsImV4cCI6MTYyMzMxNDcxNCwiaXNzIjoiaHR0cHM6Ly9idWxsZXQtaXMuZGV2LnVhLnB0IiwiYXVkIjpbImh0dHBzOi8vYnVsbGV0LWlzLmRldi51YS5wdC9yZXNvdXJjZXMiLCJiZXN0bGVnYWN5X2FwaV9yZXNvdXJjZSJdLCJjbGllbnRfaWQiOiJyb29tX2Rpc3BsYXllciIsImNsaWVudF9jcmVhdGVfY2xhaW0iOiJ0cnVlIiwiY2xpZW50X3VwZGF0ZV9jbGFpbSI6InRydWUiLCJjbGllbnRfZGVsZXRlX2NsYWltIjoidHJ1ZSIsImNsaWVudF9yZWFkX2NsYWltIjoidHJ1ZSIsInNjb3BlIjpbImJlc3RsZWdhY3lfYXBpX3Njb3BlIl19.cFimUrako7Kj1ZnVs2WV-lO19fh4pbXAnYc4YbKVLK07J0TuTRHphQVwStbmhn_lzb97OnATtZ5MtSPvm61-VNNxaR5sIEZVZt6szqdrCTH2EG35R8NEh4X0SLyDxIWDtJ6lFbMKgklORHLpkbC1RFALJmTlBsB0D6gR6PRQcG8D0Dj3Vm2ioDRFhst9YYzbvP8In_pb-TldkISqBSWzDjj-y3tLpngiQaRHqKjl4-LAosCq9-AdNaKSb6c3pIO2yFW8s6bf2xqGdZvC-wNlQ4RdA8mi2vkGVyuhJTicycEdaOPkiDKFq-lWIEm8MCivwUnoiaCW1jL8PIcU-Iw4UQ";
String BASE_URL = 'bullet-api.dev.ua.pt';

class BuildingBloc {
  StreamController<List<Building>> buildingsStreamController =
      StreamController<List<Building>>.broadcast();
  Stream get getBuildingList => buildingsStreamController.stream;

  void update(List<Building> b) {
    buildingsStreamController.sink
        .add(b); // add whatever data we want into the Sink
  }

  void dispose() {
    buildingsStreamController
        .close(); // close our StreamController to emory leak
  }

  Future<List<Building>> getData(String url) async {
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
    List<Building> buildings =
        List<Building>.from(l.map((model) => Building.fromJson(model)));

    return buildings;
  }

  void getAllBuildings() async {
    List<Building> builds = await getData("/api/Buildings/active");
    update(builds);
  }

  Future<Building> getBuildingById(int id) async {
    var uri = Uri.https(BASE_URL, ("/api/Buildings/" + id.toString()));
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        HttpHeaders.contentTypeHeader: "application/json",
        "Access-Control-Allow-Origin": "*"
      },
    );
    return Building.fromJson(json.decode(response.body)['data']);
  }
}

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

class ClassroomsBloc {
  StreamController<List<Classroom>> classroomStreamController =
      StreamController<List<Classroom>>.broadcast();
  Stream get getClassrooms => classroomStreamController.stream;

  void update(List<Classroom> b) {
    classroomStreamController.sink
        .add(b); // add whatever data we want into the Sink
  }

  void dispose() {
    classroomStreamController
        .close(); // close our StreamController to emory leak
  }

  Future<List<Classroom>> getData(String url) async {
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
    List<Classroom> classroom =
        List<Classroom>.from(l.map((model) => Classroom.fromJson(model)));

    return classroom;
  }

  Future<Classroom> getClassroomById(int id) async {
    var uri = Uri.https(BASE_URL, "/api/Classrooms/" + id.toString());
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        HttpHeaders.contentTypeHeader: "application/json",
        "Access-Control-Allow-Origin": "*"
      },
    );
    return Classroom.fromJson(json.decode(response.body)['data']);
  }

  Future<List<Classroom>> getClassroomsByIdList(List<int> classIDs) async {
    List<Classroom> classes = new List<Classroom>();
    for (var id in classIDs) {
      Classroom c = await getClassroomById(id);
      classes.add(c);
    }
    update(classes);

    return classes;
  }
}

class ClassroomGroupsBloc {
  StreamController<List<Classroom>> classroomStreamController =
      StreamController<List<Classroom>>.broadcast();
  Stream get getClassrooms => classroomStreamController.stream;

  void update(List<Classroom> b) {
    classroomStreamController.sink
        .add(b); // add whatever data we want into the Sink
  }

  void dispose() {
    classroomStreamController
        .close(); // close our StreamController to emory leak
  }

  Future<List<ClassroomGroup>> getData(String url) async {
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
    List<ClassroomGroup> classroom = List<ClassroomGroup>.from(
        l.map((model) => ClassroomGroup.fromJson(model)));

    return classroom;
  }

  Future<ClassroomGroup> getCurrentClassroomGroup(String id) async {
    var uri = Uri.https(BASE_URL, "/api/ClassroomGroups/" + id);
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        HttpHeaders.contentTypeHeader: "application/json",
        "Access-Control-Allow-Origin": "*"
      },
    );
    return ClassroomGroup.fromJson(json.decode(response.body)['data']);
  }
}

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
