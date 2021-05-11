
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Home.dart';
import 'Search.dart';

class Bookings extends StatefulWidget {
  Bookings({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Bookings createState() => _Bookings();
}

class _Bookings extends State<Bookings> {

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Text("Bookings")
      );
  }

 

}
