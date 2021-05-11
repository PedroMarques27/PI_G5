
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Bookings.dart';
import 'Search.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body:Text("Home")
      );
  }

}
