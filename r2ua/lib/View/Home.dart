import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:r2ua/BlocPattern/BrbBloc.dart';
import 'package:r2ua/BlocPattern/EventsBloc.dart';
import 'package:r2ua/Entities/Event.dart';
import 'package:r2ua/View/EventDetails.dart';

import 'Bookings.dart';
import 'Search.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title, this.email}) : super(key: key);

  final String title;
  final String email;

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  String email;

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

  Widget _buildList(BuildContext context) {
    eventsBloc.searchEventsByUser(email, 3);
    return StreamBuilder(
        stream: eventsBloc.getListOfEvents,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          currentList = (snapshot.data) as List;

          return new Scaffold(
              body: new Column(
            /* children: Conditional.list(
                context: context,
                conditionBuilder: (BuildContext context) => currentList != [],
                widgetBuilder: (BuildContext context) => <Widget>[
                  new Text("Next Reservations", style: TextStyle(fontSize: 24.0)),
              new Expanded(
                  child: new ListView.builder(
                      itemCount: currentList.length,
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



                  Text('Widget A'),
                  Text('Widget B'),
                ],
                fallbackBuilder: (BuildContext context) => <Widget>[
                  new Text("Next Reservations", style: TextStyle(fontSize: 24.0)),
                  Text("You don't have any reservation", style: TextStyle(fontSize: 16.0)),
                ],
              ), */

            children: <Widget>[
              new Text("Next Reservations", style: TextStyle(fontSize: 24.0)),
              new Expanded(
                  child: new ListView.builder(
                      itemCount: currentList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            onTap: () {
                              goToEventDetails(
                                  context, email, currentList[index]);
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
                                                .startTime
                                                .toString()
                                                .substring(0, 5) +
                                            "h - " +
                                            currentList[index]
                                                .endTime
                                                .toString()
                                                .substring(0, 5) +
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

  goToEventDetails(BuildContext context, String email, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EventDetails(event: event, email: email)),
    );
  }
}
