import 'dart:core';

import 'package:flutter/cupertino.dart';

class User {
  String id, userName, email;
  int profileId;
  bool isActive, isAdmin;
  List<int> classroomGroupsId;
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
    List<int> classes = new List<int>();
    List<int> evs = new List<int>();

    int _profileId = null;

    if (json['userClassroomGroupBookings'] as List != [])
      for (var item in json['userClassroomGroupBookings'] as List)
        classes.add(item['id']);

    if (json['eventUsers'] as List != [])
      for (var item in json['eventUsers'] as List) evs.add(item['id']);

    if (json['profile'] != null) {
      _profileId = json['profile']['id'];
    }

    return User(
        id: json['id'],
        userName: json['userName'],
        isActive: a,
        email: json['email'],
        profileId: _profileId,
        isAdmin: b,
        events: evs,
        classroomGroupsId: classes);
  }
}
