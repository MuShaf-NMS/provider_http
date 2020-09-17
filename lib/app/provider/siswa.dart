import 'package:flutter/foundation.dart';
import 'package:provider_http/app/model/siswa.dart';
import 'package:http/http.dart' as http;

class SiswaProvider extends ChangeNotifier {
  List<Siswa> _siswa;

  get siswa => _siswa;

  void setNull() {
    _siswa = null;
    notifyListeners();
  }

  void setSiswa(List<Siswa> siswa) {
    _siswa = siswa;
    notifyListeners();
  }

  static const url = 'https://api-v2.pondokdiya.id';
  Future getData(String token) async {
    final response = await http.get(
      '$url/siswa',
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      setSiswa(getAll(response.body));
    }
  }

  Future<bool> postData(Siswa data, String token) async {
    final response = await http.post(
      '$url/add-siswa',
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: dataToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> putData(Siswa data, int id, String token) async {
    final response = await http.put(
      '$url/siswa/$id',
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: dataToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> delete(int id, String token) async {
    final resposne = await http.delete(
      '$url/delete-siswa/$id',
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (resposne.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
