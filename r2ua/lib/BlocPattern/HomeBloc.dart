import 'dart:async';
import 'package:r2ua/Entities/Event.dart';

import 'package:r2ua/db/BuildingsUAData.dart';
import 'BrbBloc.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'EventsBloc.dart';

class HomeBloc {
  StreamController<HomeView> homeViewStreamController =
      StreamController<HomeView>.broadcast();
  Stream get getHomeView => homeViewStreamController.stream;
  StreamSubscription<BuildingDistance> buildingDistanceSubscription;
  StreamSubscription<Event> eventSubscription;
  Event event;

  HomeView homeView;

  Future<void> startCapturing() async {
    update();

    eventSubscription = eventsBloc.getListOfEvents.listen((event) {
      homeView.events = event;
      update();
    });

    buildingDistanceSubscription =
        buildingsUAData.getBuildingsUA.listen((event) {
      homeView.buildingsDistance = event;
      update();
    });
  }

  void stop() {
    eventSubscription.cancel();
    buildingDistanceSubscription.cancel();
  }

  void update() {
    homeViewStreamController.sink
        .add(homeView); // add whatever data we want into the Sink
  }

  void dispose() {
    homeViewStreamController
        .close(); // close our StreamController to avoid memory leak
  }
}

class HomeView {
  List<Event> events;
  List<BuildingDistance> buildingsDistance;
  HomeView(this.events, this.buildingsDistance);
}
