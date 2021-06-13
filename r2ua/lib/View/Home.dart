import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
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
  var bUA = new List<BuildingDistance>();

  Future init(List<BuildCount> listOfBuildCount) async {
    debugPrint(bUA.length.toString() + ' ---------BuildingDistance');

    var temp = await buildingsUAData.getBuildingsNearByUser(listOfBuildCount);
    setState(() {
      bUA = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildList(context));
  }

  Widget _buildList(BuildContext context) {
    return StreamBuilder(
        stream: buildingsUAData.getBuildingsUA,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            debugPrint('NO DATA');
            return Center(child: CircularProgressIndicator());
          }
          buildingDistances = snapshot.data as List;

          debugPrint(
              buildingDistances.first.buildingsUA.realBuildingName.toString() +
                  'llllllllllllllllllllllllll');

          return SingleChildScrollView(
              child: Column(children: [
            Container(
                height: MediaQuery.of(context).size.height / 2.3,
                alignment: Alignment.topCenter,
                margin: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Orders',
                          textScaleFactor: 1.0, // disables accessibility
                          style: TextStyle(
                            fontSize: 30.0,
                          ),
                        ),
                      )),
                      Divider(height: 10, thickness: 2, color: Colors.red[400]),
                      Expanded(
                          child: ListView.builder(
                              itemCount: buildingDistances.length,
                              itemBuilder: (context, position) {
                                return Expanded(
                                    child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: Card(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                buildingDistances[position]
                                                    .buildingsUA
                                                    .realBuildingName
                                                    .toString(),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                buildingDistances[position]
                                                        .buildingDistance
                                                        .toString() +
                                                    ' m',
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                              }))
                    ])),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '${selectedDate.toLocal()}'.split(' ')[0],
                  style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  onPressed: () => _selectDate(context),
                  color: Colors.greenAccent, // Refer step 3
                  child: Text(
                    'Select date',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ]));
        });
  }

  _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  List<BuildingDistance> buildingDistances = new List<BuildingDistance>();

  DateTime selectedDate = DateTime.now();
  void _getCurrentLocation() async {}
  @override
  void initState() {
    super.initState();

    brbBloc.getBuildCount.listen((listOfBuildCount) {
      debugPrint('VVVVVVVVVVVVVVVV');

      init(listOfBuildCount);
    });

    debugPrint('(((((((((((((');

    var buildingStream = brbBloc.getBuildCount;
  }

  //HERE
  @override
  void getPermissionStatus() async {
    var permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission == PermissionStatus.granted) {
    } // ideally you should specify another condition if permissions is denied
    else if (permission == PermissionStatus.denied ||
        permission == PermissionStatus.restricted) {
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      getPermissionStatus();
    }
  }
}
