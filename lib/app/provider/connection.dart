import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';

class ConnectionProvider extends ChangeNotifier {
  bool _connect;
  Connectivity subscription = Connectivity();

  get connect => _connect;

  void setConnection(bool connect) {
    _connect = connect;
    notifyListeners();
  }

  Future checkConnection() async {
    var check = await subscription.checkConnectivity();
    if (check == ConnectivityResult.none) {
      setConnection(false);
    } else {
      setConnection(true);
    }
  }
}
