import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:r2ua/BlocPattern/HomeBloc.dart';
import 'package:r2ua/Entities/Building.dart';
import 'package:r2ua/Entities/Event.dart';
import 'package:r2ua/View/BookNearby.dart';
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
  final _formKey = GlobalKey<FormState>();

  void _submit(DateTime date, String startTime, List<Building> buildings) {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BookNearby(
                buildings: buildings,
                email: email,
                date: date,
                startTime: startTime,
              )),
    );
  }

  String dropdownStartTimeValue = '08:00';
  var hours = <String>[
    '08:00',
    '08:30',
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
    '18:30',
    '19:00',
    '19:30',
    '20:00',
    '20:30',
    '21:00',
    '21:30',
    '22:00'
  ];
  var days = <int>[
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31
  ];
  var months = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  var selectedDate = DateTime.now();

  var bUA = <BuildingDistance>[];
  var email = '';

  Future init(List<BuildCount> listOfBuildCount) async {
    var temp = await buildingsUAData.getBuildingsNearByUser(listOfBuildCount);
    if (!mounted) return;
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
    var weekDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    eventsBloc.searchEventsByUser(email);
    return StreamBuilder(
        stream: homeBloc.getHomeData,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          var current = (snapshot.data) as HomeData;
          var buildings = current.buildings;
          var buildingsList = <Building>[];
          for (var b in buildings) {
            buildingsList.add(b.buildingsClassrooms.building);
          }
          var events = current.events;
          return Column(children: <Widget>[
            Expanded(
                child: Column(
              children: <Widget>[
                Text('Next Reservations', style: TextStyle(fontSize: 24.0)),
                Expanded(
                    child: ListView.builder(
                        itemCount: events.length > 3 ? 3 : events.length,
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
                                    border: Border.all(color: Colors.grey[300]),
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
                                                        days:
                                                            events[index].day))
                                                    .toIso8601String()
                                                    .split('T')[0]
                                                    .split('-')[2] +
                                                '/' +
                                                events[index]
                                                    .weeks[0]
                                                    .beginning
                                                    .add(Duration(
                                                        days:
                                                            events[index].day))
                                                    .toIso8601String()
                                                    .split('T')[0]
                                                    .split('-')[1] +
                                                '/' +
                                                events[index]
                                                    .weeks[0]
                                                    .beginning
                                                    .add(Duration(
                                                        days:
                                                            events[index].day))
                                                    .toIso8601String()
                                                    .split('T')[0]
                                                    .split('-')[0]),
                                          ]),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                          Text(weekDays[events[index].day])
                                        ],
                                      )
                                    ]),
                                  )));
                        }))
              ],
            )),
            Container(
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.all(6.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Create Reservation ',
                      style: TextStyle(fontSize: 24.0),
                    ),
                    //styling

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Date: ', style: TextStyle(fontSize: 14)),
                        Text(
                            selectedDate == null
                                ? 'Nothing has been picked yet'
                                : selectedDate.toString().substring(0, 10),
                            style: TextStyle(fontSize: 14)),
                        ElevatedButton(
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(DateTime.now().year, 12, 31),
                              ).then((date) {
                                setState(() {
                                  selectedDate = date;
                                });
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white, // background
                            ),
                            child: Icon(
                              Icons.calendar_today_rounded,
                              color: Colors.cyan[600],
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Start Time: ', style: TextStyle(fontSize: 14)),
                        SizedBox(
                          width: 200,
                          child: DropdownButtonFormField(
                            value: dropdownStartTimeValue,
                            hint: Text('choose one',
                                style: TextStyle(fontSize: 14)),
                            isExpanded: true,
                            onChanged: (value) {
                              setState(() {
                                dropdownStartTimeValue = value;
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                dropdownStartTimeValue = value;
                              });
                            },
                            items: hours.map((String val) {
                              return DropdownMenuItem(
                                value: val,
                                child: Text(
                                  val,
                                  style: TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                    Text(' '),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: Colors.cyan[600],
                        ),
                        Text('Buildings nearby you ',
                            style: TextStyle(fontSize: 14)),
                        Text('Please, turn on your location',
                            style: TextStyle(fontSize: 9)),
                      ],
                    ),
                    Text(' '),

                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: buildings.isNotEmpty
                              ? Colors.cyan[600]
                              : Colors.cyan[600].withOpacity(0.2), // background
                          onPrimary: buildings.isNotEmpty
                              ? Colors.white
                              : Colors.white.withOpacity(0.2), // foreground
                        ),
                        onPressed: () {
                          buildings.isNotEmpty
                              ? _submit(selectedDate, dropdownStartTimeValue,
                                  buildingsList)
                              : null;
                          ;
                        },
                        child: Text('Find Classrooms Nearby')),
                  ],
                ),
              ),
            ),
            /*  Container(
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.all(6.0),
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
            ) */
          ]);
        });
  }

  void goToEventDetails(BuildContext context, String email, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              EventDetails(event: event, email: email, canDelete: true)),
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
