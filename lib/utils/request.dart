import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mrt/utils/secure_storage.dart';
import 'dart:async';

List<dynamic> _getsubsystem1 = [];
List<String> subsystemname1 = [];
List<String> subsystemid1 = [];

class requestfunc extends StatefulWidget {
  const requestfunc({Key? key}) : super(key: key);

  @override
  State<requestfunc> createState() => _requestfuncState();
}

class _requestfuncState extends State<requestfunc> {
  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  // final String url = 'https://karyaku.id/mrtjakarta/public/api';
  String _tokenJwt = '';
  String _cookies = '';
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    String _token = await SecureStorage.getToken();
    String _cookie = await SecureStorage.getCookie();
    print('_cookie: ' + _cookie);
    setState(() {
      _tokenJwt = _token;
      _cookies = _cookie;
    });
    _subsystem1();
  }

  Future<void> _subsystem1() async {
    print('masuksubsystem');
    var resp = await http.get(Uri.parse(url + "/systemsub/get"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });

    print('masuksubsystemwqewqewq');
    _getsubsystem1 = [...jsonDecode(resp.body)];
    print(jsonDecode(resp.body));
    setState(() {
      for (var i = 0; i < _getsubsystem1.length; i++) {
        subsystemname1.add(_getsubsystem1[i]['name'].toString());
        subsystemid1.add(_getsubsystem1[i]['id'].toString());
        // print(newdata);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
