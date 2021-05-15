import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:r2ua/BlocPattern/BrbBloc.dart';
import 'package:r2ua/Entities/Building.dart';
import 'package:r2ua/Entities/Classrooms.dart';

class ClassroomDetails extends StatefulWidget {
  Classroom classroom;
  ClassroomDetails({Key key, this.classroom}) : super(key: key);

  @override
  _ClassroomDetails createState() => _ClassroomDetails();
}

class _ClassroomDetails extends State<ClassroomDetails> {
  @override
  Widget build(BuildContext context) {
    Classroom _classroom = widget.classroom;

    return Scaffold(
        appBar: AppBar(
            title: Text("Classroom: " + _classroom.name), actions: <Widget>[]),
        body: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.all(2),
                child: Column(
                  children: [
                    Text(_classroom.name, style: TextStyle(fontSize: 22.0)),
                    Text("Capacity: " + _classroom.capacity.toString(),
                        style: TextStyle(fontSize: 14.0)),
                    Text("Exam Capacity: " + _classroom.examCapacity.toString(),
                        style: TextStyle(fontSize: 14.0)),
                    Text("Building: " + _classroom.building.toString() + "\n",
                        style: TextStyle(fontSize: 14.0)),
                    Text("Week: ", style: TextStyle(fontSize: 14.0)),
                    Text("Unavailable Times", style: TextStyle(fontSize: 22.0)),
                  ],
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

  /*   goToDetailsPage(BuildContext context, BuildCount data) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BuildingsClassrooms(buildCount: data)),
      );
    } */

}
