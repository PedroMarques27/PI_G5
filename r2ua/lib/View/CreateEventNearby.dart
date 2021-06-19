import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:r2ua/BlocPattern/BookNearbyEventsBloc.dart';
import 'package:r2ua/BlocPattern/BrbBloc.dart';

// ignore: must_be_immutable
class CreateEventNearby extends StatefulWidget {
  CreateEventNearby({
    Key key,
    this.availClass,
    this.email,
  }) : super(key: key);

  AvailableClassroomOnTime availClass;
  String email;

  @override
  _CreateEventNearby createState() => _CreateEventNearby();
}

class _CreateEventNearby extends State<CreateEventNearby> {
  final _formKey = GlobalKey<FormState>();

  void _submit(String eventName, String startTime, String endTime, int wDay,
      int eType, int capacity, String startWeek, int classId) {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    postEventsBloc.postEvent(eventName, startTime, endTime, wDay, eType,
        capacity, widget.email, startWeek.toString(), classId);

    Navigator.pop(context);
  }

  String dropdownEndTimeValue = '08:30';
  String dropdownEventTypeValue = 'Aula';
  String dropdownCapacityValue = '1';
  String name = '';
  String firstHour = '';
  int count = 0;

  @override
  Widget build(BuildContext context) {
    var avail = widget.availClass;
    var numStud = numOfStudentsList(avail.classroom.capacity);

    var hours =
        availableTimes(avail.startTime, avail.endTime, avail.thirtyMinAfter);

    var eventType = <String>[
      'Aula',
      'Exame',
      'Conferência',
      'Reunião',
      'Avaliação',
      'Reservas'
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text('Book Classroom'),
        ),
        //body
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            //form
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Create Reservation ',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Start Time: ' + firstHour,
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    'Date: ' + avail.date.toString(),
                    style: TextStyle(fontSize: 17.0),
                  ),
                  //styling
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.05,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    keyboardType: TextInputType.name,
                    onChanged: (newValue) {
                      setState(() {
                        name = newValue;
                      });
                    },
                    onFieldSubmitted: (value) {},
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter a valid name!';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField(
                    value: dropdownCapacityValue,
                    decoration:
                        InputDecoration(labelText: 'Number of Students'),
                    hint: Text(
                      'choose one',
                    ),
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        dropdownCapacityValue = value;
                      });
                    },
                    onSaved: (value) {
                      setState(() {
                        dropdownCapacityValue = value;
                      });
                    },
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "can't empty";
                      } else {
                        return null;
                      }
                    },
                    items: numStud.map((String val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(
                          val,
                        ),
                      );
                    }).toList(),
                  ),

                  DropdownButtonFormField(
                    value: dropdownEndTimeValue,
                    decoration: InputDecoration(labelText: 'End Time'),
                    hint: Text(
                      'choose one',
                    ),
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        dropdownEndTimeValue = value;
                      });
                    },
                    onSaved: (value) {
                      setState(() {
                        dropdownEndTimeValue = value;
                      });
                    },
                    validator: (String value) {
                      return null;
                    },
                    items: hours.map((String val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(
                          val,
                        ),
                      );
                    }).toList(),
                  ),
// Event Type
                  DropdownButtonFormField(
                    value: dropdownEventTypeValue,
                    decoration: InputDecoration(labelText: 'Type of Event'),
                    hint: Text(
                      'choose one',
                    ),
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        dropdownEventTypeValue = value;
                      });
                    },
                    onSaved: (value) {},
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "can't empty";
                      } else {
                        return null;
                      }
                    },
                    items: eventType.map((String val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(
                          val,
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                  ),
                  // ignore: deprecated_member_use
                  RaisedButton(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 15.0,
                    ),
                    onPressed: () => _submit(
                        name,
                        firstHour,
                        dropdownEndTimeValue,
                        avail.date.weekday - 1,
                        eventType.indexOf(dropdownEventTypeValue) + 1,
                        numStud.indexOf(dropdownCapacityValue) + 1,
                        avail.date
                            .subtract(Duration(days: avail.date.weekday - 1))
                            .toString()
                            .substring(0, 10),
                        avail.classroom.id),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  List<String> numOfStudentsList(int numMax) {
    var numStud = <String>[];
    for (var i = 0; i < numMax; i++) {
      numStud.add((i + 1).toString());
    }
    return numStud;
  }

  List<String> availableTimes(
      String startTime, String endTime, bool thirtyAfter) {
    var availableTimes = [
      '08:00',
      '08:30',
      '09:00',
      '09:30',
      '10:00',
      '10:30',
      '11:00',
      '11:30',
      '12:00',
      '12:30',
      '13:00',
      '13:30',
      '14:00',
      '14:30',
      '15:00',
      '15:30',
      '16:00',
      '16:30',
      '17:00',
      '17:30',
      '18:00',
      '18:30',
      '19:00',
      '19:30',
      '20:00',
      '20:30',
      '21:00',
      '21:30',
      '22:00'
    ];
    var ind1 = thirtyAfter
        ? availableTimes.indexOf(startTime) + 1
        : availableTimes.indexOf(startTime);
    var ind2 = availableTimes.indexOf(endTime);

    for (var i = availableTimes.length - 1; i > ind2; i--) {
      availableTimes.removeAt(i);
    }
    for (var i = 0; i < ind1; i++) {
      availableTimes.removeAt(0);
    }

    setState(() {
      dropdownEndTimeValue = availableTimes[1];
      firstHour = availableTimes[0];
    });
    availableTimes.removeAt(0);

    return availableTimes;
  }
}
