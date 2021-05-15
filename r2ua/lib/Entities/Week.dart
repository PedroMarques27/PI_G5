import 'package:sprintf/sprintf.dart';

class Week {
  int id;
  DateTime beginning, ending;

  Week(int _id, String begin) {
    this.id = _id;
    beginning = DateTime.parse(begin);
    ending = beginning.add(Duration(days: 7));
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

  factory Week.fromJson(Map<String, dynamic> json) {
    Week c = new Week(json['id'], json['startDate']);
    return c;
  }
}
