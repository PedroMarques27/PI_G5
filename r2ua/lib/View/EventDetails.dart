import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:r2ua/BlocPattern/BrbBloc.dart';
import 'package:r2ua/Entities/Building.dart';
import 'package:r2ua/Entities/Classrooms.dart';
import 'package:r2ua/Entities/Event.dart';
import 'package:r2ua/View/Home.dart';
import 'package:r2ua/main.dart';

class EventDetails extends StatefulWidget {
  EventDetails({Key key, this.event, this.email}) : super(key: key);
  Event event;
  String email;
  @override
  _EventDetails createState() => _EventDetails();
}

class _EventDetails extends State<EventDetails> {
  Stream classroomStream;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Event _event = widget.event;
    //Classroom classroom = await classroomsBloc.getClassroomById(_event.classId);

    List<String> weekDays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday"
    ];

    return Scaffold(
        appBar:
            AppBar(title: Text("Event: " + _event.name), actions: <Widget>[]),
        body: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.all(6.0),
                child: Column(
                  children: [
                    Text(
                      "Name: " + _event.name,
                      style: TextStyle(fontSize: 24),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            "Date: " +
                                weekDays[_event.day] +
                                ", " +
                                _event.weeks[0].beginning
                                    .add(Duration(days: _event.day))
                                    .toIso8601String()
                                    .split("T")[0]
                                    .split("-")[2] +
                                "/" +
                                _event.weeks[0].beginning
                                    .add(Duration(days: _event.day))
                                    .toIso8601String()
                                    .split("T")[0]
                                    .split("-")[1] +
                                "/" +
                                _event.weeks[0].beginning
                                    .add(Duration(days: _event.day))
                                    .toIso8601String()
                                    .split("T")[0]
                                    .split("-")[0],
                            style: TextStyle(fontSize: 17),
                          ),
                          Text(
                            "Time: " +
                                _event.startTime.substring(0, 5) +
                                "h - " +
                                _event.endTime.substring(0, 5) +
                                "h (" +
                                _event.duration.substring(0, 5) +
                                "h)",
                            style: TextStyle(fontSize: 17),
                          ),
                          Text(
                            "Number of Students: " +
                                _event.numberPeople.toString(),
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "\nClassroom: " + _event.classId.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.cyan, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () {
                        eventsBloc.removeEvent(_event.id, email);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home(email: email)),
                        );
                      },
                      child: Text('Delete Event'),
                    )
                  ],
                ))
          ],
        ));
  }
}
