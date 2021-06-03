import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:r2ua/BlocPattern/BrbBloc.dart';
import 'package:r2ua/BlocPattern/EventsBloc.dart';
import 'package:r2ua/Entities/Event.dart';

import 'Home.dart';
import 'Search.dart';

class Bookings extends StatefulWidget {
  Bookings({Key key, this.title, this.email}) : super(key: key);

  final String title;
  final String email;

  @override
  _Bookings createState() => _Bookings();
}

class _Bookings extends State<Bookings> {
  String email;
  UserEvents userEvents = new UserEvents();
  List<Event> currentList = new List<Event>();

  @override
  Widget build(BuildContext context) {
    email = widget.email;
    return Column(children: <Widget>[
      Expanded(
        child: Container(child: _buildList(context)),
      )
    ]);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      currentEventsList = userEvents.futureEvents;
      pastEventsList = userEvents.pastEvents;
      currentList = currentEventsList;
    });
  }

  String dropdownValue = "Future";
  List<Event> pastEventsList = new List<Event>();
  List<Event> currentEventsList = new List<Event>();
  Widget _buildList(BuildContext context) {
    eventsBloc.bookingsEvents(email, 100);

    return StreamBuilder(
        stream: eventsBloc.getListOfEvents,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          currentEventsList = (snapshot.data) as List;

          return new Scaffold(
              body: new Column(
            children: <Widget>[
              Dropdown(context),
              dropdownValue == 'Future'
                  ? Text("Next Reservations", style: TextStyle(fontSize: 24.0))
                  : Text("Past Reservations", style: TextStyle(fontSize: 24.0)),
              new Expanded(
                  child: new ListView.builder(
                      itemCount: currentEventsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
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
                                          Text(
                                              currentList[index]
                                                  .name
                                                  .toString(),
                                              style: TextStyle(fontSize: 18)),
                                          Text(currentList[index]
                                              .weeks[0]
                                              .beginning
                                              .add(Duration(
                                                  days: currentList[index].day))
                                              .toIso8601String()
                                              .split("T")[0]),
                                        ]),
                                    Row(
                                      children: <Widget>[
                                        Text(currentList[index]
                                                .startTime[0]
                                                .toString() +
                                            currentList[index]
                                                .startTime[1]
                                                .toString() +
                                            currentList[index]
                                                .startTime[2]
                                                .toString() +
                                            currentList[index]
                                                .startTime[3]
                                                .toString() +
                                            currentList[index]
                                                .startTime[4]
                                                .toString() +
                                            "h - " +
                                            currentList[index]
                                                .endTime[0]
                                                .toString() +
                                            currentList[index]
                                                .endTime[1]
                                                .toString() +
                                            currentList[index]
                                                .endTime[2]
                                                .toString() +
                                            currentList[index]
                                                .endTime[3]
                                                .toString() +
                                            currentList[index]
                                                .endTime[4]
                                                .toString() +
                                            "h"),
                                      ],
                                    )
                                  ]),
                                )));
                      }))
            ],
          ));
        });
  }

  Widget Dropdown(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          debugPrint("----------------" + pastEventsList.toString());
          if (newValue == "Future")
            currentList = currentEventsList;
          else
            currentList = pastEventsList;
        });
      },
      items: <String>['Future', 'Past']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
