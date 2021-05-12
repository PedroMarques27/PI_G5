import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:r2ua/BlocPattern/BrbBloc.dart';
import 'package:r2ua/Entities/Classrooms.dart';

import 'Bookings.dart';
import 'Search.dart';

class BuildingsClassrooms extends StatefulWidget {
  BuildCount buildCount;
  BuildingsClassrooms({Key key, this.buildCount}) : super(key: key);

  @override
  _BuildingsClassrooms createState() => _BuildingsClassrooms();
}

class _BuildingsClassrooms extends State<BuildingsClassrooms> {
  @override
  Widget build(BuildContext context) {
    BuildCount bC = widget.buildCount;
    classroomsBloc.getClassroomsByIdList(bC.classroomsIDs);
    return Column(children: <Widget>[
      Expanded(
        child: Container(child: _buildList(context)),
      )
    ]);
  }

  Widget _buildList(BuildContext context) {
    return StreamBuilder(
        // Wrap our widget with a StreamBuilder
        stream: classroomsBloc.getClassrooms,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          List<Classroom> current = snapshot.data;

          return CustomScrollView(primary: false, slivers: <Widget>[
            SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid.count(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 1,
                  children: current.map((data) {
                    return GestureDetector(
                      child: _buildListItem(context, data),
                      onTap: () {
                        // goToDetailsPage(context, data);
                      },
                    );
                  }).toList(),
                ))
          ]);
        });
  }

  /*   goToDetailsPage(BuildContext context, BuildCount data) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BuildingsClassrooms(buildCount: data)),
      );
    } */

  Widget _buildListItem(BuildContext context, Classroom data) {
    return Text(data.name);
  }
}
