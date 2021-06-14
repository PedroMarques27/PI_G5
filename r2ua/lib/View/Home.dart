import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:r2ua/BlocPattern/HomeBloc.dart';
import 'package:r2ua/Entities/Event.dart';
import 'package:r2ua/View/EventDetails.dart';

import 'BuildingsClassrooms.dart';
import 'package:r2ua/BlocPattern/BrbBloc.dart';
import 'package:r2ua/BlocPattern/BuildingsUAData.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title, this.email}) : super(key: key);

  final String title;
  final String email;

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  var bUA = <BuildingDistance>[];
  var email = '';

  Future init(List<BuildCount> listOfBuildCount) async {
    var temp = await buildingsUAData.getBuildingsNearByUser(listOfBuildCount);
    setState(() {
      bUA = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    email = widget.email;
    return Scaffold(body: _buildList(context));
  }

  Widget _buildList(BuildContext context) {
    eventsBloc.searchEventsByUser(email, 3);
    return StreamBuilder(
        stream: homeBloc.getHomeData,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          var current = (snapshot.data) as HomeData;
          var buildings = current.buildings;
          var events = current.events;
          return Column(children: <Widget>[
            Container(
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(
                    color: Colors.grey[300],
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Buildings Nearby', style: TextStyle(fontSize: 22.0)),
                  ],
                )),
            Expanded(
              flex: 1,
              child: buildings.isEmpty
                  ? LinearProgressIndicator()
                  : ListView.builder(
                      itemCount: buildings.length,
                      itemBuilder: (context, position) {
                        return GestureDetector(
                          onTap: () {
                            goToClassroomsPerBuildingPage(context,
                                buildings[position].buildingsClassrooms);
                          },
                          child: Container(
                            margin: EdgeInsets.all(2),
                            padding: EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(
                                color: Colors.grey[300],
                                width: 8,
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
                                        flex: 6,
                                        child: Text(
                                          buildings[position]
                                              .buildingsClassrooms
                                              .building
                                              .name,
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2, // 60%
                                        child: Text(
                                          buildings[position]
                                                  .buildingsDistance
                                                  .buildingDistance
                                                  .toString() +
                                              'km',
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ),
                                    ])),
                          ),
                        );
                      },
                    ),
            ),
            Expanded(
                child: Column(
              children: <Widget>[
                Text('Next Reservations', style: TextStyle(fontSize: 24.0)),
                Expanded(
                    child: ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              onTap: () {
                                goToEventDetails(context, email, events[index]);
                              },
                              child: Container(
                                  margin: EdgeInsets.all(2),
                                  padding: EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    border: Border.all(
                                      color: Colors.grey[300],
                                      width: 8,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(events[index].name.toString(),
                                                style: TextStyle(fontSize: 18)),
                                            Text(events[index]
                                                .weeks[0]
                                                .beginning
                                                .add(Duration(
                                                    days: events[index].day))
                                                .toIso8601String()
                                                .split('T')[0]),
                                          ]),
                                      Row(
                                        children: <Widget>[
                                          Text(events[index]
                                                  .startTime
                                                  .toString()
                                                  .substring(0, 5) +
                                              'h - ' +
                                              events[index]
                                                  .endTime
                                                  .toString()
                                                  .substring(0, 5) +
                                              'h'),
                                        ],
                                      )
                                    ]),
                                  )));
                        }))
              ],
            ))
          ]);
        });
  }

  void goToEventDetails(BuildContext context, String email, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EventDetails(event: event, email: email)),
    );
  }

  @override
  void initState() {
    super.initState();

    brbBloc.getBuildCount.listen((listOfBuildCount) {
      init(listOfBuildCount);
    });
  }

  void goToClassroomsPerBuildingPage(
      BuildContext context, BuildCount data) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BuildingsClassrooms(buildCount: data)),
    );
  }
}
