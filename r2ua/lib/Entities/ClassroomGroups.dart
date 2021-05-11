
import 'dart:core';

import 'Building.dart';



class ClassroomGroup {
  String name, id;
  bool canCreateAnEvent, canRequestAnEvent;
  List<Owner> owners = new List<Owner>();
  List<int> classrooms = new List<int>();
  ClassroomGroup(
      {this.id, 
      this.name,
      this.canCreateAnEvent, 
      this.canRequestAnEvent,
      this.owners,
      this.classrooms,
      });


  factory ClassroomGroup.fromJson(Map<String, dynamic> json) {
    bool c = json['canCreateAnEvent'].toString().toLowerCase() == 'true';
    bool d = json['canRequestAnEvent'].toString().toLowerCase() == 'true';


    Iterable l = json['classroomGroupOwners']['owners'];
    List<Owner> _owners = List<Owner>.from(l.map((model)=> Owner.fromJson(model)));

    List<int> classes = new List<int>();
    for (var item in json['classrooms'] as List)
      classes.add(item['id']);

 
    return  ClassroomGroup(
            id: json['id'].toString(), 
            name: json['name'], 
            canCreateAnEvent: c,
            canRequestAnEvent: d,
            owners: _owners,
            classrooms: classes,
            );
  }



  
}


class Owner{
    String name, email, phone; 

    Owner({
      this.name, this.email, this.phone
    });

    factory Owner.fromJson(Map<String, dynamic> json) {
      return Owner(name: json['name'], email: json['email'], phone: json['phone']);
  }
  }

class Characteristic{
  int id;
  String name;
  bool active;

  Characteristic({
      this.id, this.name, this.active
    });
    
    factory Characteristic.fromJson(Map<String, dynamic> json) {
      bool a = json['active'].toString().toLowerCase() == 'true';
      return Characteristic(id: int.parse(json['name']), name: json['name'], active: a);
    }
}