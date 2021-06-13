import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:r2ua/Entities/EventPost.dart';
import 'package:r2ua/Entities/Week.dart';
import 'package:http/http.dart' as http;

class Events extends StatefulWidget {
  Events({Key key, this.days, this.classroomID, this.week, this.title})
      : super(key: key);

  final int classroomID;
  final Week week;
  final String title;
  final List<DateTime> days;
  @override
  _Events createState() => _Events();
}

Future<EventPost> submitData(
    String name,
    String startTime,
    String endTime,
    int day,
    int eventTypeId,
    int numStudents,
    String requestedBy,
    int weekId,
    int statusWeek,
    int classroomId,
    int statusClassroom) async {
  var response =
      await http.post(Uri.https('bullet-api.dev.ua.pt/', 'api/Events'), body: {
    'name': name,
    'startTime': startTime,
    'endTime': endTime,
    'day': day,
    'eventTypeId': eventTypeId,
    'requestedBy': requestedBy,
    'weekId': weekId,
    'statusWeek': statusWeek,
    'classroomId': classroomId,
    'statusClassroom': statusClassroom
  });
  var data = response.body;
  print(data);

  if (response.statusCode == 201) {
    var responseString = response.body;
    eventPostFromJson(responseString);
  } else {
    return null;
  }
}

class _Events extends State<Events> {
  EventPost _eventPost;

  TextEditingController eventNameController = TextEditingController();
  TextEditingController dayChoose_del = TextEditingController();

  int _selectedIndex = 0;

  String dayChoose;
  List<DateTime> days = new List<DateTime>();

  @override
  void initState() {
    super.initState();
  }

  List l1 = ['A', 'B', 'C'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("HELLO"),
        ),
        body: Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Column(
              children: [
                //eventName
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Event Name'),
                  controller: eventNameController,
                ),
                //day
                DropdownButton(
                  hint: Text("Select day: "),
                  dropdownColor: Colors.grey,
                  iconSize: 20,
                  isExpanded: true,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  value: dayChoose,
                  onChanged: (newValue) {
                    setState(() {
                      dayChoose = newValue;
                    });
                  },
                  items: l1.map((valueItem) {
                    return DropdownMenuItem(
                      value: valueItem,
                      child: Text(valueItem.toString()),
                    );
                  }).toList(),
                )
                //time Range

                /*
                ElevatedButton(
                    onPressed: () async {
                      String name = eventNameController,

                    },
                    child: Text('Submit')) */
              ],
            ))));
  }
}
