import 'package:flutter/material.dart';
import 'package:provider_http/app/model/siswa.dart';
import 'package:provider_http/app/provider/connection.dart';
import 'package:provider_http/app/provider/login.dart';
import 'package:provider_http/app/provider/siswa.dart';
import 'package:provider/provider.dart';
import 'package:provider_http/app/ui/addSiswa.dart';
import 'package:provider_http/app/ui/login.dart';
import 'package:provider_http/app/ui/updateSiswa.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Siswa> siswa;
  String token;
  bool connect;

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    SiswaProvider siswaProvider = Provider.of<SiswaProvider>(context);
    ConnectionProvider connectionProvider =
        Provider.of<ConnectionProvider>(context);
    loginProvider.setToken();
    token = context.watch<LoginProvider>().token;
    siswaProvider.getData(token);
    siswa = context.watch<SiswaProvider>().siswa;
    connectionProvider.checkConnection();
    connect = context.watch<ConnectionProvider>().connect;
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: () async {
              var result = await Navigator.push(
                _scaffoldState.currentContext,
                MaterialPageRoute(
                  builder: (BuildContext context) => AddSiswa(),
                ),
              );
              if (result != null) {
                setState(() {});
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              loginProvider.logout(token).then((value) async {
                if (value) {
                  var result = await Navigator.pushReplacement(
                    _scaffoldState.currentContext,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Login(),
                    ),
                  );
                  if (result != null) {
                    setState(() {});
                  }
                }
              });
            },
          )
        ],
        title: Text('Home'),
      ),
      body: Container(
        child: siswa == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: siswa.length,
                itemBuilder: (context, i) {
                  return Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Tampil(
                            siswa[i].id,
                            siswa[i].nama,
                            siswa[i].alamat,
                            siswa[i].t_lahir,
                            siswa[i].jl,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RaisedButton(
                                onPressed: () async {
                                  var result = await Navigator.push(
                                    _scaffoldState.currentContext,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          UpdateSiswa(siswa: siswa[i]),
                                    ),
                                  );
                                  if (result != null) {
                                    setState(() {});
                                  }
                                },
                                child: Text('Edit'),
                              ),
                              RaisedButton(
                                onPressed: () {
                                  if (connect) {
                                    siswaProvider
                                        .delete(siswa[i].id, token)
                                        .then((value) {
                                      if (value) {
                                        context.read<SiswaProvider>().setNull();
                                        context
                                            .read<LoginProvider>()
                                            .setKucing();
                                      }
                                    });
                                  } else {
                                    _scaffoldState.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Failed to connect to internet'),
                                      ),
                                    );
                                  }
                                },
                                child: Text('delete'),
                              ),
                              Padding(padding: EdgeInsets.all(10))
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}

class Tampil extends StatefulWidget {
  String nama, alamat, t_lahir, jl;
  int id;

  Tampil(this.id, this.nama, this.alamat, this.t_lahir, this.jl);

  @override
  _TampilState createState() => _TampilState();
}

class _TampilState extends State<Tampil> {
  double size = 15;
  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Id : ',
              style: TextStyle(fontSize: size),
            ),
            Text(
              widget.id.toString(),
              style: TextStyle(fontSize: size),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              'Nama : ',
              style: TextStyle(fontSize: size),
            ),
            Text(
              widget.nama,
              style: TextStyle(fontSize: size),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              'Alamat : ',
              style: TextStyle(fontSize: size),
            ),
            Text(
              widget.alamat,
              style: TextStyle(fontSize: size),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              'Tanggal lahir : ',
              style: TextStyle(fontSize: size),
            ),
            Text(
              widget.t_lahir,
              style: TextStyle(fontSize: size),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              'Jenis kelamin : ',
              style: TextStyle(fontSize: size),
            ),
            Text(
              widget.jl,
              style: TextStyle(fontSize: size),
            )
          ],
        ),
      ],
    );
  }
}
