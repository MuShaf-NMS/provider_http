import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_http/app/model/siswa.dart';
import 'package:provider_http/app/provider/connection.dart';
import 'package:provider_http/app/provider/login.dart';
import 'package:provider_http/app/provider/siswa.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class UpdateSiswa extends StatefulWidget {
  Siswa siswa;
  UpdateSiswa({this.siswa});

  @override
  _UpdateSiswaState createState() => _UpdateSiswaState();
}

class _UpdateSiswaState extends State<UpdateSiswa> {
  TextEditingController controllerNama;
  TextEditingController controllerAlamat;
  String jl, t_lahir, token;
  bool connect;

  Future kalender() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(t_lahir),
        firstDate: DateTime(1945),
        lastDate: DateTime(2021));
    if (picked != null) {
      setState(() {
        t_lahir = picked.toString().substring(0, 11);
      });
    }
  }

  @override
  void initState() {
    controllerNama = TextEditingController(text: widget.siswa.nama);
    controllerAlamat = TextEditingController(text: widget.siswa.alamat);
    t_lahir = widget.siswa.t_lahir;
    jl = widget.siswa.jl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SiswaProvider siswaProvider = Provider.of<SiswaProvider>(context);
    token = context.watch<LoginProvider>().token;
    connect = context.watch<ConnectionProvider>().connect;
    return Scaffold(
        key: _scaffoldState,
        appBar: AppBar(
          title: Text('Edit'),
        ),
        body: Card(
            child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: ListView(children: <Widget>[
              TextFormField(
                controller: controllerNama,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Nama tidak boleh kosong!';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controllerAlamat,
                decoration: InputDecoration(labelText: 'Alamat'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Alamat tidak boleh kosong!';
                  }
                  return null;
                },
              ),
              ListTile(
                subtitle: Text('Tanggal lahir'),
                contentPadding: EdgeInsets.all(0),
                leading: Icon(
                  Icons.calendar_today,
                  size: 40,
                ),
                title: Text(t_lahir),
                onTap: () {
                  kalender();
                },
              ),
              Text(
                'Jenis Kelamain',
                style: TextStyle(fontSize: 16),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text('L'),
                leading: Radio(
                    value: 'L',
                    groupValue: jl,
                    onChanged: (value) {
                      jl = value;
                      setState(() {});
                    }),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text('P'),
                leading: Radio(
                    value: 'P',
                    groupValue: jl,
                    onChanged: (value) {
                      jl = value;
                      setState(() {});
                    }),
              ),
              IconButton(
                  icon: Icon(Icons.file_upload),
                  onPressed: () {
                    if (connect) {
                      if (_formKey.currentState.validate()) {
                        Siswa siswa = Siswa(
                          nama: controllerNama.text,
                          alamat: controllerAlamat.text,
                          t_lahir: t_lahir,
                          jl: jl,
                        );
                        siswaProvider
                            .putData(siswa, widget.siswa.id, token)
                            .then((value) {
                          if (value) {
                            context.read<SiswaProvider>().setNull();
                            Navigator.pop(
                              _scaffoldState.currentState.context,
                              value,
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
                  }),
            ]),
          ),
        )));
  }
}
