import 'package:flutter/material.dart';
import 'package:mrt/NavDrawer.dart';
import 'package:mrt/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:syncfusion_flutter_charts/charts.dart';

class history extends StatefulWidget {
  static const String routeName = '/history';

  @override
  State<history> createState() => _historyState();
}

class _historyState extends State<history> {
  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  String _tokenJwt = '';
  String _cookie = '';
  List<dynamic> _getEquipment = [];
  late List<GDPData> _chartData;
  double a = 100.0;
  double b = 100.0;
  int n = 0;
  @override
  void initState() {
    super.initState();
    setState(() {
      _chartData = getChartData(a, b);
    });
    init();
  }

  Future init() async {
    String _token = await SecureStorage.getToken();
    String _cookies = await SecureStorage.getCookie();
    setState(() {
      _tokenJwt = _token;
      _cookie = _cookies;
    });
    _Equipment();
  }

  Future<void> _Equipment() async {
    print('token: ' + _tokenJwt[0]);
    var resp = await http.get(Uri.parse(url + "/equipment/get"), headers: {
      'cookie': _cookie,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    // var dataJSON = jsonDecode(resp.body);
    // for (var data in dataJSON) {
    // DepartmentItem(data['id'], data['name'], data['status']);
    // }
    print(jsonDecode(resp.body));
    setState(() {
      _getEquipment = [...jsonDecode(resp.body)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Equipment History"),
      ),
      drawer: NavDrawer(),
      body: new SingleChildScrollView(
          child: Column(children: [
        Container(
          padding: const EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 5, left: 5, right: 5),
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.blue[100]),
          child: Column(children: <Widget>[
            Align(
              child: Column(children: [
                Text('Enter Key Word or Equipment ID'),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Enter Key Word or Equipment ID',
                  ),
                ),
                RaisedButton(
                  onPressed: () {},
                  child: Text('Search'),
                )
              ]),
              alignment: Alignment.center,
            ),
          ]),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 5, left: 5, right: 5),
          width: double.infinity,
          height: _getEquipment.length * 50 + 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.blue[100]),
          child: Column(children: <Widget>[
            Align(
              child: Text('History:',
                  style: TextStyle(fontSize: 30, color: Colors.blue[700])),
              alignment: Alignment.topLeft,
            ),
            Align(
              child: Column(
                children: List.generate(_getEquipment.length, (index) {
                  return Text(
                    (index + 1).toString() +
                        '. ' +
                        _getEquipment[index]['name'].toString(),
                    textAlign: TextAlign.left,
                  );
                }),
              ),
              alignment: Alignment.topLeft,
            ),
          ]),
        ),
      ])),
    );
  }

  List<GDPData> getChartData(double a, double b) {
    final List<GDPData> chartData = [
      GDPData('a', a),
      GDPData('b', b),
    ];
    return chartData;
  }
}

class GDPData {
  GDPData(this.country, this.gdp);

  final String country;
  final double gdp;
}
//  Align(
//               child: Column(children: [
//                 for (var data in _getEquipment)
//                   Column(children: [
//                     Text(
//                       data['id'].toString() +
//                           '. ' +
//                           data['workorder_no'].toString(),
//                     )
//                   ]) // Text(data['id'].toString() + '. ' + data['name'].toString()),
//               ]),
//               alignment: Alignment.topLeft,
//             )