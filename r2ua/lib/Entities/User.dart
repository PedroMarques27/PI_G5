import 'dart:core';

class User {
  User(
      {this.id,
      this.userName,
      this.email,
      this.profileId,
      this.classroomGroupsId,
      this.isActive,
      this.isAdmin,
      this.events});
  User.empty();
  factory User.fromJson(Map<String, dynamic> json) {
    var a = json['isActive'].toString().toLowerCase() == 'true';
    var b = json['isAdmin'].toString().toLowerCase() == 'true';
    var classes = <int>[];
    var evs = <int>[];

    int _profileId;

    if (json['userClassroomGroupBookings'] as List != []) {
      for (var item in json['userClassroomGroupBookings'] as List) {
        classes.add(item['id']);
      }
    }
    if (json['eventUsers'] as List != []) {
      for (var item in json['eventUsers'] as List) {
        evs.add(item['id']);
      }
    }
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
  String id, userName, email;
  int profileId;
  bool isActive, isAdmin;
  List<int> classroomGroupsId;
  List<int> events;
}
