import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:r2ua/BlocPattern/BrbBloc.dart';
import 'package:r2ua/Entities/Building.dart';
import 'package:r2ua/Entities/Classrooms.dart';
import 'package:r2ua/View/ClassroomDetails.dart';

// ignore: must_be_immutable
class BuildingsClassrooms extends StatefulWidget {
  BuildingsClassrooms({Key key, this.buildCount, this.email}) : super(key: key);
  BuildCount buildCount;
  String email;

  @override
  _BuildingsClassrooms createState() => _BuildingsClassrooms();
}

class _BuildingsClassrooms extends State<BuildingsClassrooms> {
  String dropdownCharacteristics = 'No filter';
  List<Classroom> fullInitialList;
  List<Classroom> current;
  BuildCount bC;
  Set<String> charact;
  @override
  void initState() {
    super.initState();
    bC = widget.buildCount;

    fullInitialList = bC.classrooms;
    charact = getClassroomsCharacteristics(fullInitialList);
    current = fullInitialList;
  }

  @override
  Widget build(BuildContext context) {
    var email = widget.email;

    return Scaffold(
        appBar: AppBar(
            title: Text(bC.building.name + ' Classrooms '),
            actions: <Widget>[]),
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.sortAlphaDown),
                  iconSize: 20,
                  tooltip: 'Sort By Alpha',
                  onPressed: () {
                    setState(() {
                      current.sort((a, b) => a.name.compareTo(b.name));
                    });
                  },
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.sortAlphaUp),
                  iconSize: 20,
                  tooltip: 'Sort By Alpha',
                  onPressed: () {
                    setState(() {
                      current.sort((b, a) => a.name.compareTo(b.name));
                    });
                  },
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.sortNumericDown),
                  iconSize: 20,
                  tooltip: 'Sort By Capacity',
                  onPressed: () {
                    setState(() {
                      current.sort((a, b) => a.capacity.compareTo(b.capacity));
                    });
                  },
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.sortNumericUp),
                  iconSize: 20,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownCharacteristics(context),
              ],
            ),
            Expanded(
                child: ListView.builder(
              itemCount: current.length,
              itemBuilder: (context, position) {
                return GestureDetector(
                  onTap: () {
                    goToClassroomDetailsPage(
                        context, current[position], bC.building, email);
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
                                width: MediaQuery.of(context).size.width / 6,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Icon(FontAwesomeIcons.users),
                                      Text(
                                          current[position].capacity.toString(),
                                          style: TextStyle(fontSize: 12.0)),
                                    ]),
                              )
                            ])),
                  ),
                );
              },
            ))
          ],
        ));
  }

  void goToClassroomDetailsPage(
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

  Widget DropdownCharacteristics(BuildContext context) {
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
          current = filterClassroomsByCharacteristic(newValue);
        });
      },
      items: getClassroomsCharacteristics(bC.classrooms)
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(fontSize: 13.0)),
        );
      }).toList(),
    );
  }

  Set<String> getClassroomsCharacteristics(List<Classroom> classes) {
    var characteristics = <String>{};
    characteristics.add('No filter');
    for (var c in classes) {
      for (var charac in c.characteristics) {
        characteristics.add(charac.name);
      }
    }

    return characteristics;
  }

  List<Classroom> filterClassroomsByCharacteristic(String characteristic) {
    var rightClasses = <Classroom>[];
    if (characteristic == 'No filter') {
      rightClasses = fullInitialList;
    } else {
      for (var c in fullInitialList) {
        for (var charac in c.characteristics) {
          if (charac.name == characteristic) rightClasses.add(c);
        }
      }
    }

    return rightClasses;
  }
}
