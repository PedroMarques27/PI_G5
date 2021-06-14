import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:r2ua/Entities/Event.dart';

import 'package:r2ua/BlocPattern/BuildingsUAData.dart';
import 'BrbBloc.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'EventsBloc.dart';

class HomeBloc {
  StreamController<HomeData> homeViewStreamController =
      StreamController<HomeData>.broadcast();
  Stream get getHomeData => homeViewStreamController.stream;

  Event event;
  var events = <Event>[];
  var buildingsDistance = <BuildingDistance>[];
  var buildingClasses = <BuildCount>[];

  Future<void> startCapturing() async {
    eventsBloc.getListOfEvents.listen((event) {
      events = event;
      update();
    });

    buildingsUAData.getBuildingsUA.listen((list) {
      buildingsDistance = list;
      update();
    });

    brbBloc.getBuildCount.listen((list) {
      buildingClasses = list;
      update();
    });
  }

  void update() {
    var data = createBuildingsList();
    homeViewStreamController.sink
        .add(HomeData(events, data)); // add whatever data we want into the Sink
  }

  void dispose() {
    homeViewStreamController.close();
  }

  List<BuildingsData> createBuildingsList() {
    var toReturn = <BuildingsData>[];
    for (var v in buildingsDistance) {
      var id = v.buildingsUA.brbBuildingId;
      var buildingsInfo = BuildingsData();
      for (var b in buildingClasses) {
        if (b.building.id == id) {
          buildingsInfo.buildingsClassrooms = b;
          buildingsInfo.buildingsDistance = v;
          toReturn.add(buildingsInfo);
          break;
        }
      }
    }
    return toReturn;
  }
}

class BuildingsData {
  BuildingDistance buildingsDistance = BuildingDistance();
  BuildCount buildingsClassrooms = BuildCount();
}

class HomeData {
  List<Event> events = <Event>[];
  List<BuildingsData> buildings = <BuildingsData>[];
  HomeData(this.events, this.buildings);
}
