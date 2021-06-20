import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:r2ua/BlocPattern/BrbBloc.dart';
import 'package:r2ua/Entities/Classrooms.dart';
import 'package:r2ua/Entities/Event.dart';

// ignore: must_be_immutable
class EventDetails extends StatefulWidget {
  EventDetails({Key key, this.event, this.email, this.canDelete})
      : super(key: key);
  Event event;
  String email;
  bool canDelete;
  @override
  _EventDetails createState() => _EventDetails();
}

class _EventDetails extends State<EventDetails> {
  var email;

  @override
  void initState() {
    super.initState();
    email = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Event Details'), actions: <Widget>[]),
        body: _buildList(context));
  }

  Widget _buildList(BuildContext context) {
    var _event = widget.event;
    classroomsBloc.getEventClassroom(_event.classId);

    var weekDays = <String>[
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday'
    ];
    return Container(
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.all(6.0),
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _event.name,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              Divider(),
              Text(''),
              Container(
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey[300]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(children: [
                  Text(
                    'Event Information',
                    style: TextStyle(fontSize: 22),
                  ),
                  Text(''),
                  Row(
                    children: [
                      Text(
                        'Date: ' +
                            weekDays[_event.day] +
                            ', ' +
                            _event.weeks[0].beginning
                                .add(Duration(days: _event.day))
                                .toIso8601String()
                                .split('T')[0]
                                .split('-')[2] +
                            '/' +
                            _event.weeks[0].beginning
                                .add(Duration(days: _event.day))
                                .toIso8601String()
                                .split('T')[0]
                                .split('-')[1] +
                            '/' +
                            _event.weeks[0].beginning
                                .add(Duration(days: _event.day))
                                .toIso8601String()
                                .split('T')[0]
                                .split('-')[0],
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                  Text(''),
                  Row(
                    children: [
                      Text(
                        'Time: ' +
                            _event.startTime.substring(0, 5) +
                            'h - ' +
                            _event.endTime.substring(0, 5) +
                            'h',
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                  Text(''),
                  Row(
                    children: [
                      Text(
                        'Number of Students: ' + _event.numberPeople.toString(),
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ]),
              ),
              Text(''),
              Container(
                  child: StreamBuilder(
                      stream: classroomsBloc.getSingleClassroom,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data == null) {
                          return Center(child: CircularProgressIndicator());
                        }
                        var current = (snapshot.data) as Classroom;

                        debugPrint(current.name);

                        return Container(
                          margin: EdgeInsets.all(2),
                          padding: EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.grey[300]),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Classroom Information',
                                style: TextStyle(fontSize: 22),
                              ),
                              Text(''),
                              Row(
                                children: [
                                  Text('Class: ' + current.name),
                                ],
                              ),
                              Text(''),
                              Row(
                                children: [
                                  Text('Capacity: ' +
                                      current.capacity.toString()),
                                ],
                              ),
                              Text(''),
                              Row(children: [
                                Text('Characteristics: '),
                              ]),
                              Row(
                                children: [
                                  for (var i = 0;
                                      i < current.characteristics.length;
                                      i++)
                                    Text('  -  ' +
                                        current.characteristics[i].name),
                                ],
                              ),
                            ],
                          ),
                        );
                      })),
              Text(''),
              if (widget.canDelete)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.cyan, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    eventsBloc.removeEvent(_event.id, email);
                    eventsBloc.searchEventsByUser(email);
                    eventsBloc.searchPastEventsByUser(email);
                    Navigator.pop(context);
                  },
                  child: Text('Delete Event'),
                )
            ],
          ),
        ));
  }
}
