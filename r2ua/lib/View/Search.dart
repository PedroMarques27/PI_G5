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

          return CustomScrollView(primary: false, slivers: <Widget>[
            SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid.count(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: current.map((data) {
                    return GestureDetector(
                      child: _buildListItem(context, data),
                      onTap: () {
                        goToDetailsPage(context, data);
                      },
                    );
                  }).toList(),
                ))
          ]);
        });
  }

  goToDetailsPage(BuildContext context, BuildCount data) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BuildingsClassrooms(buildCount: data)),
    );
  }

  Widget _buildListItem(BuildContext context, BuildCount data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Center(
              child: Container(
            child: Column(children: <Widget>[
              Row(children: <Widget>[
                Text(data.building.name,
                    style: TextStyle(fontWeight: FontWeight.bold))
              ]),
              Row(children: <Widget>[Text(data.count.toString())]),
              Text(data.classroomsIDs.first.toString())
            ]),
          ))),
    );
  }
}
