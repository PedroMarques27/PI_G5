import 'dart:core';

class Building {
  Building({this.id, this.name, this.active});

  factory Building.fromJson(Map<String, dynamic> json) {
    var b = json['active'].toString().toLowerCase() == 'true';
    return Building(
        id: int.parse(json['id'].toString()), name: json['name'], active: b);
  }
  int id;
  String name;
  bool active;

  @override
  String toString() {
    return 'Building ' +
        id.toString() +
        ' ' +
        name +
        ', Active: ' +
        active.toString();
  }
}
