import 'package:sprintf/sprintf.dart';

class Week {
  Week(int _id, String begin) {
    id = _id;
    beginning = DateTime.parse(begin);

    ending = beginning.add(Duration(days: 6));
  }

  factory Week.fromJson(Map<String, dynamic> json) {
    var c = Week(json['id'], json['startDate']);
    return c;
  }

  int id;
  DateTime beginning, ending;

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
    var dates = <DateTime>[];
    var now = beginning;
    for (var i = 0; i < 7; i++) {
      dates.add(now.add(Duration(days: i)));
    }
    return dates;
  }
}
