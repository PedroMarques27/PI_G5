import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:r2ua/Entities/ClassroomGroups.dart';
import 'package:r2ua/Entities/Classrooms.dart';

import 'package:http/http.dart' as http;
import 'BrbBloc.dart';

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

  Future<ClassroomGroup> getCurrentClassroomGroup(int id) async {
    var uri =
        Uri.https(BASE_URL, "/api/ClassroomGroupBooking/" + id.toString());
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
