import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:r2ua/BlocPattern/BrbBloc.dart';
import 'package:r2ua/Entities/Building.dart';
import 'package:r2ua/Entities/Classrooms.dart';
import 'package:r2ua/Entities/Week.dart';

class ClassroomDetails extends StatefulWidget {
  Classroom classroom;
  Building building;
  ClassroomDetails({Key key, this.classroom, this.building}) : super(key: key);

  @override
  _ClassroomDetails createState() => _ClassroomDetails();
}

class _ClassroomDetails extends State<ClassroomDetails> {
  Week currentWeek;
  List<Week> weekList = new List<Week>();
  Stream weekStream;
  int current = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Classroom _classroom = widget.classroom;
    Building _building = widget.building;

    weekStream = weekBloc.getWeekList;
    weekStream.listen((event) {
      setState(() {
        weekList = event;
        currentWeek = weekList[current];
      });
    });
    weekList = weekBloc.latest;
    currentWeek = weekList[current];
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
                        ]),
                    Text(""),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                              child: Icon(FontAwesomeIcons.arrowAltCircleLeft),
                              onTap: () {
                                getWeek("-");
                              }),
                          Text(
                              currentWeek.getFormattedBegin() +
                                  " - " +
                                  currentWeek.getFormattedEnding(),
                              style: TextStyle(fontSize: 14.0)),
                          GestureDetector(
                              child: Icon(FontAwesomeIcons.arrowAltCircleRight),
                              onTap: () {
                                getWeek("+");
                              }),
                        ]),
                    Text("", style: TextStyle(fontSize: 22.0)),
                  ]),
                )),
            Expanded(
                child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, position) {
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
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "hello",
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ])),
                  ),
                  onTap: () {
                    // goToClassroomDetailsPage(context, current[position]);
                  },
                );
              },
            ))
          ],
        ));
  }

  getWeek(String s) {
    if (s == "+") {
      if (current < weekList.length - 1) {
        setState(() {
          current++;
          currentWeek = weekList[current];
        });
      }
    } else {
      if (current > 0)
        setState(() {
          current--;
          currentWeek = weekList[current];
        });
    }
  }

  /*   goToDetailsPage(BuildContext context, BuildCount data) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BuildingsClassrooms(buildCount: data)),
      );
    } */

}
