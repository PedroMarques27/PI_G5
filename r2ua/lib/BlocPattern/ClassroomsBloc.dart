import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:r2ua/Entities/Classrooms.dart';

import 'package:http/http.dart' as http;
import 'BrbBloc.dart';

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
