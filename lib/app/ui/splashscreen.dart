import 'package:flutter/material.dart';
import 'package:provider_http/app/provider/login.dart';
import 'package:provider_http/app/ui/home.dart';
import 'dart:async';
import 'package:provider_http/app/ui/login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLogin;

  setLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLogin') == null) {
      isLogin = false;
      prefs.setBool('isLogin', false);
    }
    isLogin = prefs.getBool('isLogin');
  }

  @override
  void initState() {
    super.initState();
    setLogin();
    startSplashScreen();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return isLogin ? Home() : Login();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E747C),
      body: Center(
        child: Image.asset(
          'images/logo.png',
          width: 400,
          height: 200,
        ),
      ),
    );
  }
}
