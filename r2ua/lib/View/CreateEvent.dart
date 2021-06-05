import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:r2ua/BlocPattern/BrbBloc.dart';
import 'package:r2ua/Entities/Building.dart';
import 'package:r2ua/Entities/Classrooms.dart';
import 'package:r2ua/Entities/Event.dart';
import 'package:r2ua/Entities/Week.dart';

class CreateEvent extends StatefulWidget {
  // PASSAR O EMAIL TAMBEM ----------------------------------------------------------
  int classId;
  Week week;
  String email;
  List<String> weekDays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday"
  ];
  List<String> hours = <String>[
    "08:00",
    "08:30",
    "09:00",
    "09:30",
    "10:00",
    "10:30",
    "11:00",
    "11:30",
    "12:00",
    "12:30",
    "13:00",
    "13:30",
    "14:00",
    "14:30",
    "15:00",
    "15:30",
    "16:00",
    "16:30",
    "17:00",
    "17:30",
    "18:00",
    "18:30",
    "19:00",
    "19:30",
    "20:00",
    "20:30",
    "21:00",
    "21:30"
  ];
  List<String> eventType = <String>[
    "Aula",
    "Exame",
    "Conferência",
    "Reunião",
    "Avaliação",
    "Reservas"
  ]; //ID +1 ---------------------IMPORTANTE

  CreateEvent({Key key, this.week, this.classId, this.email}) : super(key: key);

  @override
  _CreateEvent createState() => _CreateEvent();
}

class _CreateEvent extends State<CreateEvent> {
  String dropdownWeekDayValue = "Monday";
  String dropdownStartTimeValue = "08:00";
  String dropdownEndTimeValue = "08:30";
  String dropdownEventTypeValue = "Aula";

  @override
  Widget build(BuildContext context) {
    final myControllerName = TextEditingController();
    final myControllerNum = TextEditingController();

    int classId = widget.classId;
    Week week = widget.week;
    String email = widget.email;
    debugPrint("EMAILLLLLL" + email);

    List<String> wDays = widget.weekDays;
    List<String> eType = widget.eventType;

    return Scaffold(
        appBar: AppBar(title: Text("Create Event"), actions: <Widget>[]),
        body: Column(children: <Widget>[
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
                    Text("Id: " + classId.toString(),
                        style: TextStyle(fontSize: 22.0)),
                    Text(
                        week.getFormattedBegin() +
                            " - " +
                            week.getFormattedEnding(),
                        style: TextStyle(fontSize: 22.0)),
                    Text("\nEvent Name: ", style: TextStyle(fontSize: 22.0)),
                    TextField(
                      controller: myControllerName,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    Text("\nNumber of Students: ",
                        style: TextStyle(fontSize: 22.0)),
                    TextField(
                      controller: myControllerNum,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    Row(children: [
                      Text("\nWeek day: ", style: TextStyle(fontSize: 22.0)),
                      Column(children: <Widget>[
                        DropdownWeekDays(context),
                      ]),
                    ]),
                    Row(children: [
                      Text("\nStart Time: ", style: TextStyle(fontSize: 22.0)),
                      Column(children: <Widget>[
                        DropdownStartTime(context),
                      ]),
                    ]),
                    Row(children: [
                      Text("\nEnd Time: ", style: TextStyle(fontSize: 22.0)),
                      Column(children: <Widget>[
                        DropdownEndTime(context),
                      ]),
                    ]),
                    Row(
                      children: [
                        Text("\nEvent Type: ",
                            style: TextStyle(fontSize: 22.0)),
                        Column(children: <Widget>[
                          DropdownEventType(context),
                        ]),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.cyan, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () {
                        postEventsBloc.postEvent(
                            myControllerName.text,
                            dropdownStartTimeValue,
                            dropdownEndTimeValue,
                            wDays.indexOf(dropdownWeekDayValue),
                            eType.indexOf(dropdownEventTypeValue) + 1,
                            int.parse(myControllerNum.text),
                            email,
                            week.beginning.toString(),
                            classId);
                      },
                      child: Text('Book Classroom'),
                    )
                  ])))
        ]));
  }

  Widget DropdownWeekDays(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownWeekDayValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownWeekDayValue = newValue;
        });
      },
      items: widget.weekDays.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget DropdownStartTime(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownStartTimeValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownStartTimeValue = newValue;
        });
      },
      items: widget.hours.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget DropdownEndTime(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownEndTimeValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownEndTimeValue = newValue;
        });
      },
      items: widget.hours.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget DropdownEventType(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownEventTypeValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownEventTypeValue = newValue;
        });
      },
      items: widget.eventType.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

}
