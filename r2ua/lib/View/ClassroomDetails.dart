import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:r2ua/BlocPattern/BrbBloc.dart';
import 'package:r2ua/BlocPattern/EventPost.dart';
import 'package:r2ua/Entities/Building.dart';
import 'package:r2ua/Entities/Classrooms.dart';
import 'package:r2ua/Entities/Event.dart';
import 'package:r2ua/Entities/Week.dart';
import 'package:intl/intl.dart';
import 'package:r2ua/View/Events.dart';

import 'BuildingsClassrooms.dart';

//SEARCH 3
class ClassroomDetails extends StatefulWidget {
  Classroom classroom;
  Building building;
  ClassroomDetails({Key key, this.classroom, this.building}) : super(key: key);

  @override
  _ClassroomDetails createState() => _ClassroomDetails();
}

class _ClassroomDetails extends State<ClassroomDetails> {
  List<Event> events = new List<Event>();
  Week currentWeek;
  List<Week> weekList = new List<Week>();
  Stream weekStream;
  int current = 0;
  List<DateTime> days = new List<DateTime>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Classroom _classroom = widget.classroom;
    Building _building = widget.building;
    var formatter = new DateFormat('yyyy-MM-dd');

    weekStream = weekBloc.getWeekList;

    weekList = weekBloc.latest;

    currentWeek = weekList[current];
    eventsBloc.getAllClassroomEventsByTime(_classroom.id, currentWeek);

    days = currentWeek.getDaysInTheWeek();
    String current_week = "";

    return StreamBuilder(
        stream: eventsBloc.getListOfEvents,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            debugPrint("NO DATA");
            return Center(child: CircularProgressIndicator());
          }
          events = (snapshot.data) as List;

          return Scaffold(
              appBar: AppBar(title: Text(_building.name), actions: <Widget>[]),
              body: Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.all(2),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 5, top: 5, right: 5, bottom: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(children: [
                          Text(_classroom.name,
                              style: TextStyle(fontSize: 22.0)),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("", style: TextStyle(fontSize: 14.0)),
                                Row(children: <Widget>[
                                  Text(_classroom.capacity.toString(),
                                      style: TextStyle(fontSize: 14.0)),
                                  Icon(FontAwesomeIcons.users),
                                ]),
                                Text(
                                    "Exam Capacity: " +
                                        _classroom.examCapacity.toString(),
                                    style: TextStyle(fontSize: 14.0)),
                              ]),
                          Text(""),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                    child: Icon(
                                        FontAwesomeIcons.arrowAltCircleLeft),
                                    onTap: () {
                                      getWeek("-", _classroom);
                                    }),
                                Text(
                                    currentWeek.getFormattedBegin() +
                                        " - " +
                                        currentWeek.getFormattedEnding(),
                                    style: TextStyle(fontSize: 14.0)),
                                GestureDetector(
                                    child: Icon(
                                        FontAwesomeIcons.arrowAltCircleRight),
                                    onTap: () {
                                      getWeek("+", _classroom);
                                    }),
                              ]),
                          Text("", style: TextStyle(fontSize: 22.0)),
                        ]),
                      )),

                  //LIST OF EVENTS
                  Expanded(
                      child: StreamBuilder(
                          stream: eventsBloc.getListOfEvents,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return Center(child: CircularProgressIndicator());
                            events = (snapshot.data) as List;

                            return ListView(
                              padding: EdgeInsets.all(8),
                              children: <Widget>[
                                GestureDetector(
                                    child: Padding(
                                        padding: EdgeInsets.all(2),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              border: Border.all(
                                                color: Colors.amber[300],
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            height: 50,
                                            child: Center(
                                              child: Text(
                                                  formatter.format(days[0])),
                                            )))),
                                GestureDetector(
                                    child: Padding(
                                        padding: EdgeInsets.all(2),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              border: Border.all(
                                                color: Colors.amber[300],
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            height: 50,
                                            child: Center(
                                              child: Text(
                                                  formatter.format(days[1])),
                                            )))),
                                GestureDetector(
                                    child: Padding(
                                        padding: EdgeInsets.all(2),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              border: Border.all(
                                                color: Colors.amber[300],
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            height: 50,
                                            child: Center(
                                              child: Text(
                                                  formatter.format(days[2])),
                                            )))),
                                GestureDetector(
                                    child: Padding(
                                        padding: EdgeInsets.all(2),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              border: Border.all(
                                                color: Colors.amber[300],
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            height: 50,
                                            child: Center(
                                              child: Text(
                                                  formatter.format(days[3])),
                                            )))),
                                GestureDetector(
                                    child: Padding(
                                        padding: EdgeInsets.all(2),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              border: Border.all(
                                                color: Colors.amber[300],
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            height: 50,
                                            child: Center(
                                              child: Text(
                                                  formatter.format(days[4])),
                                            )))),
                                RaisedButton(
                                    onPressed: () {
                                      goToEventsPage(context, days, currentWeek,
                                          _classroom.id);
                                    },
                                    child: Text('Book Classroom'))
                              ],
                            );
                          })),
                ],
              ));
        });
  }

  getWeek(String s, Classroom _classroom) {
    if (s == "+") {
      if (current < weekList.length - 1) {
        setState(() {
          current++;
          currentWeek = weekList[current];

          days = currentWeek.getDaysInTheWeek();
        });
      }
    } else {
      if (current > 0) {
        setState(() {
          current--;
          currentWeek = weekList[current];
          days = currentWeek.getDaysInTheWeek();
        });
      }
      //eventsBloc.getAllClassroomEventsByTime(_classroom.id, currentWeek);

    }
    eventsBloc.getAllClassroomEventsByTime(_classroom.id, currentWeek);
  }

  //""""""""""""""""
  // ignore: always_declare_return_types
  goToEventsPage(
      BuildContext context, List<DateTime> days, Week data, int classroomID) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Events(
              days: days, classroomID: classroomID, week: data, title: 'r2UA')),
    );
  }
}
