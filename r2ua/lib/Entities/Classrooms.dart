
import 'dart:core';

import 'package:flutter/cupertino.dart';

import 'Building.dart';
import 'ClassroomGroups.dart';



class Classroom {
  int id, capacity, examCapacity;
  int building;
  String name, code, email;
  bool active, belongsToMyGroups, canCreateAnEvent, canRequestAnEvent, isMyFavorite;
  List<Owner> owners = new List<Owner>();
  List<Characteristic> characteristics = new List<Characteristic>();
  Classroom(
      {this.id, 
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
      this.owners,
      this.building,
      this.characteristics,
      });


  factory Classroom.fromJson(Map<String, dynamic> json) {
    bool a = json['active'].toString().toLowerCase() == 'true';
    bool b = json['belongsToMyGroups'].toString().toLowerCase() == 'true';
    bool c = json['canCreateAnEvent'].toString().toLowerCase() == 'true';
    bool d = json['canRequestAnEvent'].toString().toLowerCase() == 'true';
    bool e = json['isMyFavorite'].toString().toLowerCase() == 'true';


    Iterable l = json['classroomGroupOwnersIdentification']['owners'];
    List<Owner> _owners = List<Owner>.from(l.map((model)=> Owner.fromJson(model)));

    Iterable m = json['characteristics'];
    List<Characteristic> _characteristics = List<Characteristic>.from(m.map((model)=> Characteristic.fromJson(model)));

    int build = json['building']['id'];
 
    return  Classroom(
        id: int.parse(json['id'].toString()),
        capacity: int.parse(json['capacity'].toString()), 
        examCapacity: int.parse(json['examCapacity'].toString()),
        name: json['name'], 
        code: json['code'], 
        email: json['email'],
        active:a,
        belongsToMyGroups:b,
        canCreateAnEvent:c,
        canRequestAnEvent:d,
        isMyFavorite:e,
        owners: _owners,
        building: build,
        characteristics: _characteristics
         );
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
      debugPrint(json.toString());
      return Characteristic(id: int.parse(json['id']), name: json['name'], active: a);
    }
}