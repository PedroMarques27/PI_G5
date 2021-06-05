import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:r2ua/View/BuildingsClassrooms.dart';

import 'Bookings.dart';
import 'Home.dart';
import 'package:r2ua/BlocPattern/BrbBloc.dart';

class Search extends StatefulWidget {
  Search({Key key, this.title, this.email}) : super(key: key);

  final String title;
  String email;

  @override
  _Search createState() => _Search();
}

class _Search extends State<Search> {
  List<BuildCount> currentList = new List<BuildCount>();
  @override
  Widget build(BuildContext context) {
    String email = widget.email;
    return Column(children: <Widget>[
      Expanded(
        child: Container(child: _buildList(context, email)),
      )
    ]);
  }

  Widget _buildList(BuildContext context, String email) {
    return StreamBuilder(
        stream: brbBloc.getBuildCount,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          currentList = (snapshot.data) as List;

          return Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(
                      color: Colors.grey[300],
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Buildings Available",
                          style: TextStyle(fontSize: 22.0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.sortAlphaDown),
                            tooltip: 'Sort By Alpha',
                            onPressed: () {
                              setState(() {
                                currentList.sort((a, b) =>
                                    a.building.name.compareTo(b.building.name));
                              });
                            },
                          ),
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.sortAlphaUp),
                            tooltip: 'Sort By Alpha',
                            onPressed: () {
                              setState(() {
                                currentList.sort((b, a) =>
                                    a.building.name.compareTo(b.building.name));
                              });
                            },
                          ),
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.sortNumericDown),
                            tooltip: 'Sort By Count',
                            onPressed: () {
                              setState(() {
                                currentList
                                    .sort((a, b) => a.count.compareTo(b.count));
                              });
                            },
                          ),
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.sortNumericUp),
                            tooltip: 'Sort By Count',
                            onPressed: () {
                              setState(() {
                                currentList
                                    .sort((b, a) => a.count.compareTo(b.count));
                              });
                            },
                          ),
                        ],
                      )
                    ],
                  )),
              Expanded(
                child: ListView.builder(
                  itemCount: currentList.length,
                  itemBuilder: (context, position) {
                    return GestureDetector(
                      child: Container(
                        margin: EdgeInsets.all(2),
                        padding: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(
                            color: Colors.grey[300],
                            width: 8,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    currentList[position]
                                        .building
                                        .name
                                        .toString(),
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        currentList[position].count.toString(),
                                        style: TextStyle(fontSize: 16.0),
                                      ))
                                ])),
                      ),
                      onTap: () {
                        goToClassroomsPerBuildingPage(
                            context, currentList[position], email);
                      },
                    );
                  },
                ),
              )
            ],
          );
        });
  }

  goToClassroomsPerBuildingPage(
      BuildContext context, BuildCount data, String email) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              BuildingsClassrooms(buildCount: data, email: email)),
    );
  }
}
