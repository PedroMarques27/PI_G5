import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:r2ua/BlocPattern/BookNearbyEventsBloc.dart';
import 'package:r2ua/BlocPattern/BuildingsUAData.dart';
import 'package:r2ua/BlocPattern/HomeBloc.dart';
import 'package:r2ua/Entities/Building.dart';

import 'package:r2ua/BlocPattern/BrbBloc.dart';
import 'package:r2ua/View/CreateEventNearby.dart';

// ignore: must_be_immutable
class BookNearby extends StatefulWidget {
  BookNearby(
      {Key key,
      this.title,
      this.email,
      this.buildings,
      this.date,
      this.startTime,
      this.buildingsUAData})
      : super(key: key);

  final String title;
  final String email;
  List<Building> buildings;
  final DateTime date;
  final String startTime;
  final List<BuildingsData> buildingsUAData;

  @override
  _BookNearby createState() => _BookNearby();
}

class _BookNearby extends State<BookNearby> {
  Map<Building, List<AvailableClassroomOnTime>> currentList =
      <Building, List<AvailableClassroomOnTime>>{};
  List<Building> buildings;
  List<BuildingsData> buildingsUAData;
  @override
  void initState() {
    super.initState();
    buildingsUAData = widget.buildingsUAData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Classrooms Nearby')),
      body: Container(child: _buildList(context)),
    );
  }

  double getDistanceByBuilding(int bId) {
    for (var b in buildingsUAData) {
      if (b.buildingsClassrooms.building.id == bId) {
        return b.buildingsDistance.buildingDistance;
      }
    }
    return 0;
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

          return Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                          'Date: ' +
                              widget.date
                                  .toString()
                                  .substring(0, 10)
                                  .split('-')[2] +
                              '/' +
                              widget.date
                                  .toString()
                                  .substring(0, 10)
                                  .split('-')[1] +
                              '/' +
                              widget.date
                                  .toString()
                                  .substring(0, 10)
                                  .split('-')[0],
                          style: TextStyle(fontSize: 18.0)),
                      Text('Start Time: ' + widget.startTime + 'h',
                          style: TextStyle(fontSize: 18.0)),
                    ],
                  )),
              Container(
                child: Expanded(
                  child: ListView.builder(
                    itemCount: buildings.length,
                    itemBuilder: (context, position) {
                      return Container(
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(children: <Widget>[
                              Expanded(
                                child: Container(
                                    height: MediaQuery.of(context).size.height,
                                    child: ListView.builder(
                                        itemCount:
                                            currentList[buildings[position]]
                                                .length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            margin: EdgeInsets.all(2),
                                            padding: EdgeInsets.all(6.0),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              border: Border.all(
                                                  color: Colors.grey[300]),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                            currentList[buildings[
                                                                        position]]
                                                                    [index]
                                                                .classroom
                                                                .name,
                                                            style: TextStyle(
                                                                fontSize: 17))),
                                                    Text('Capacity: ' +
                                                        currentList[buildings[
                                                                    position]]
                                                                [index]
                                                            .classroom
                                                            .capacity
                                                            .toString()),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text('Building: ' +
                                                            buildings[position]
                                                                .name +
                                                            ' (' +
                                                            getDistanceByBuilding(
                                                                    buildings[
                                                                            position]
                                                                        .id)
                                                                .toStringAsPrecision(
                                                                    2) +
                                                            'Km Away)'),
                                                        Text(
                                                            ' ' +
                                                                currentList[buildings[
                                                                            position]]
                                                                        [index]
                                                                    .startTime +
                                                                'h - ' +
                                                                currentList[buildings[
                                                                            position]]
                                                                        [index]
                                                                    .endTime +
                                                                'h',
                                                            style: TextStyle(
                                                                color: currentList[buildings[position]]
                                                                            [
                                                                            index]
                                                                        .thirtyMinAfter
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .black)),
                                                      ],
                                                    ),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          goToCreateEvent(
                                                              context,
                                                              currentList[buildings[
                                                                      position]]
                                                                  [index],
                                                              widget.email);
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                primary: Colors
                                                                    .cyan[600]),
                                                        child: Text('Book'))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        })),
                              )
                            ])),
                      );
                    },
                  ),
                ),
              )
            ],
          );
        });
  }

  //navega para outra page
  void goToCreateEvent(
      BuildContext context, AvailableClassroomOnTime avail, String email) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateEventNearby(
                availClass: avail,
                email: email,
              )),
    );
  }
}
