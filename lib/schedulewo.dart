import 'package:flutter/material.dart';
import 'package:mrt/NavDrawer.dart';

import 'package:mrt/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;
import 'package:mrt/utils/excelschedulewo.dart';

class schedulewo extends StatefulWidget {
  static const String routeName = '/schedulewo';

  @override
  State<schedulewo> createState() => _schedulewoState();
}

class _schedulewoState extends State<schedulewo> {
  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  String _tokenJwt = '';
  String _cookies = '';
  List<dynamic> _getpreventive = [];
  List<dynamic> _getfailure = [];
  TextEditingController wonumber = new TextEditingController();
  TextEditingController headonduty = new TextEditingController();
  TextEditingController starttime = new TextEditingController();
  TextEditingController endtime = new TextEditingController();
  TextEditingController technician1 = new TextEditingController();
  TextEditingController technician2 = new TextEditingController();
  TextEditingController technician3 = new TextEditingController();
  TextEditingController technician4 = new TextEditingController();
  TextEditingController technician5 = new TextEditingController();
  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    String _token = await SecureStorage.getToken();
    String _cookie = await SecureStorage.getCookie();
    setState(() {
      _tokenJwt = _token;
      _cookies = _cookie;
    });
  }

  Future<void> _Preventive() async {
    print('token: ' + _tokenJwt);
    var resp = await http.get(Uri.parse(url + "/preventive/get"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    try {
      if (resp.statusCode == 200) {
        print('success');
        _getpreventive = json.decode(resp.body);
      } else {
        throw (resp.statusCode);
      }
    } catch (err) {
      throw (err);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule WO"),
      ),
      drawer: NavDrawer(),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _Preventive(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error'),
              );
            } else {
              return showData();
            }
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createExcel(_getpreventive),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.print),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Column showData() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 5, left: 5, right: 5),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.blue[100]),
          child: Column(
            children: <Widget>[
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _getpreventive.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      print('indexnum');
                    },
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Workorder  ',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  if (_getpreventive[index]['description']
                                          .toString()
                                          .length >
                                      28) ...[
                                    Text(
                                      'Description  ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('  ',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ] else ...[
                                    Text(
                                      'Description  ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                  Text(
                                    'Period ',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Start Date ',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]),
                            Column(
                              children: [
                                Text(' : ',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                if (_getpreventive[index]['description']
                                        .toString()
                                        .length >
                                    28) ...[
                                  Text(' : ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  Text('  ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ] else ...[
                                  Text(
                                    ' : ',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                                Text(' : ',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                Text(' : ',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Flexible(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      _getpreventive[index]['workorder_no']
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      _getpreventive[index]['description']
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      _getpreventive[index]['period']
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      _getpreventive[index]['start_date']
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
