import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:r2ua/BlocPattern/BrbBloc.dart';
import 'package:r2ua/Entities/Building.dart';
import 'package:r2ua/Entities/Classrooms.dart';
import 'package:r2ua/Entities/Event.dart';
import 'package:r2ua/Entities/Week.dart';
import 'package:r2ua/View/CreateEvent.dart';

class ClassroomDetails extends StatefulWidget {
  ClassroomDetails({Key key, this.classroom, this.building, this.email})
      : super(key: key);

  Classroom classroom;
  Building building;
  String email;

  @override
  _ClassroomDetails createState() => _ClassroomDetails();
}

class _ClassroomDetails extends State<ClassroomDetails> {
  List<Event> currentList = <Event>[];
  List<Event> events = <Event>[];
  Week currentWeek;
  List<Week> weekList = <Week>[];
  Stream weekStream;
  int current = 0;
  List<DateTime> days = <DateTime>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _classroom = widget.classroom;
    var _building = widget.building;
    var email = widget.email;
    var formatter = DateFormat('yyyy-MM-dd');

    weekStream = weekBloc.getWeekList;
    weekList = weekBloc.latest;
    currentWeek = weekList[current];

    unavailableEventsBloc.searchUnavailableEventsByWeekByClassroom(
        currentWeek.getDaysInTheWeek()[0].toString(), _classroom.id);

    days = currentWeek.getDaysInTheWeek();
    var weekDays = <String>[
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday'
    ];

    return Scaffold(
        appBar: AppBar(title: Text(_building.name), actions: <Widget>[]),
        body: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.all(2),
                child: Container(
                  margin:
                      EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 10),
                  padding: EdgeInsets.all(10),
                  child: Column(children: [
                    Text(_classroom.name, style: TextStyle(fontSize: 22.0)),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('', style: TextStyle(fontSize: 14.0)),
                      Row(children: <Widget>[
                        Text('Capacity: ' + _classroom.capacity.toString(),
                            style: TextStyle(fontSize: 14.0)),
                      ]),
                    ]),
                    Text(''),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                              onTap: () {
                                getWeek('-', _classroom);
                              },
                              child: Icon(FontAwesomeIcons.arrowAltCircleLeft)),
                          Text(
                              currentWeek.getFormattedBegin() +
                                  ' - ' +
                                  currentWeek.getFormattedEnding(),
                              style: TextStyle(fontSize: 14.0)),
                          GestureDetector(
                              onTap: () {
                                getWeek('+', _classroom);
                              },
                              child:
                                  Icon(FontAwesomeIcons.arrowAltCircleRight)),
                        ]),
                    Text('', style: TextStyle(fontSize: 22.0)),
                    Text('Unavailable Times',
                        style: TextStyle(
                            fontSize: 17.0,
                            decoration: TextDecoration.underline)),
                  ]),
                )),
            Expanded(
                child: StreamBuilder(
                    stream: unavailableEventsBloc.getListOfEvents,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      currentList = (snapshot.data) as List;
                      return ListView.builder(
                          itemCount: 5,
                          itemBuilder: (BuildContext ctx, int ind) {
                            return Container(
                                margin: EdgeInsets.all(2),
                                padding: EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border.all(
                                    color: Colors.grey[300],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(weekDays[ind],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Text(formatter.format(days[ind]),
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Container(
                                      child: ListView.builder(
                                          itemCount: currentList.length,
                                          physics: ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            if (currentList[index].day == ind) {
                                              return Container(
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              .0),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Text(
                                                                currentList[
                                                                                index]
                                                                            .startTime
                                                                            .toString()
                                                                            .split(':')[
                                                                        0] +
                                                                    ':' +
                                                                    currentList[index]
                                                                            .startTime
                                                                            .toString()
                                                                            .split(':')[
                                                                        1] +
                                                                    'h - ' +
                                                                    currentList[index]
                                                                            .endTime
                                                                            .toString()
                                                                            .split(':')[
                                                                        0] +
                                                                    ':' +
                                                                    currentList[
                                                                            index]
                                                                        .endTime
                                                                        .toString()
                                                                        .split(
                                                                            ':')[1] +
                                                                    'h',
                                                                style: TextStyle(fontSize: 14)),
                                                            Text(' ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        22))
                                                          ])));
                                            }
                                            return Container();
                                          }),
                                    ),
                                    /* ListView.builder(
                                    itemCount: currentList.length,
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (currentList[index].day == ind) {
                                        return GestureDetector(
                                            child: Container(
                                                margin: EdgeInsets.all(2),
                                                padding: EdgeInsets.all(2.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  border: Border.all(
                                                    color: Colors.grey[300],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Column(children: [
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Text(
                                                              currentList[
                                                                              index]
                                                                          .startTime
                                                                          .toString()
                                                                          .split(
                                                                              ':')[
                                                                      0] +
                                                                  ':' +
                                                                  currentList[index]
                                                                          .startTime
                                                                          .toString()
                                                                          .split(
                                                                              ':')[
                                                                      1] +
                                                                  'h - ' +
                                                                  currentList[index]
                                                                          .endTime
                                                                          .toString()
                                                                          .split(
                                                                              ':')[
                                                                      0] +
                                                                  ':' +
                                                                  currentList[index]
                                                                          .endTime
                                                                          .toString()
                                                                          .split(
                                                                              ':')[
                                                                      1] +
                                                                  'h',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14)),
                                                        ])
                                                  ]),
                                                )));
                                      }
                                      return Container();
                                    }), */
                                  ],
                                ));
                            // design of date space
                            /* padding: EdgeInsets.all(8),
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
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      height: 50,
                                      child: Center(
                                        child: Text(formatter.format(days[0])),
                                      )))), */
                          });
                    })),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.cyan, // background
                onPrimary: Colors.white, // foreground
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateEvent(
                            week: currentWeek,
                            classId: _classroom.id,
                            email: email,
                            numMaxStud: _classroom.capacity,
                            unavailable: currentList,
                          )),
                );
              },
              child: Text('Book Classroom'),
            )
          ],
        ));
  }

  getWeek(String s, Classroom _classroom) {
    if (s == '+') {
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
    }
    unavailableEventsBloc.searchUnavailableEventsByWeekByClassroom(
        currentWeek.getDaysInTheWeek()[0].toString(), _classroom.id);
  }
}
