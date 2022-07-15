import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mrt/utils/secure_storage.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _headerStyle = const TextStyle(
      color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold);
  // const Login({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final String url = 'https://karyaku.id/mrtjakarta/public/api';
  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  String email = '';
  String password = '';

  List<dynamic> datarole = [];
  List<dynamic> datadepartment = [];

  Future<void> _loginByEmail(email, password) async {
    var resp = await http.post(Uri.parse(url + "/login"),
        body: {'email': email, 'password': password});
    print(json.decode(resp.body)!['success']);
    if (json.decode(resp.body)!['success'] == false) {
      print('object');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(json.decode(resp.body)!['message']),
      ));
    } else {
      print('gagl');
    }
    datarole = json.decode(resp.body)!['data']['role'].toString().split(',');
    datadepartment =
        json.decode(resp.body)!['data']['department'].toString().split(',');
    print('das ' + datarole[0]);
    String role = datarole[0];
    String department = datadepartment[0];
    String tokenJwt = json.decode(resp.body)!['token'];
    // String fkdepartment = json.decode(resp.body)!['fk_department/name'];
    String? cookie = resp.headers['set-cookie']!.split(';')[0];
    if (tokenJwt.isEmpty) return print('gagal');
    print(jsonDecode(resp.body));

    await SecureStorage.setDepartment(department);
    await SecureStorage.setToken(tokenJwt);
    await SecureStorage.setRole(role);
    // await SecureStorage.setRole(role);
    // await SecureStorage.setFkdepartmen(fkdepartment);
    await SecureStorage.setCookie(cookie);
    Navigator.of(context).pushReplacementNamed('/home');
  }

  // Initially password is obscure
  bool _obscureText = true;
  // Toggles the password show status
  void _togglePasswordStatus() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Login'),
      // ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Logo JAK.png',
                        height: 135,
                      ),
                      Image.asset(
                        'assets/images/Logo MRT.png',
                        height: 135,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Card(
                      // margin: EdgeInsets.all(15),
                      elevation: 8,
                      shadowColor: Colors.blue,
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white)),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: ListTile(
                              title: Text(
                                'APLIKASI DIGITAL MAINTENANCE MRT JAKARTA',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      hintText: 'username@jakartamrt.co.id',
                                      labelText: 'Email',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty)
                                        return 'Email tidak boleh kosong';
                                      email = value;
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureText
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        onPressed: _togglePasswordStatus,
                                        color: Colors.black,
                                      ),
                                    ),
                                    obscureText: _obscureText,
                                    validator: (value) {
                                      if (value!.isEmpty)
                                        return 'Password tidak boleh kosong';
                                      password = value;
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  FlatButton.icon(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        await _loginByEmail(email, password);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.login,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      'Login',
                                      style: _headerStyle,
                                    ),
                                    color: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: EdgeInsets.only(top: 5),
                                  //   child: ElevatedButton(
                                  //     child: const Text(
                                  //       'Submit',
                                  //       style: TextStyle(color: Colors.white),
                                  //     ),
                                  //     style: ElevatedButton.styleFrom(
                                  //         primary: Colors.blue),
                                  //     onPressed: () async {
                                  //       if (_formKey.currentState!.validate()) {
                                  //         await _loginByEmail(email, password);
                                  //       }
                                  //     },
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
