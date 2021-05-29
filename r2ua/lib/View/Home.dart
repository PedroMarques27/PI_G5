import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:r2ua/Entities/Event.dart';

import 'Bookings.dart';
import 'Search.dart';
import 'package:r2ua/Entities/User.dart';
import 'package:r2ua/BlocPattern/BrbBloc.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  List<Event> currentList = new List<Event>();

  void _getCurrentLocation() async {
    String _locationMessage = "";
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
    setState(() {
      _locationMessage = "${position.latitude}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        home: Scaffold(
            appBar: AppBar(title: Text("Location Services")),
            body: Align(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(""),
                    FlatButton(
                        onPressed: () {
                          _getCurrentLocation();
                        },
                        color: Colors.green,
                        child: Text("Find Location"))
                  ]),
            )));
  }
}
