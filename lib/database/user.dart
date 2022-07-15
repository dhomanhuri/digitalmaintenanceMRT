import 'package:flutter/material.dart';
import 'package:mrt/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mrt/addPage.dart';

class user extends StatefulWidget {
  @override
  State<user> createState() => _userState();
}

class _userState extends State<user> {
  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  // final String url = 'https://karyaku.id/mrtjakarta/public/api';
  String _tokenJwt = '';
  String _cookie = '';
  String indexnum = '';
  List<dynamic> _userGetdata = [];
  // const Login({Key? key}) : super(key: key);

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    String _token = await SecureStorage.getToken();
    String _cookies = await SecureStorage.getCookie();
    setState(() {
      _tokenJwt = _token;
      _cookie = _cookies;
    });
    _userGet();
  }

  Future<void> _userGet() async {
    print('token: ' + _tokenJwt[0]);
    print('token: ' + _cookie);
    var resp = await http.get(Uri.parse(url + "/user/get"), headers: {
      'cookie': _cookie,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    //print(jsonDecode(resp.body));
    setState(() {
      _userGetdata = [...jsonDecode(resp.body)];
    });
  } // ini untuk menampilkan semua user

  Future<void> _userDel(String a) async {
    print('token: ' + _tokenJwt[0]);
    var resp =
        await http.post(Uri.parse(url + "/user/status/2/" + a), headers: {
      'cookie': _cookie,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    }, body: {});

    print(jsonDecode(resp.body));
  } // ini untuk menghapus user, di perlukan index user untuk menghapus user ke-index

  Future<void> _userAdd(String email, String phone, String password,
      String department, String role) async {
    print('token: ' + _tokenJwt[0]);
    var resp = await http.post(Uri.parse(url + "/user/save/0"), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    }, body: {
      'email': email.toString(),
      'phone': phone.toString(),
      'password': password.toString(),
      'department': department.toString(),
      'role': role.toString()
    });
  } // ini untuk menambahkan userbaru, diperlukan input beberapa parameter untuk mengisi field yang di perlukan

  Future<void> _userUpdate(String email, String phone, String password,
      String department, String role) async {
    print('token: ' + _tokenJwt[0]);
    var resp = await http.post(Uri.parse(url + "/user/save/0"), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    }, body: {
      'email': email.toString(),
      'phone': phone.toString(),
      'password': password.toString(),
      'department': department.toString(),
      'role': role.toString()
    });
  } // ini untuk menambahkan userbaru, diperlukan input beberapa parameter untuk mengisi field yang di perlukan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => useradd()));
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text('User List'),
        ),
        body: new SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                width: double.infinity,
                height: _userGetdata.length * 140.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue[100]),
                child: Column(children: <Widget>[
                  // Align(
                  //   child: Text('Workorders:',
                  //       style: TextStyle(fontSize: 30, color: Colors.black)),
                  //   alignment: Alignment.topLeft,
                  // ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _userGetdata.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // indexnum = _userGetdata[index]['id'].toString();
                            print('indexnum');

                            // _userDel(indexnum);
                          },
                          child: Card(
                              elevation: 8,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Name' +
                                            '. ' +
                                            _userGetdata[index]['name']
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Email' +
                                            '. ' +
                                            _userGetdata[index]['email']
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Role' +
                                            '. ' +
                                            _userGetdata[index]['role']
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Department' +
                                            '. ' +
                                            _userGetdata[index]['department']
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Phone' +
                                            '. ' +
                                            _userGetdata[index]['phone']
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Status' +
                                            '. ' +
                                            _userGetdata[index]['status']
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                              )),
                        );
                      })
                ]),
              ),
            ],
          ),
        ));
  }
}
