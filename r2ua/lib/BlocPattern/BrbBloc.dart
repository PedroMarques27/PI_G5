import 'dart:async';
import 'dart:collection';
import 'package:r2ua/BlocPattern/BookNearbyEventsBloc.dart';
import 'package:r2ua/BlocPattern/BookingsBloc.dart';
import 'package:r2ua/BlocPattern/PostEventBloc.dart';
import 'package:r2ua/BlocPattern/UnavailableEventsBloc.dart';
import 'package:r2ua/BlocPattern/WeekBloc.dart';
import 'package:r2ua/Entities/Building.dart';
import 'package:r2ua/Entities/ClassroomGroups.dart';
import 'package:r2ua/Entities/Classrooms.dart';
import 'package:r2ua/Entities/User.dart';
import 'package:r2ua/BlocPattern/BuildingsUAData.dart';
import 'BuildingBloc.dart';
import 'ClassroomGroupsBloc.dart';
import 'ClassroomsBloc.dart';
import 'EventsBloc.dart';
import 'HomeBloc.dart';
import 'UsersBloc.dart';

String token =
    'eyJhbGciOiJSUzI1NiIsImtpZCI6IjQ4M2YzZWI0YzA3N2RjMDFmMjQ5MzIyNDk5NDM3NGJmIiwidHlwIjoiYXQrand0In0.eyJuYmYiOjE2MjY1MTkxNDcsImV4cCI6MTYyOTExMTE0NywiaXNzIjoiaHR0cHM6Ly9idWxsZXQtaXMuZGV2LnVhLnB0IiwiYXVkIjoiYmVzdGxlZ2FjeV9hcGlfcmVzb3VyY2UiLCJjbGllbnRfaWQiOiJldmVudG9zIiwiY2xpZW50X3JlYWRfY2xhaW0iOiJ0cnVlIiwiY2xpZW50X2NyZWF0ZV9jbGFpbSI6InRydWUiLCJjbGllbnRfdXBkYXRlX2NsYWltIjoidHJ1ZSIsImNsaWVudF9kZWxldGVfY2xhaW0iOiJ0cnVlIiwic2NvcGUiOlsiYmVzdGxlZ2FjeV9hcGlfc2NvcGUiXX0.SzkC5bV5l4HAeWo11bQAtRIO9Uny2N_HTNGdZwIAEMqkU8ZYLv5C4xB3_8t4jK1bPoXyI3FDOhkZH35x0sL4AQ3DoO9GkUf6pR3lY8KhoEXWFhAJ4RXQlAi9HLYC8SfSx3muR66yij7aCHcaT_XwypQjVoO3-rVEvUnBiUs1fcVtUI21ke31n6jJK_Ho_ggSu1T2GcA7U4dIRSJlPWNXZMG-mu7dq3ZCLbeV7DOK9RuWCwNtDuMMvQ-t2tJIEByk4yn4PL2iBZWoyzGx_5rcnaHOEb4veyuqxlPpqYSOldmRZpuiIw5jydCSNXTb8ou6tso9t_ffXCFim0K17ECNFA';
String BASE_URL = 'bullet-api.dev.ua.pt';

class BrbBloc {
  StreamController<List<BuildCount>> buildCountStreamController =
      StreamController<List<BuildCount>>.broadcast();
  Stream get getBuildCount => buildCountStreamController.stream;

  void update(List<BuildCount> b) {
    buildCountStreamController.sink.add(b);
  }

  void dispose() {
    buildCountStreamController.close();
  }

  User currentUser;
  Stream<User> userSubscription = usersBloc.getUser;
  Future<User> initialize(String email) async {
    userSubscription.listen((newuser) {
      currentUser = newuser;
      getClassroomGroupsBuildings(currentUser.classroomGroupsId);
    });
    return await usersBloc.getCurrentUser(email);
  }

  void getClassroomGroupsBuildings(List<int> groupsIds) async {
    var classGroups = <ClassroomGroup>[];
    for (var id in groupsIds) {
      classGroups.add(await classroomGroupsBloc.getCurrentClassroomGroup(id));
    }
    var classroomsIds = HashSet<int>();
    for (var classG in classGroups) {
      classroomsIds.addAll(classG.classrooms);
    }

    var codesBuildings = HashMap<int, Building>();
    var data = <BuildCount>[];
    for (var classId in classroomsIds) {
      var cs = (await classroomsBloc.getClassroomById(classId));

      Building currentBuilding;
      if (codesBuildings.containsKey(cs.building)) {
        currentBuilding = codesBuildings[cs.building];
        for (var d in data) {
          if (d.building.id == cs.building) {
            d.classrooms.add(cs);
            d.count = d.classrooms.length;
          }
        }
      } else {
        currentBuilding = await buildingBloc.getBuildingById(cs.building);
        codesBuildings[cs.building] = currentBuilding;
        var _temp = <Classroom>[];
        _temp.add(cs);
        data.add(
            BuildCount(building: currentBuilding, classrooms: _temp, count: 1));
      }
    }
    update(data);

    //var x = getWeek();
  }

  /*
  String getWeek() {
    String date = DateTime.now().toString();
    String firstDay = date.substring(0, 8) + '01' + date.substring(10);
    int weekDay = DateTime.parse(firstDay).weekday;
    int todayDay = DateTime.now().day;
    int wholeWeeksSinceDayOne = ((todayDay - 1) / 7).floor();
    int beginningOfThisWeek = weekDay + 7 * wholeWeeksSinceDayOne;

    return beginningOfThisWeek.toString() +
        "/" +
        DateTime.now().month.toString() +
        "/" +
        DateTime.now().year.toString();
  } */

}

class BuildCount {
  BuildCount({this.building, this.count, this.classrooms});
  Building building;
  int count;
  List<Classroom> classrooms;
}

final buildingsUAData = BuildingUAData();
final weekBloc = WeekBloc();
final eventsBloc = EventsBloc();
final usersBloc = UsersBloc();
final buildingBloc = BuildingBloc();
final classroomGroupsBloc = ClassroomGroupsBloc();
final classroomsBloc = ClassroomsBloc();
final brbBloc = BrbBloc();
final homeBloc = HomeBloc();
final bookingsBloc = BookingsBloc();
final unavailableEventsBloc = UnavailableEventsBloc();
final postEventsBloc = PostEventsBloc();
final bookNearbyEventsBloc = BookNearbyEventsBloc();
