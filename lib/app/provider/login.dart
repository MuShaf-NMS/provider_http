import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:provider_http/app/model/login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  bool _isLogin;
  String _token;
  String _kucing;
  get isLogin => _isLogin;
  get token => _token;
  get kucing => _kucing;

  void checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLogin = prefs.getBool('isLogin');
    notifyListeners();
  }

  void setLogin(Login login) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', true);
    prefs.setString('token', login.accessToken);
    _token = prefs.getString('token');
    notifyListeners();
  }

  void setToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    notifyListeners();
  }

  void setKucing() {
    _kucing = 'Meong';
    notifyListeners();
  }

  void setLogout(Login logout) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
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
