import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'BrbBloc.dart';

class AuthenticationBloc {
  Future getData(String url) async {
    var uri = Uri.http(
        'identity.ua.pt/oauth/authorize?oauth_token=_998f100a4b74a5d791c840b8538484158c4b351545',
        '');
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
    );
    debugPrint(response.body);

    return;
  }
}
