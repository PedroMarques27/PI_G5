import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:r2ua/BlocPattern/BrbBloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'View/Authentication.dart';
import 'View/Bookings.dart';
import 'View/Home.dart';
import 'View/Search.dart';

void main() {
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'R2UA', home: LoginPage(title: 'R2UA'));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.email}) : super(key: key);

  final String title;

  final String email;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SharedPreferences prefs;
  int _selectedIndex = 0;
  var email;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'R2UA',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.cyan[600],
          accentColor: Colors.cyan[600],
          fontFamily: 'Georgia',
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          appBar: AppBar(title: Text('R2UA'), actions: <Widget>[
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    primary: Colors.cyan[600], // background

                    side: BorderSide(color: Colors.cyan[600])),
                onPressed: () {
                  prefs.clear();
                  Phoenix.rebirth(context);
                },
                icon: Icon(Icons.logout),
                label: Text(''))
          ]),
          body: IndexedStack(
            index: _selectedIndex,
            children: _children,
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.book),
                label: 'Bookings',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          ),
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
    email = widget.email;
    _children = [
      Home(email: email),
      Search(email: email),
      Bookings(email: email)
    ];
    var location = Geolocator();
    location.checkGeolocationPermissionStatus();
    brbBloc.initialize(email);
    homeBloc.startCapturing();
    bookingsBloc.startCapturing();
    weekBloc.getWeeks();
  }

  void init() async {
    prefs = await SharedPreferences.getInstance();
  }

  var _children;
}
