import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_http/app/provider/connection.dart';
import 'package:provider_http/app/provider/login.dart';
import 'package:provider_http/app/ui/home.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool connect;
  String token;

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    ConnectionProvider connectionProvider =
        Provider.of<ConnectionProvider>(context);
    connectionProvider.checkConnection();
    connect = context.watch<ConnectionProvider>().connect;
    token = context.watch<LoginProvider>().token;
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Card(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Center(
            child: ListView(
              children: <Widget>[
                Image.asset(
                  'images/logo.png',
                  width: 200,
                  height: 100,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: username,
                          decoration: InputDecoration(labelText: 'Username'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Username tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: password,
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value.length < 6) {
                              return 'Password terlalu pendek';
                            }
                            return null;
                          },
                        ),
                        RaisedButton(
                            child: Text('Login'),
                            onPressed: () {
                              if (connect) {
                                if (_formKey.currentState.validate()) {
                                  loginProvider.login({
                                    'username': username.text,
                                    'password': password.text
                                  }).then((value) {
                                    if (value) {
                                      Navigator.pushReplacement(
                                        _scaffoldState.currentContext,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Home(),
                                        ),
                                      );
                                    } else {
                                      _scaffoldState.currentState.showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'username or password wrong',
                                          ),
                                        ),
                                      );
                                    }
                                  });
                                }
                              } else {
                                _scaffoldState.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Failed to connect to internet',
                                    ),
                                  ),
                                );
                              }
                            })
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
