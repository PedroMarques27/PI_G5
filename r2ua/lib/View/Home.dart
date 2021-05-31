import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:r2ua/Entities/BuildingsUA.dart';
import 'package:r2ua/Entities/Event.dart';
import 'package:r2ua/db/BuildingsUAData.dart';

import 'Bookings.dart';
import 'Search.dart';
import 'package:r2ua/Entities/User.dart';
import 'package:r2ua/BlocPattern/BrbBloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:r2ua/db/BuildingsUAData.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("Bookings"));
  }
}

/*
 //TODO: retornar a lista de Buildings
class _Home extends State<Home> {
  
  Widget _buildList(BuildContext context) {
    return StreamBuilder(
      
    stream: brbBloc.getBuildCount,
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        debugPrint("NO DATA");
        return Center(child: CircularProgressIndicator());
      }


  List<BuildingsUA> buildings = new List<>();


  void _getCurrentLocation() async {}
  @override
  void initialize() {
    Stream buildingStream = brbBloc.getBuildCount;
    buildingStream.listen((listOfBuildCount) {
      BuildingUAData buildingsUADb = new BuildingUAData();
    
      buildingsUADb.getBuildingsNearByUser(listOfBuildCount);
     
      
    });
  }




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  } */
