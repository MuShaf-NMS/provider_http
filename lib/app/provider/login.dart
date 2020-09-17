import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider_http/app/model/login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  Login _login;
  String _token;

  get user => _login;

  get token => _token;

  void setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    _token = prefs.getString('token');
  }

  void setLogin(Login login) {
    _login = login;
    notifyListeners();
  }

  void setLogout(Login logout) {
    _login = logout;
    notifyListeners();
  }

  static const url = 'https://api-v2.pondokdiya.id';
  Future<bool> login(Map<String, String> data) async {
    final response = await http.post(
      '$url/login',
      headers: {'content-type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      setLogin(getToken(response.body));
      setToken(getToken(response.body).accessToken);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> logout(String token) async {
    final response = await http.get(
      '$url/logout',
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      setLogout(Login(
        accessToken: null,
        nama: null,
        username: null,
      ));
      return true;
    } else {
      return false;
    }
  }
}
