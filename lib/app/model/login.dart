import 'dart:convert';

class Login {
  String username, nama, accessToken;
  Login({this.username, this.nama, this.accessToken});

  factory Login.fromJsonLogin(Map<String, dynamic> json) {
    return Login(
        username: json['username'],
        nama: json['nama'],
        accessToken: json['accessToken']);
  }
}

Login getToken(String jsonData) {
  return Login.fromJsonLogin(json.decode(jsonData));
}
