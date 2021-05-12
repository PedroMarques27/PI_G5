import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:r2ua/View/BuildingsClassrooms.dart';

import 'Bookings.dart';
import 'Home.dart';
import 'package:r2ua/BlocPattern/BrbBloc.dart';

class Search extends StatefulWidget {
  Search({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Search createState() => _Search();
}

class _Search extends State<Search> {
  @override
  Widget build(BuildContext context) {
    brbBloc.initialize('aarodrigues@ua.pt');
    return Column(children: <Widget>[
      Expanded(
        child: Container(child: _buildList(context)),
      )
    ]);
  }

  Widget _buildList(BuildContext context) {
    return StreamBuilder(
        // Wrap our widget with a StreamBuilder
        stream: brbBloc.getBuildCount,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          List<BuildCount> current = snapshot.data;

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
                  child: Row(
                    children: [Text("Buildings Available")],
                  )),
              Expanded(
                child: ListView.builder(
                  itemCount: current.length,
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
                                    current[position].building.name.toString(),
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        current[position].count.toString(),
                                        style: TextStyle(fontSize: 16.0),
                                      ))
                                ])),
                      ),
                      onTap: () {
                        goToDetailsPage(context, current[position]);
                      },
                    );
                  },
                ),
              )
            ],
          );
        });
  }

  goToDetailsPage(BuildContext context, BuildCount data) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BuildingsClassrooms(buildCount: data)),
    );
  }
}
