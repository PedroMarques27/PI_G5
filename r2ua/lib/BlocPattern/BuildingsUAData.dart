import 'dart:async';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:r2ua/BlocPattern/BrbBloc.dart';
import 'package:r2ua/Entities/BuildingsUA.dart';
import 'package:geolocator/geolocator.dart';

var buildingsUA = <BuildingsUA>[
  BuildingsUA(
      brbBuildingName: 'DAO',
      brbBuildingId: 8,
      realBuildingName: 'Ambiente e Ordenamento',
      lat: 40.632583,
      long: -8.659139),
  BuildingsUA(
      brbBuildingName: 'BIO',
      brbBuildingId: 4,
      realBuildingName: 'Biologia',
      lat: 40.633801,
      long: -8.659570),
  BuildingsUA(
      brbBuildingName: 'SACS',
      brbBuildingId: 18,
      realBuildingName: 'Ciências Médicas',
      lat: 40.623398,
      long: -8.657693),
  //NOT SURE do brb b name
  BuildingsUA(
      brbBuildingName: 'CSJP',
      brbBuildingId: 7,
      realBuildingName: 'Ciências Sociais, Políticas e do Território',
      lat: 40.629963,
      long: -8.658114),
  BuildingsUA(
      brbBuildingName: 'DCA',
      brbBuildingId: 9,
      realBuildingName: 'Comunicação e Arte',
      lat: 40.629560,
      long: -8.656936),
  BuildingsUA(
      brbBuildingName: 'EGI',
      brbBuildingId: 12,
      realBuildingName: 'Economia, Gestão, Engenharia Industrial e Turismo',
      lat: 40.630837,
      long: -8.657075),
  BuildingsUA(
      brbBuildingName: 'DEP',
      brbBuildingId: 19,
      realBuildingName: 'Educação e Psicologia',
      lat: 40.631831,
      long: -8.658887),
  BuildingsUA(
      brbBuildingName: 'DET',
      brbBuildingId: 10,
      realBuildingName: 'Eletrónica, Telecomunicações e Informática',
      lat: 40.633248,
      long: -8.659273),
  BuildingsUA(
      brbBuildingName: 'MEC',
      brbBuildingId: 16,
      realBuildingName: 'Engenharia de Materiais e Cerâmica',
      lat: 40.634078,
      long: -8.658745),
  // N TEM NO BRB??????????????? /mudar name e id)
  BuildingsUA(
      brbBuildingName: 'MEC',
      brbBuildingId: 16,
      realBuildingName: 'Engenharia Civil',
      lat: 40.629574,
      long: -8.657511),
  // N TEM NO BRB??????????????? /mudar name e id)
  BuildingsUA(
      brbBuildingName: 'MEC',
      brbBuildingId: 16,
      realBuildingName: 'Engenharia Mecânica',
      lat: 40.629728,
      long: -8.657860),
  BuildingsUA(
      brbBuildingName: 'FIS',
      brbBuildingId: 14,
      realBuildingName: 'Física',
      lat: 40.630347,
      long: -8.656610),
  BuildingsUA(
      brbBuildingName: 'GEO',
      brbBuildingId: 15,
      realBuildingName: 'Geociências',
      lat: 40.629570032385764,
      long: -8.656961999631745),
  BuildingsUA(
      brbBuildingName: 'DLC',
      brbBuildingId: 11,
      realBuildingName: 'Línguas e Culturas',
      lat: 40.629570032385764,
      long: -8.656961999631745),
  BuildingsUA(
      brbBuildingName: 'MAT',
      brbBuildingId: 1,
      realBuildingName: 'Matemática',
      lat: 40.630307,
      long: -8.658281),
  BuildingsUA(
      brbBuildingName: 'QUIM',
      brbBuildingId: 17,
      realBuildingName: 'Química',
      lat: 40.629560,
      long: -8.656936),

  BuildingsUA(
      brbBuildingName: 'STIC',
      brbBuildingId: 24,
      realBuildingName: 'Serviços de Tecnologias de informação e Comunicação',
      lat: 40.6300705381147,
      long: -8.65877095378503)
];

class BuildingUAData {
  StreamController<List<BuildingDistance>> buildingsUAStreamController =
      StreamController<List<BuildingDistance>>.broadcast();
  Stream get getBuildingsUA => buildingsUAStreamController.stream;

  void update(List<BuildingDistance> b) {
    buildingsUAStreamController.sink.add(b);
  }

  void dispose() {
    buildingsUAStreamController.close();
  }

  Future<List<BuildingDistance>> getBuildingsNearByUser(
      List<BuildCount> buildings) async {
    //var box = await Hive.openBox<BuildingsUA>('buildingsUA');
    //box values
    //var list = box.values.toList();
    //ADD buildings IDS
    var buildingsIds = new List<int>();

    for (var b in buildings) {
      buildingsIds.add(b.building.id);
    }

    var g = Geolocator();

    //user position
    var position =
        await g.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    var buildingsUADistance = <BuildingDistance>[];
    var i = 0;
    for (var b in buildingsUA) {
      i++;

      if (buildingsIds.contains(b.brbBuildingId)) {
        var distanceInMeters = await g.distanceBetween(
            position.latitude, position.longitude, b.lat, b.long);

        buildingsUADistance.add(BuildingDistance(
            buildingsUA: b,
            buildingDistance:
                num.parse((distanceInMeters / 1000).toStringAsFixed(2))));
      }
    }

    update(buildingsUADistance);
    return buildingsUADistance;
  }
}

class BuildingDistance {
  BuildingsUA buildingsUA;
  double buildingDistance;
  // ignore: sort_constructors_first
  BuildingDistance({this.buildingsUA, this.buildingDistance});
}
