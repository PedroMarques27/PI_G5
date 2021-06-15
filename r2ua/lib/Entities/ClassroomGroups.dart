import 'dart:core';

class ClassroomGroup {
  ClassroomGroup({
    this.id,
    this.name,
    this.canCreateAnEvent,
    this.canRequestAnEvent,
    this.owners,
    this.classrooms,
  });

  factory ClassroomGroup.fromJson(Map<String, dynamic> json) {
    var c = json['canCreateAnEvent'].toString().toLowerCase() == 'true';
    var d = json['canRequestAnEvent'].toString().toLowerCase() == 'true';

    Iterable l = json['classroomGroupOwners']['owners'];
    var _owners = List<Owner>.from(l.map((model) => Owner.fromJson(model)));

    var classes = <int>[];
    for (var item in json['classrooms'] as List) {
      classes.add(item['id']);
    }

    return ClassroomGroup(
      id: json['id'].toString(),
      name: json['name'],
      canCreateAnEvent: c,
      canRequestAnEvent: d,
      owners: _owners,
      classrooms: classes,
    );
  }

  String name, id;
  bool canCreateAnEvent, canRequestAnEvent;
  List<Owner> owners = <Owner>[];
  List<int> classrooms = <int>[];
}

class Owner {
  Owner({this.name, this.email, this.phone});

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
        name: json['name'], email: json['email'], phone: json['phone']);
  }

  String name, email, phone;
}

class Characteristic {
  Characteristic({this.id, this.name, this.active});

  factory Characteristic.fromJson(Map<String, dynamic> json) {
    var a = json['active'].toString().toLowerCase() == 'true';
    return Characteristic(
        id: int.parse(json['name']), name: json['name'], active: a);
  }

  int id;
  String name;
  bool active;
}
