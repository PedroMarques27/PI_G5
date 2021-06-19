import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:r2ua/BlocPattern/BookingsBloc.dart';
import 'package:r2ua/BlocPattern/BrbBloc.dart';
import 'package:r2ua/BlocPattern/EventsBloc.dart';
import 'package:r2ua/Entities/Event.dart';
import 'package:r2ua/View/EventDetails.dart';

class Bookings extends StatefulWidget {
  Bookings({Key key, this.title, this.email}) : super(key: key);

  final String title;
  final String email;

  @override
  _Bookings createState() => _Bookings();
}

class _Bookings extends State<Bookings> {
  UserEvents userEvents = UserEvents();
  List<Event> currentList = <Event>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildList(context));
  }

  String dropdownValue = 'Future';
  List<Event> pastEventsList = <Event>[];
  List<Event> futureEventsList = <Event>[];

  Widget _buildList(BuildContext context) {
    var email = widget.email;
    eventsBloc.searchEventsByUser(email);
    eventsBloc.searchPastEventsByUser(email);
    return StreamBuilder(
        stream: bookingsBloc.getBookingsData,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          var current = (snapshot.data) as BookingsData;
          pastEventsList = current.pastEvents;
          futureEventsList = current.futureEvents;
          if (dropdownValue == 'Future') {
            currentList = futureEventsList;
          } else {
            currentList = pastEventsList;
          }
          return Column(
            children: <Widget>[
              Dropdown(context),
              dropdownValue == 'Future'
                  ? Text('Next Reservations', style: TextStyle(fontSize: 24.0))
                  : Text('Past Reservations', style: TextStyle(fontSize: 24.0)),
              Expanded(
                  child: ListView.builder(
                      itemCount: currentList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EventDetails(
                                      event: currentList[index],
                                      email: email,
                                      canDelete: dropdownValue == 'Future'
                                          ? true
                                          : false)),
                            );
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
                                child: Column(children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(currentList[index].name.toString(),
                                            style: TextStyle(fontSize: 15)),
                                        Text(
                                            currentList[index]
                                                    .weeks[0]
                                                    .beginning
                                                    .add(Duration(
                                                        days: currentList[index]
                                                            .day))
                                                    .toIso8601String()
                                                    .split('T')[0]
                                                    .split('-')[2] +
                                                '/' +
                                                currentList[index]
                                                    .weeks[0]
                                                    .beginning
                                                    .add(Duration(
                                                        days: currentList[index]
                                                            .day))
                                                    .toIso8601String()
                                                    .split('T')[0]
                                                    .split('-')[1] +
                                                '/' +
                                                currentList[index]
                                                    .weeks[0]
                                                    .beginning
                                                    .add(Duration(
                                                        days: currentList[index]
                                                            .day))
                                                    .toIso8601String()
                                                    .split('T')[0]
                                                    .split('-')[0]
                                                    .substring(2) +
                                                ' | ' +
                                                currentList[index]
                                                    .startTime
                                                    .substring(0, 5)
                                                    .toString() +
                                                'h - ' +
                                                currentList[index]
                                                    .endTime
                                                    .substring(0, 5)
                                                    .toString() +
                                                'h',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold)),
                                      ]),
                                ]),
                              )),
                        );
                      }))
            ],
          );
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

          if (newValue == 'Future') {
            currentList = futureEventsList;
          } else {
            currentList = pastEventsList;
          }
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
