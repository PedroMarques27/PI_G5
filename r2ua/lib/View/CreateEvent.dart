import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:r2ua/BlocPattern/BrbBloc.dart';
import 'package:r2ua/Entities/Event.dart';
import 'package:r2ua/Entities/Week.dart';

// ignore: must_be_immutable
class CreateEvent extends StatefulWidget {
  CreateEvent(
      {Key key,
      this.week,
      this.classId,
      this.email,
      this.numMaxStud,
      this.unavailable})
      : super(key: key);

  int classId;
  Week week;
  String email;
  int numMaxStud;
  List<Event> unavailable;

  @override
  _CreateEvent createState() => _CreateEvent();
}

class _CreateEvent extends State<CreateEvent> {
  final _formKey = GlobalKey<FormState>();

  void _submit(String eventName, String startTime, String endTime, int wDay,
      int eType, int capacity) {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    postEventsBloc.postEvent(
        eventName,
        startTime,
        endTime,
        wDay,
        eType,
        capacity,
        widget.email,
        widget.week.beginning.toString(),
        widget.classId);

    Navigator.pop(context);
  }

  String dropdownWeekDayValue = 'Monday';
  String dropdownStartTimeValue = '08:00';
  String dropdownEndTimeValue = '08:30';
  String dropdownEventTypeValue = 'Meeting';
  String dropdownCapacityValue = '1';
  String name = '';
  List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];
  int count = 0;

  @override
  Widget build(BuildContext context) {
    var numStud = numOfStudentsList(widget.numMaxStud);
    var wDays = validWeekDays(widget.week);
    var hours = <String>[
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
    var eventType = <String>[
      'Meeting',
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
// Weekday
                  DropdownButtonFormField(
                    value: dropdownWeekDayValue,
                    decoration: InputDecoration(labelText: 'Weekday'),
                    hint: Text(
                      'choose one',
                    ),
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        dropdownWeekDayValue = value;
                      });
                    },
                    onSaved: (value) {
                      setState(() {
                        dropdownWeekDayValue = value;
                      });
                    },
                    items: wDays.map((String val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(
                          val,
                        ),
                      );
                    }).toList(),
                  ),
// NumStudents
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
// Start Time
                  DropdownButtonFormField(
                    value: dropdownStartTimeValue,
                    decoration: InputDecoration(labelText: 'Start Time'),
                    hint: Text(
                      'choose one',
                    ),
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        dropdownStartTimeValue = value;
                      });
                    },
                    onSaved: (value) {
                      setState(() {
                        dropdownStartTimeValue = value;
                      });
                    },
                    validator: (String value) {
                      if (!validDayHour(weekDays.indexOf(dropdownWeekDayValue),
                          widget.week, dropdownStartTimeValue)) {
                        return 'That hour has passed!';
                      } else {
                        return null;
                      }
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
// End Time
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
                      var available = availableTimes(widget.unavailable,
                          weekDays.indexOf(dropdownWeekDayValue));
                      if (!available.contains(dropdownStartTimeValue) |
                          !available.contains(value)) {
                        return 'There is already a reservation in that time! Change your start or end time.';
                      } else if (hours.indexOf(value) <=
                          hours.indexOf(dropdownStartTimeValue)) {
                        return 'The end time has to be after start time';
                      } else if (available.contains(dropdownStartTimeValue) &&
                          available.contains(value)) {
                        var a = available.indexOf(dropdownStartTimeValue);
                        var b = available.indexOf(value);
                        for (var i = a; i < b; i++) {
                          if (available[i] == '-') {
                            return 'There is already a reservation in that time! Change your start or end time.';
                          }
                        }
                        return null;
                      } else {
                        return null;
                      }
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
                        dropdownStartTimeValue,
                        dropdownEndTimeValue,
                        weekDays.indexOf(dropdownWeekDayValue),
                        4,
                        numStud.indexOf(dropdownCapacityValue) + 1),
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

  List<String> availableTimes(List<Event> unavailable, int day) {
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

    for (var e in unavailable) {
      if (e.day == day) {
        var ind1 = availableTimes.indexOf(e.startTime.substring(0, 5));
        var ind2 = availableTimes.indexOf(e.endTime.substring(0, 5));

        for (var i = ind2 - 1; i >= ind1; i--) {
          availableTimes.removeAt(i);
        }
        availableTimes.insert(ind1, '-');
      }
    }
    return availableTimes;
  }

  List<String> validWeekDays(Week week) {
    var weekDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

    if (week.beginning.isBefore(DateTime.now())) {
      for (var i = 0;
          i < DateTime.now().difference(week.beginning).inDays;
          i++) {
        weekDays.removeAt(0);
      }
    }

    setState(() {
      if (count == 0) {
        dropdownWeekDayValue = weekDays[0];
        count++;
      }
    });
    return weekDays;
  }

  bool validDayHour(int day, Week week, String startTime) {
    //if chosen day is today
    if (week.beginning.add(Duration(days: day)).toString().split(' ')[0] ==
        DateTime.now().toString().split(' ')[0]) {
      if (DateTime.now().hour.toInt() > int.parse(startTime.split(':')[0])) {
        return false;
      } else if (DateTime.now().hour.toInt() ==
              int.parse(startTime.split(':')[0]) &&
          DateTime.now().minute.toInt() == int.parse(startTime.split(':')[1])) {
        return false;
      }
    }
    return true;
  }
}
