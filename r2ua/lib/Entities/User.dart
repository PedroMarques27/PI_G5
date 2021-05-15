import 'dart:core';

import 'package:flutter/cupertino.dart';

class User {
  String id, userName, email, profileId;
  bool isActive, isAdmin;
  List<String> classroomGroupsId;
  List<int> events;
  User(
      {this.id,
      this.userName,
      this.email,
      this.profileId,
      this.classroomGroupsId,
      this.isActive,
      this.isAdmin,
      this.events});

  factory User.fromJson(Map<String, dynamic> json) {
    bool a = json['isActive'].toString().toLowerCase() == 'true';
    bool b = json['isAdmin'].toString().toLowerCase() == 'true';
    List<String> classes = new List<String>();
    List<int> evs = new List<int>();
    for (var item in json['classroomGroups'] as List) classes.add(item['id']);
    for (var item in json['events'] as List) evs.add(item['id']);

    return User(
        id: json['id'],
        userName: json['userName'],
        isActive: a,
        email: json['email'],
        profileId: json['profile']['id'],
        isAdmin: b,
        events: evs,
        classroomGroupsId: classes);
  }
}
