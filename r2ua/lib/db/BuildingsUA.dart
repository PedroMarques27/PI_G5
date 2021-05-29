import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:r2ua/Entities/BuildingsUA.dart';
import 'package:geolocator/geolocator.dart';

class BuildingUAData extends ChangeNotifier {
  List<BuildingsUA> buildingsUA = [];

  //add buildings to box
  void getBuildingsUA() async {
    var box = await Hive.openBox<BuildingsUA>("buildingsUA");
    //add complete data
    BuildingsUA b1 = new BuildingsUA(
        brbBuildingName: "DAO",
        brbBuildingId: 8,
        realBuildingName: "Ambiente e Ordenamento",
        lat: 40.632583,
        long: -8.659139);
    await box.add(b1);
    BuildingsUA b2 = new BuildingsUA(
        brbBuildingName: "BIO",
        brbBuildingId: 4,
        realBuildingName: "Biologia",
        lat: 40.633801,
        long: -8.659570);
    await box.add(b2);
    BuildingsUA b3 = new BuildingsUA(
        brbBuildingName: "SACS",
        brbBuildingId: 18,
        realBuildingName: "Ciências Médicas",
        lat: 40.623398,
        long: -8.657693);
    await box.add(b3);
    //NOT SURE do brb b name
    BuildingsUA b4 = new BuildingsUA(
        brbBuildingName: "CSJP",
        brbBuildingId: 7,
        realBuildingName: "Ciências Sociais, Políticas e do Território",
        lat: 40.629963,
        long: -8.658114);
    await box.add(b4);
    BuildingsUA b5 = new BuildingsUA(
        brbBuildingName: "DCA",
        brbBuildingId: 9,
        realBuildingName: "Comunicação e Arte",
        lat: 40.629560,
        long: -8.656936);
    await box.add(b5);
    BuildingsUA b6 = new BuildingsUA(
        brbBuildingName: "EGI",
        brbBuildingId: 12,
        realBuildingName: "Economia, Gestão, Engenharia Industrial e Turismo",
        lat: 40.630837,
        long: -8.657075);
    await box.add(b6);
    BuildingsUA b7 = new BuildingsUA(
        brbBuildingName: "DEP",
        brbBuildingId: 19,
        realBuildingName: "Educação e Psicologia",
        lat: 40.631831,
        long: -8.658887);
    await box.add(b7);
    BuildingsUA b8 = new BuildingsUA(
        brbBuildingName: "DET",
        brbBuildingId: 10,
        realBuildingName: "Eletrónica, Telecomunicações e Informática",
        lat: 40.633248,
        long: -8.659273);
    await box.add(b8);
    BuildingsUA b9 = new BuildingsUA(
        brbBuildingName: "MEC",
        brbBuildingId: 16,
        realBuildingName: "Engenharia de Materiais e Cerâmica",
        lat: 40.634078,
        long: -8.658745);
    await box.add(b9);
    // N TEM NO BRB??????????????? /mudar name e id)
    BuildingsUA b10 = new BuildingsUA(
        brbBuildingName: "MEC",
        brbBuildingId: 16,
        realBuildingName: "Engenharia Civil",
        lat: 40.629574,
        long: -8.657511);
    await box.add(b10);

    // N TEM NO BRB??????????????? /mudar name e id)
    BuildingsUA b11 = new BuildingsUA(
        brbBuildingName: "MEC",
        brbBuildingId: 16,
        realBuildingName: "Engenharia Mecânica",
        lat: 40.629728,
        long: -8.657860);
    await box.add(b11);

    BuildingsUA b12 = new BuildingsUA(
        brbBuildingName: "FIS",
        brbBuildingId: 14,
        realBuildingName: "Física",
        lat: 40.630347,
        long: -8.656610);
    await box.add(b12);
    BuildingsUA b13 = new BuildingsUA(
        brbBuildingName: "GEO",
        brbBuildingId: 15,
        realBuildingName: "Geociências",
        lat: 40.629570032385764,
        long: -8.656961999631745);
    await box.add(b13);
    BuildingsUA b14 = new BuildingsUA(
        brbBuildingName: "DLC",
        brbBuildingId: 11,
        realBuildingName: "Línguas e Culturas",
        lat: 40.629570032385764,
        long: -8.656961999631745);
    await box.add(b14);
    BuildingsUA b15 = new BuildingsUA(
        brbBuildingName: "MAT",
        brbBuildingId: 1,
        realBuildingName: "Matemática",
        lat: 40.630307,
        long: -8.658281);
    await box.add(b15);

    BuildingsUA b16 = new BuildingsUA(
        brbBuildingName: "QUIM",
        brbBuildingId: 17,
        realBuildingName: "Química",
        lat: 40.629560,
        long: -8.656936);
    await box.add(b16);

    BuildingsUA b17 = new BuildingsUA(
        brbBuildingName: "STIC",
        brbBuildingId: 00,
        realBuildingName: "Serviços de Tecnologias de informação e Comunicação",
        lat: 40.6300705381147,
        long: -8.65877095378503);
    await box.add(b17);
  }

  Future<List<BuildingsUA>> getBuildingsNearByUser() async {
    List<BuildingsUA> buildingsUAa = [];
    Geolocator g = new Geolocator();
    //user position
    Position position =
        await g.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    for (var buildingUA in buildingsUA) {
      if (g.distanceBetween(position.latitude, position.longitude,
              buildingUA.lat, buildingUA.long) <
          40) {}
    }
    Future<double> distanceInMeters =
        g.distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);

    return buildingsUAa;
  }
}
