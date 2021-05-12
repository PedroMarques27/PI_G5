import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:r2ua/Entities/Building.dart';

import 'package:http/http.dart' as http;
import 'BrbBloc.dart';

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
