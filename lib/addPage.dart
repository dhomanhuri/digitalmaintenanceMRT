import 'package:flutter/material.dart';
import 'package:mrt/NavDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:mrt/utils/secure_storage.dart';
import 'dart:convert';

class useradd extends StatefulWidget {
  static const String routeName = '/useradd';

  @override
  State<useradd> createState() => _useraddState();
}

class _useraddState extends State<useradd> {
  // const Login({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  // final String url = 'https://karyaku.id/mrtjakarta/public/api';
  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  String _tokenJwt = '';
  String _cookies = '';
  String name = '';
  String email = '';
  String password = '';
  String phone = '';
  int department = 1;
  int role = 1;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    String _token = await SecureStorage.getToken();
    String _cookie = await SecureStorage.getCookie();
    setState(() {
      _tokenJwt = _token;
      _cookies = _cookie;
    });
  }

  Future<void> _adduser(String name, String email, String password,
      String phone, int department, int role) async {
    print('token: ' + _tokenJwt[0]);
    var resp = await http.post(Uri.parse(url + "/user/add"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _tokenJwt,
          'Cookie': _cookies
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'department': department,
          'role': role
        }));
    print(jsonDecode(resp.body));
  }

  Future<void> _addusernew(String name, String email, String password,
      String phone, int department, int role) async {
    var headers = {'Authorization': 'Bearer ' + _tokenJwt, 'Cookie': _cookies};
    var request = http.MultipartRequest('POST',
        Uri.parse('http://147.139.134.143/mrtjakarta/public/api/user/save/0'));
    request.fields.addAll({
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'department': department.toString(),
      'role': role.toString()
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add User"),
      ),
      drawer: NavDrawer(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 150.0, left: 20.0, right: 20.0),
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return 'Email tidak boleh kosong';
                    name = value;
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'username@jakartamrt.co.id',
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return 'Email tidak boleh kosong';
                    email = value;
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: '08xxx',
                    labelText: 'Phone',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return 'Email tidak boleh kosong';
                    phone = value;
                    return null;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return 'Email tidak boleh kosong';
                    password = value;
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Department',
                    labelText: 'Department',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return 'Email tidak boleh kosong';
                    department = int.parse(value);
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Role',
                    labelText: 'Role',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return 'Email tidak boleh kosong';
                    role = int.parse(value);
                    return null;
                  },
                ),
                Divider(),
                ElevatedButton(
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _addusernew(
                            name, email, password, phone, department, role);
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
