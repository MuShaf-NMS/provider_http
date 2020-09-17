import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_http/app/model/siswa.dart';
import 'package:provider_http/app/provider/connection.dart';
import 'package:provider_http/app/provider/login.dart';
import 'package:provider_http/app/provider/siswa.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class AddSiswa extends StatefulWidget {
  @override
  _AddSiswaState createState() => _AddSiswaState();
}

class _AddSiswaState extends State<AddSiswa> {
  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerAlamat = TextEditingController();
  String tglLahir = 'Tanggal lahir';
  String jl, token;
  bool connect;

  Future kalender() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1945),
        lastDate: DateTime(2021));
    if (picked != null) {
      setState(() {
        tglLahir = picked.toString().substring(0, 11);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SiswaProvider siswaProvider = Provider.of<SiswaProvider>(context);
    token = context.watch<LoginProvider>().token;
    connect = context.watch<ConnectionProvider>().connect;
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text('Tambah Siswa'),
      ),
      body: Card(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
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
                  title: Text(tglLahir),
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
                            t_lahir: tglLahir,
                            jl: jl,
                          );
                          siswaProvider.postData(siswa, token).then((value) {
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
                            content: Text('Failed to connect to internet'),
                          ),
                        );
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
