import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:r2ua/BlocPattern/BrbBloc.dart';
import 'package:r2ua/Entities/Classrooms.dart';

import 'Bookings.dart';
import 'Search.dart';

class BuildingsClassrooms extends StatefulWidget {
  BuildCount buildCount;
  BuildingsClassrooms({Key key, this.buildCount}) : super(key: key);

  @override
  _BuildingsClassrooms createState() => _BuildingsClassrooms();
}

class _BuildingsClassrooms extends State<BuildingsClassrooms> {
  @override
  Widget build(BuildContext context) {
    BuildCount bC = widget.buildCount;
    classroomsBloc.getClassroomsByIdList(bC.classroomsIDs);
    return Scaffold(
        appBar: AppBar(
            title: Text(bC.building.name + " Classrooms "),
            actions: <Widget>[]),
        body: StreamBuilder(
            stream: classroomsBloc.getClassrooms,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              List<Classroom> current = snapshot.data;
              return Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.all(2),
                      padding: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(
                          color: Colors.grey[300],
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [Text(bC.building.name + " Classrooms")],
                      )),
                  Expanded(
                      child: ListView.builder(
                    itemCount: current.length,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      current[position].name.toString(),
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  ])),
                        ),
                        onTap: () {
                          //goToDetailsPage(context, current[position]);
                        },
                      );
                    },
                  ))
                ],
              );
            }));
  }

  /*   goToDetailsPage(BuildContext context, BuildCount data) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BuildingsClassrooms(buildCount: data)),
      );
    } */

}
