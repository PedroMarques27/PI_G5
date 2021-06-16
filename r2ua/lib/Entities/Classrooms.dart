import 'dart:core';

class Classroom {
  Classroom({
    this.id,
    this.name,
    this.code,
    this.active,
    this.capacity,
    this.examCapacity,
    this.email,
    this.belongsToMyGroups,
    this.canCreateAnEvent,
    this.canRequestAnEvent,
    this.isMyFavorite,
    this.building,
    this.characteristics,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) {
    var a = json['active'].toString().toLowerCase() == 'true';
    var b = json['belongsToMyGroups'].toString().toLowerCase() == 'true';
    var c = json['canCreateAnEvent'].toString().toLowerCase() == 'true';
    var d = json['canRequestAnEvent'].toString().toLowerCase() == 'true';
    var e = json['isMyFavorite'].toString().toLowerCase() == 'true';

    Iterable m = json['characteristics'];
    var _characteristics = List<Characteristic>.from(
        m.map((model) => Characteristic.fromJson(model)));

    int build = json['building']['id'];

    return Classroom(
        id: int.parse(json['id'].toString()),
        capacity: int.parse(json['capacity'].toString()),
        examCapacity: int.parse(json['examCapacity'].toString()),
        name: json['name'],
        code: json['code'],
        email: json['email'],
        active: a,
        belongsToMyGroups: b,
        canCreateAnEvent: c,
        canRequestAnEvent: d,
        isMyFavorite: e,
        building: build,
        characteristics: _characteristics);
  }
  List<Characteristic> characteristics = <Characteristic>[];
  int id, capacity, examCapacity;
  int building;
  String name, code, email;
  bool active,
      belongsToMyGroups,
      canCreateAnEvent,
      canRequestAnEvent,
      isMyFavorite;
}

class Characteristic {
  Characteristic({this.id, this.name, this.active});

  factory Characteristic.fromJson(Map<String, dynamic> json) {
    var a = json['active'].toString().toLowerCase() == 'true';
    return Characteristic(id: json['id'], name: json['name'], active: a);
  }
  int id;
  String name;
  bool active;
}
