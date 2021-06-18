import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:r2ua/BlocPattern/BookNearbyEventsBloc.dart';
import 'package:r2ua/Entities/Building.dart';
import 'package:r2ua/View/BuildingsClassrooms.dart';

import 'package:r2ua/BlocPattern/BrbBloc.dart';

class BookNearby extends StatefulWidget {
  BookNearby(
      {Key key,
      this.title,
      this.email,
      this.buildings,
      this.date,
      this.startTime})
      : super(key: key);

  final String title;
  final String email;
  List<Building> buildings;
  final DateTime date;
  final String startTime;

  @override
  _BookNearby createState() => _BookNearby();
}

class _BookNearby extends State<BookNearby> {
  Map<Building, List<AvailableClassroomOnTime>> currentList =
      <Building, List<AvailableClassroomOnTime>>{};
  List<Building> buildings;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Classrooms Nearby')),
      body: Container(child: _buildList(context)),
    );     
  }

  Widget _buildList(BuildContext context) {
    bookNearbyEventsBloc.searchClassroomsBuildings(
        widget.buildings, widget.date, widget.startTime);

    return StreamBuilder(
        stream: bookNearbyEventsBloc.getNearbyMap,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          currentList = (snapshot.data) as Map;
          buildings = currentList.keys.toList();
          debugPrint(currentList[buildings[0]].toString());

          return Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Book nearby', style: TextStyle(fontSize: 22.0)),
                    ],
                  )),
              Expanded(
                child: ListView.builder(
                  itemCount: buildings.length,
                  itemBuilder: (context, position) {
                    return GestureDetector(
                      child: Container(
                        margin: EdgeInsets.all(2),
                        padding: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(
                            color: Colors.grey[300],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: ListView.builder(
                                            itemCount:
                                                currentList[buildings[position]]
                                                    .length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      currentList[buildings[
                                                                      position]]
                                                                  [index]
                                                              .startTime +
                                                          ' - ET ' +
                                                          currentList[buildings[
                                                                      position]]
                                                                  [index]
                                                              .endTime +
                                                          ' - ClassID' +
                                                          currentList[buildings[
                                                                      position]]
                                                                  [index]
                                                              .classroom
                                                              .id
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 17),
                                                    )
                                                  ],
                                                ),
                                              );
                                            })),
                                  )
                                ])),
                      ),
                    );
                  },
                ),
              )
            ],
          );
        });
  }

  //navega para outra page
  void goToClassroomsPerBuildingPage(
      BuildContext context, BuildCount data, String email) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BuildingsClassrooms(
                buildCount: data,
                email: email,
              )),
    );
  }
}
