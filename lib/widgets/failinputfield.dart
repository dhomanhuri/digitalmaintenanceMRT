import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'package:mrt/utils/secure_storage.dart';

class Mydata {
  static List dataloc = ['malang', 'jakarta', 'surabaya'];
  static List datasys = ['A', 'B', 'C'];
  static List datasubsys = ['A1', 'B1', 'C1'];
  static List dataequip = ['E1', 'E2', 'E3'];
  static List datatrain = ['T1', 'T2', 'T3'];
}

class FailInputDropSubSys extends StatefulWidget {
  // final type;

  @override
  State<FailInputDropSubSys> createState() => _FailInputDropSubSysState();
  final String label;
  final String content;
  final control;

  FailInputDropSubSys(
      {Key? key,
      required this.label,
      required this.content,
      required this.control})
      : super(key: key);
}

class _FailInputDropSubSysState extends State<FailInputDropSubSys> {
  String? value;
  String _tokenJwt = '';
  String _cookies = '';

  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  // final String url = 'https://karyaku.id/mrtjakarta/public/api';
  List<dynamic> _getsubsystem1 = [];
  List<String> subsystemname1 = [];
  List<String> subsystemid1 = [];
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    String _token = await SecureStorage.getToken();
    String _cookie = await SecureStorage.getCookie();
    // print('_cookie: ' + _cookie);
    setState(() {
      _tokenJwt = _token;
      _cookies = _cookie;

      _subsystem1();
    });
    // int i = 0;
    // while (_getsubsystem1.isEmpty && i < 10) {
    //   _subsystem1();
    //   print('masih kosong');
    //   sleep(Duration(seconds: 1));
    // }
    // _subsystemfunc();
  }

  Future<void> _subsystem1() async {
    print('masuksubsystem external');
    print('token: ' + _tokenJwt[0]);
    print('tokenasds: ' + _cookies);
    var resp = await http.get(
        Uri.parse('http://147.139.134.143/mrtjakarta/public/api/systemsub/get'),
        headers: {
          'Cookie': _cookies,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _tokenJwt
        });
    print(resp.body);
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
    return Center(
      child: DropdownSearch<String>(
        mode: Mode.BOTTOM_SHEET,
        // showSelectedItem: true,
        items: subsystemname1,
        label: "Select Sub System external",
        // hint: "country in menu mode",
        onChanged: (value) {
          setState(() {
            int selectedint =
                subsystemname1.indexWhere((item) => item == value);
            String subsystem = subsystemid1[selectedint];
            value = subsystem;
            print(subsystem);
          });
        },
        showClearButton: true,
        // selectedItem: (){
        //   print();
        // },
      ),
    );
  }
}
