import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;
import 'package:r2ua/Entities/Building.dart';
import 'package:r2ua/Entities/User.dart';

String token = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjQ4M2YzZWI0YzA3N2RjMDFmMjQ5MzIyNDk5NDM3NGJmIiwidHlwIjoiSldUIn0.eyJuYmYiOjE2MjA3MjI3MTQsImV4cCI6MTYyMzMxNDcxNCwiaXNzIjoiaHR0cHM6Ly9idWxsZXQtaXMuZGV2LnVhLnB0IiwiYXVkIjpbImh0dHBzOi8vYnVsbGV0LWlzLmRldi51YS5wdC9yZXNvdXJjZXMiLCJiZXN0bGVnYWN5X2FwaV9yZXNvdXJjZSJdLCJjbGllbnRfaWQiOiJyb29tX2Rpc3BsYXllciIsImNsaWVudF9jcmVhdGVfY2xhaW0iOiJ0cnVlIiwiY2xpZW50X3VwZGF0ZV9jbGFpbSI6InRydWUiLCJjbGllbnRfZGVsZXRlX2NsYWltIjoidHJ1ZSIsImNsaWVudF9yZWFkX2NsYWltIjoidHJ1ZSIsInNjb3BlIjpbImJlc3RsZWdhY3lfYXBpX3Njb3BlIl19.cFimUrako7Kj1ZnVs2WV-lO19fh4pbXAnYc4YbKVLK07J0TuTRHphQVwStbmhn_lzb97OnATtZ5MtSPvm61-VNNxaR5sIEZVZt6szqdrCTH2EG35R8NEh4X0SLyDxIWDtJ6lFbMKgklORHLpkbC1RFALJmTlBsB0D6gR6PRQcG8D0Dj3Vm2ioDRFhst9YYzbvP8In_pb-TldkISqBSWzDjj-y3tLpngiQaRHqKjl4-LAosCq9-AdNaKSb6c3pIO2yFW8s6bf2xqGdZvC-wNlQ4RdA8mi2vkGVyuhJTicycEdaOPkiDKFq-lWIEm8MCivwUnoiaCW1jL8PIcU-Iw4UQ";
String BASE_URL = 'bullet-api.dev.ua.pt';

class BuildingBloc {

  StreamController<List<Building>> buildingsStreamController = StreamController<List<Building>>.broadcast();
  Stream get getBuildingList => buildingsStreamController.stream;

  void update(List<Building> b) {
    buildingsStreamController.sink.add(b); // add whatever data we want into the Sink
  }

  void dispose() {
    buildingsStreamController.close(); // close our StreamController to emory leak
  }

  void stop(){
  }
  Future<List<Building>> getData(String url) async{
    var uri =
      Uri.https(BASE_URL, url);
    final response = await http.get(uri, 
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        HttpHeaders.contentTypeHeader: "application/json",
        "Access-Control-Allow-Origin": "*"
      },
    );
    Iterable l = json.decode(response.body)['data'];
    List<Building> buildings = List<Building>.from(l.map((model)=> Building.fromJson(model)));
    
    return buildings;
  }

  void getAllBuildings() async{
    List<Building> builds = await getData("/api/Buildings");
    update(builds);
  }
}

class UsersBloc {
  StreamController<List<User>> usersStreamController = StreamController<List<User>>.broadcast();
  Stream get getUsersList => usersStreamController.stream;

  void update(List<User> b) {
    usersStreamController.sink.add(b); // add whatever data we want into the Sink
  }

  void dispose() {
    usersStreamController.close(); // close our StreamController to emory leak
  }




  void stop(){
  }
  Future<List<User>> getData(String url) async{
    var uri =
      Uri.https(BASE_URL, url);
    final response = await http.get(uri, 
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        HttpHeaders.contentTypeHeader: "application/json",
        "Access-Control-Allow-Origin": "*"
      },
    );

    Iterable l = json.decode(response.body)['data'];
    List<User> users = List<User>.from(l.map((model)=> User.fromJson(model)));
    for (var item in users) {
      debugPrint(item.email);
      
    }
    return users;
  }

  void getAllUsers() async{
    List<User> users = await getData("/api/Users");
    update(users);
  }
}

final usersBloc = UsersBloc();



final buildingBloc = BuildingBloc();


