import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:r2ua/BlocPattern/BrbBloc.dart';
import 'package:r2ua/Entities/Building.dart';
import 'package:r2ua/Entities/Classrooms.dart';
import 'package:r2ua/View/ClassroomDetails.dart';

class BuildingsClassrooms extends StatefulWidget {
  BuildCount buildCount;
  String email;
  BuildingsClassrooms({Key key, this.buildCount, this.email}) : super(key: key);

  @override
  _BuildingsClassrooms createState() => _BuildingsClassrooms();
}

class _BuildingsClassrooms extends State<BuildingsClassrooms> {
  String dropdownCharacteristics = "No filter";
  @override
  Widget build(BuildContext context) {
    BuildCount bC = widget.buildCount;
    String email = widget.email;
    List<Classroom> current = bC.classrooms;
    Set<String> charact = getClassroomsCharacteristics(bC.classrooms);

    return Scaffold(
        appBar: AppBar(
            title: Text(bC.building.name + " Classrooms "),
            actions: <Widget>[]),
        body: Column(
          children: <Widget>[
            Container(
                margin:
                    EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 10),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(bC.building.name + " Classrooms",
                        style: TextStyle(fontSize: 22.0)),
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.sortAlphaDown),
                  tooltip: 'Sort By Alpha',
                  onPressed: () {
                    setState(() {
                      current.sort((a, b) => a.name.compareTo(b.name));
                    });
                  },
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.sortAlphaUp),
                  tooltip: 'Sort By Alpha',
                  onPressed: () {
                    setState(() {
                      current.sort((b, a) => a.name.compareTo(b.name));
                    });
                  },
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.sortNumericDown),
                  tooltip: 'Sort By Capacity',
                  onPressed: () {
                    setState(() {
                      current.sort((a, b) => a.capacity.compareTo(b.capacity));
                    });
                  },
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.sortNumericUp),
                  tooltip: 'Sort By Capacity',
                  onPressed: () {
                    setState(() {
                      current.sort((b, a) => a.capacity.compareTo(b.capacity));
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text("Characteristics: ", style: TextStyle(fontSize: 15.0)),
                DropdownCharacteristics(context, bC.classrooms, current),
              ],
            ),
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
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(2),
                                child: Text(
                                  current[position].name.toString(),
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ),
                              Container(
                                child: Row(children: <Widget>[
                                  Icon(FontAwesomeIcons.users),
                                  Text(current[position].capacity.toString(),
                                      style: TextStyle(fontSize: 12.0)),
                                ]),
                              )
                            ])),
                  ),
                  onTap: () {
                    goToClassroomDetailsPage(
                        context, current[position], bC.building, email);
                  },
                );
              },
            ))
          ],
        ));
  }

  goToClassroomDetailsPage(
      BuildContext context, Classroom data, Building building, String email) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ClassroomDetails(
                classroom: data,
                building: building,
                email: email,
              )),
    );
  }

  Widget DropdownCharacteristics(
      BuildContext context, List<Classroom> classes, List<Classroom> current) {
    return DropdownButton<String>(
      value: dropdownCharacteristics,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownCharacteristics = newValue;
          current = filterClassroomsByCharacteristic(classes, newValue);
        });
      },
      items: this
          .getClassroomsCharacteristics(widget.buildCount.classrooms)
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(fontSize: 13.0)),
        );
      }).toList(),
    );
  }

  Set<String> getClassroomsCharacteristics(List<Classroom> classes) {
    Set<String> characteristics = Set<String>();
    characteristics.add("No filter");
    for (Classroom c in classes)
      for (Characteristic charac in c.characteristics)
        characteristics.add(charac.name);
    debugPrint(characteristics.toString());
    return characteristics;
  }

  List<Classroom> filterClassroomsByCharacteristic(
      List<Classroom> classes, String characteristic) {
    List<Classroom> rightClasses = List<Classroom>();

    for (Classroom c in classes)
      for (Characteristic charac in c.characteristics)
        if (charac.name == characteristic) {
          debugPrint(c.name);
          rightClasses.add(c);
        }

    return rightClasses;
  }
}
