import 'dart:async';
import 'package:r2ua/Entities/Event.dart';

import 'BrbBloc.dart';

class BookingsBloc {
  StreamController<BookingsData> bookingsViewStreamController =
      StreamController<BookingsData>.broadcast();
  Stream get getBookingsData => bookingsViewStreamController.stream;

  Event event;
  var futureEvents = <Event>[];
  var pastEvents = <Event>[];

  Future<void> startCapturing() async {
    eventsBloc.getListOfEvents.listen((event) {
      futureEvents = event;
      update();
    });

    eventsBloc.getListOfPastEvents.listen((list) {
      pastEvents = list;
      update();
    });
  }

  void update() {
    bookingsViewStreamController.sink.add(BookingsData(
        futureEvents, pastEvents));
  }

  void dispose() {
    bookingsViewStreamController.close();
  }
}

class BookingsData {
  BookingsData(this.futureEvents, this.pastEvents);
  List<Event> futureEvents = <Event>[];
  List<Event> pastEvents = <Event>[];
}
