
import 'dart:core';

class Building {
  int id;
  String name;
  bool active;

  Building(
      {this.id, this.name, this.active});

  factory Building.fromJson(Map<String, dynamic> json) {
    bool b = json['active'].toString().toLowerCase() == 'true';
    return  Building(id: int.parse(json['id'].toString()), name: json['name'], active: b);
  }

  String toString(){
    return "Building "+id.toString() + " "+name + ", Active: "+active.toString();
  }
}

