import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:r2ua/BlocPattern/BrbBloc.dart';
import 'package:r2ua/BlocPattern/EventsBloc.dart';
import 'package:r2ua/Entities/Event.dart';

import 'Bookings.dart';
import 'Home.dart';
import 'Search.dart';

class FirstPage extends StatefulWidget {
  FirstPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FirstPage createState() => _FirstPage();
}

class _FirstPage extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text("First Page"),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.cyan, // background
          onPrimary: Colors.white, // foreground
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Home(email: "ftrancho@ua.pt")),
          );
        },
        child: Text('Book Classroom'),
      )
    ]);
  }
}
