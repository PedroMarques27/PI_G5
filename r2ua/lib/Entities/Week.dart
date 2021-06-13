import 'package:flutter/cupertino.dart';
import 'package:sprintf/sprintf.dart';

class Week {
  int id;
  DateTime beginning, ending;

  Week(int _id, String begin) {
<<<<<<< HEAD
    debugPrint(begin.toString() + " &&&&_" + beginning.toString());

=======
>>>>>>> ft/join_blocks
    this.id = _id;
    beginning = DateTime.parse(begin);

    ending = beginning.add(Duration(days: 6));
  }

  String getFormattedBegin() {
    return sprintf('%s/%s/%s', [
      beginning.day.toString(),
      beginning.month.toString(),
      beginning.year.toString()
    ]);
  }

  String getFormattedEnding() {
    return sprintf('%s/%s/%s', [
      ending.day.toString(),
      ending.month.toString(),
      ending.year.toString()
    ]);
  }

  List<DateTime> getDaysInTheWeek() {
    List<DateTime> dates = new List<DateTime>();
    DateTime now = beginning;
    for (int i = 0; i < 7; i++) {
      dates.add(now.add(Duration(days: i)));
    }
    return dates;
  }

  factory Week.fromJson(Map<String, dynamic> json) {
    Week c = new Week(json['id'], json['startDate']);
    return c;
  }
}
