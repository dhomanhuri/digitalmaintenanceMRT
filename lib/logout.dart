import 'package:flutter/material.dart';
import 'package:mrt/NavDrawer.dart';
import 'package:mrt/pages/home_page.dart';

import 'package:mrt/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:mrt/main.dart';

class Logout extends StatefulWidget {
  static const String routeName = '/Logout';

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  // final String url = 'https://karyaku.id/mrtjakarta/public/api';
  String _tokenJwt = '';
  String _cookies = '';
  List<dynamic> _getLogout = [];

  @override
  void initState() {
    super.initState();
    init();

    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => HomePage()));
  }

  Future init() async {
    String _token = await SecureStorage.getToken();
    String _cookie = await SecureStorage.getCookie();
    // String _logout = await SecureStorage.deleteStorage();

    setState(() {
      _tokenJwt = _token;
      _cookies = _cookie;
    });
    _Logoutfunc();
    // await SecureStorage.deleteSecureAll();
  }

  Future<void> _Logoutfunc() async {
    print('tokenasd: ' + _tokenJwt[0]);
    var headers = {
      'Authorization': 'Bearer ' + _tokenJwt,
      'Cookie': _cookies,
    };
    var request = http.Request('POST',
        Uri.parse('http://147.139.134.143/mrtjakarta/public/api/logout'));
    request.bodyFields = {};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }

// print('token: ' + _tokenJwt[0]);
    await SecureStorage.deleteSecureAll();
    print('token sudah: ' + await SecureStorage.getToken());

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MyApp()));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Logout"),
      ),
      drawer: NavDrawer(),
      body: Text("Logout"),
    );
  }
}
