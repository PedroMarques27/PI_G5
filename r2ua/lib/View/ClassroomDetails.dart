import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:r2ua/BlocPattern/BrbBloc.dart';
import 'package:r2ua/Entities/Building.dart';
import 'package:r2ua/Entities/Classrooms.dart';
import 'package:r2ua/Entities/Event.dart';
import 'package:r2ua/Entities/Week.dart';

class ClassroomDetails extends StatefulWidget {
  Classroom classroom;
  Building building;
  ClassroomDetails({Key key, this.classroom, this.building}) : super(key: key);

  @override
  _ClassroomDetails createState() => _ClassroomDetails();
}

class _ClassroomDetails extends State<ClassroomDetails> {
  List<Event> currentList = new List<Event>();
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
    debugPrint("Weeeek" + currentWeek.getDaysInTheWeek()[0].toString());

    unavailableEventsBloc.searchUnavailableEventsByWeekByClassroom(
        currentWeek.getDaysInTheWeek()[0].toString(), _classroom.id);

    days = currentWeek.getDaysInTheWeek();

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
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(children: [
                    Text(_classroom.name, style: TextStyle(fontSize: 22.0)),
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
                          Text("Id: " + _classroom.id.toString(),
                              style: TextStyle(fontSize: 14.0)),
                        ]),
                    Text(""),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                              child: Icon(FontAwesomeIcons.arrowAltCircleLeft),
                              onTap: () {
                                getWeek("-", _classroom);
                              }),
                          Text(
                              currentWeek.getFormattedBegin() +
                                  " - " +
                                  currentWeek.getFormattedEnding(),
                              style: TextStyle(fontSize: 14.0)),
                          GestureDetector(
                              child: Icon(FontAwesomeIcons.arrowAltCircleRight),
                              onTap: () {
                                getWeek("+", _classroom);
                              }),
                        ]),
                    Text("", style: TextStyle(fontSize: 22.0)),
                  ]),
                )),
            Expanded(
                child: StreamBuilder(
                    stream: unavailableEventsBloc.getListOfEvents,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(child: CircularProgressIndicator());
                      currentList = (snapshot.data) as List;

                      return ListView.builder(
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
                                                      .id
                                                      .toString(),
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                            ])
                                      ]),
                                    )));
                          });
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
                    }))
          ],
        ));
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
      if (current > 0)
        setState(() {
          current--;
          currentWeek = weekList[current];
          days = currentWeek.getDaysInTheWeek();
        });
    }
    unavailableEventsBloc.searchUnavailableEventsByWeekByClassroom(
        currentWeek.getDaysInTheWeek()[0].toString(), _classroom.id);
  }

  /*   goToDetailsPage(BuildContext context, BuildCount data) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BuildingsClassrooms(buildCount: data)),
      );
    } */

}
