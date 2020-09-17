import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_http/app/provider/connection.dart';
import 'package:provider_http/app/provider/login.dart';
import 'package:provider_http/app/provider/siswa.dart';
import 'package:provider_http/app/ui/login.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SiswaProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ConnectionProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Login(),
      ),
    );
  }
}
