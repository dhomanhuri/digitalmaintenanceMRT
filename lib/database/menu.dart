import 'package:flutter/material.dart';
import 'package:mrt/NavDrawer.dart';
import 'package:mrt/addwo.dart';
import 'package:mrt/inputwo.dart';
import 'package:mrt/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mrt/inputwo.dart';
import 'dart:convert';
import 'dart:async';

class menu extends StatefulWidget {
  static const String routeName = '/department';

  @override
  State<menu> createState() => _menuState();
}

class _menuState extends State<menu> {
  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  String _tokenJwt = '';
  String _cookies = '';
  List<dynamic> _getmenu = [];

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
    _menu();
  }

  Future<void> _menu() async {
    print('token: ' + _tokenJwt);
    var resp = await http.get(Uri.parse(url + "/menu/get"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    setState(() {
      _getmenu = jsonDecode(resp.body);
    });
    print(jsonDecode(resp.body));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => inputwo()));
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text("Schedule WO"),
        ),
        drawer: NavDrawer(),
        body: new SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                width: double.infinity,
                height: _getmenu.length * 140.0,
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
                      itemCount: _getmenu.length,
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
                                            _getmenu[index]['name'].toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'URL' +
                                            '. ' +
                                            _getmenu[index]['url'].toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Icon' +
                                            '. ' +
                                            _getmenu[index]['icon'].toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Level' +
                                            '. ' +
                                            _getmenu[index]['no_level']
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Arrange' +
                                            '. ' +
                                            _getmenu[index]['no_arrange']
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Status' +
                                            '. ' +
                                            _getmenu[index]['status']
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                              )),
                        );
                      })
                  //     Padding(
                  //         padding: const EdgeInsets.all(2),
                  //         child: Column(children: [
                  //           Table(
                  //             // ignore: prefer_const_literals_to_create_immutables
                  //             columnWidths: {
                  //               0: const FlexColumnWidth(1),
                  //               1: const FlexColumnWidth(2),
                  //               2: const FlexColumnWidth(2),
                  //               3: const FlexColumnWidth(2),
                  //             },
                  //             textDirection: TextDirection.ltr,
                  //             border:
                  //                 TableBorder.all(width: 1.0, color: Colors.white),
                  //             children: [
                  //               TableRow(
                  //                   decoration:
                  //                       BoxDecoration(color: Colors.blue[400]),
                  //                   children: [
                  //                     Container(
                  //                         padding: const EdgeInsets.all(4),
                  //                         child: Text("No",
                  //                             textScaleFactor: 1,
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.bold,
                  //                                 color: Colors.white,
                  //                                 backgroundColor:
                  //                                     Colors.blue[400]))),
                  //                     Container(
                  //                         padding: const EdgeInsets.all(4),
                  //                         child: Text("Equipment",
                  //                             textScaleFactor: 1,
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.bold,
                  //                                 color: Colors.white,
                  //                                 backgroundColor:
                  //                                     Colors.blue[400]))),
                  //                     Container(
                  //                         padding: const EdgeInsets.all(4),
                  //                         child: Text("Period",
                  //                             textScaleFactor: 1,
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.bold,
                  //                                 color: Colors.white,
                  //                                 backgroundColor:
                  //                                     Colors.blue[400]))),
                  //                     Container(
                  //                         padding: const EdgeInsets.all(4),
                  //                         child: Text("Location",
                  //                             textScaleFactor: 1,
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.bold,
                  //                                 color: Colors.white,
                  //                                 backgroundColor:
                  //                                     Colors.blue[400]))),
                  //                   ]),
                  //             ],
                  //           ),
                  //           SingleChildScrollView(
                  //             child: Table(
                  //               columnWidths: const {
                  //                 0: const FlexColumnWidth(1),
                  //                 1: const FlexColumnWidth(2),
                  //                 2: const FlexColumnWidth(2),
                  //                 3: const FlexColumnWidth(2),
                  //               },
                  //               children: _getpreventive.map((user) {
                  //                 return TableRow(children: [
                  //                   Container(
                  //                       padding: const EdgeInsets.all(5),
                  //                       child:
                  //                           Text(user['workorder_no'].toString())),
                  //                   Container(
                  //                       padding: const EdgeInsets.all(5),
                  //                       child:
                  //                           Text(user['description'].toString())),
                  //                   Container(
                  //                       padding: const EdgeInsets.all(5),
                  //                       child: Text(user['period'].toString())),
                  //                   Container(
                  //                       padding: const EdgeInsets.all(5),
                  //                       child: Text(user['period'].toString())),
                  //                 ]);
                  //               }).toList(),
                  //               border:
                  //                   TableBorder.all(width: 1, color: Colors.white),
                  //             ),
                  //           ),
                  //         ])),
                  //   ]),
                  // ),
                  // Container(
                  //   margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                  //   padding: EdgeInsets.all(10),
                  //   width: double.infinity,
                  //   height: MediaQuery.of(context).size.height / 2.3,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(15),
                  //       color: Colors.blue[100]),
                  //   child: Wrap(
                  //     children: [
                  //       Align(
                  //         child: Text('PM Calendar',
                  //             style: TextStyle(fontSize: 30, color: Colors.black)),
                  //         alignment: Alignment.topLeft,
                  //       ),
                  //       Container(
                  //         child: SfCalendar(
                  //           view: CalendarView.month,
                  //           monthViewSettings: MonthViewSettings(
                  //             dayFormat: 'EEE',
                  //           ),
                  //           todayTextStyle: TextStyle(fontWeight: FontWeight.bold),
                  //           headerStyle: CalendarHeaderStyle(
                  //               textAlign: TextAlign.center,
                  //               backgroundColor: Colors.blue[600],
                  //               textStyle: TextStyle(
                  //                   fontSize: 25,
                  //                   fontStyle: FontStyle.normal,
                  //                   letterSpacing: 5,
                  //                   color: Color(0xFFff5eaea),
                  //                   fontWeight: FontWeight.w500)),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // Container(
                  //   padding: const EdgeInsets.all(10),
                  //   margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(15),
                  //       color: Colors.blue[100]),
                  //   child: Column(children: <Widget>[
                  //     Align(
                  //       child: Text('WO Information',
                  //           style:
                  //               TextStyle(fontSize: 20, color: Colors.blue[700])),
                  //       alignment: Alignment.topLeft,
                  //     ),
                  //     Column(
                  //       children: [
                  //         InputField(
                  //           label: '1. WO Number',
                  //           content: 'WO Number',
                  //           type: TextInputType.number,
                  //           control: wonumber,
                  //         ),
                  //         Align(
                  //             alignment: Alignment.centerLeft,
                  //             child: Text(
                  //               '2. Manpower',
                  //               style: TextStyle(
                  //                   color: Colors.blue[700], fontSize: 16),
                  //             )),
                  //         Row(children: [
                  //           Container(
                  //             margin: EdgeInsets.only(left: 13),
                  //             child: Text(
                  //               'a. Sectionn Head on Duty',
                  //               style: TextStyle(
                  //                   fontSize: 16, color: Colors.blue[700]),
                  //             ),
                  //           ),
                  //           SizedBox(
                  //             width: 10,
                  //             child: Align(
                  //               alignment: Alignment.centerRight,
                  //               child: Text(':',
                  //                   style: TextStyle(
                  //                       color: Colors.blue[700], fontSize: 17)),
                  //             ),
                  //           ),
                  //           Container(
                  //             margin: EdgeInsets.only(left: 5, bottom: 2, top: 2),
                  //             height: 30,
                  //             width: MediaQuery.of(context).size.width / 2.6,
                  //             color: Colors.white,
                  //             child: TextField(
                  //               controller: headonduty,
                  //               style:
                  //                   TextStyle(fontSize: 16.0, color: Colors.black),
                  //               decoration: InputDecoration(
                  //                 contentPadding: EdgeInsets.all(5.0),
                  //                 border: OutlineInputBorder(),
                  //                 hintText: 'Sectionn Head on Duty',
                  //                 fillColor: Colors.white,
                  //               ),
                  //             ),
                  //           ),
                  //         ]),
                  //         Align(
                  //           alignment: Alignment.centerLeft,
                  //           child: Container(
                  //             width: MediaQuery.of(context).size.width / 2,
                  //             margin: EdgeInsets.only(left: 13),
                  //             child: Text(
                  //               'b. Technician :',
                  //               style: TextStyle(
                  //                   fontSize: 16, color: Colors.blue[700]),
                  //             ),
                  //           ),
                  //         ),
                  //         ListInputField(content: '', control: technician1),
                  //         ListInputField(content: '', control: technician2),
                  //         ListInputField(content: '', control: technician3),
                  //         ListInputField(content: '', control: technician4),
                  //         ListInputField(content: '', control: technician5),
                  //         InputTime(
                  //           label: '3. Start Time',
                  //           control: starttime,
                  //         ),
                  //         InputTime(
                  //           label: '4. End Time',
                  //           control: endtime,
                  //         ),
                  //       ],
                  //     ),
                  //   ]),
                  // ),
                  // Container(
                  //   padding: const EdgeInsets.all(10),
                  //   margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                  //   width: double.infinity,
                  //   height: 400,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(15),
                  //       color: Colors.blue[100]),
                  //   child: Column(children: <Widget>[
                  //     Align(
                  //       child: Text('W5282 2-week Maintenance',
                  //           style: TextStyle(fontSize: 30, color: Colors.black)),
                  //       alignment: Alignment.topLeft,
                  //     ),
                  //     Padding(
                  //         padding: const EdgeInsets.all(2),
                  //         child: Column(children: [
                  //           Table(
                  //             // ignore: prefer_const_literals_to_create_immutables
                  //             columnWidths: {
                  //               0: const FlexColumnWidth(1),
                  //               1: const FlexColumnWidth(2),
                  //               2: const FlexColumnWidth(2),
                  //               3: const FlexColumnWidth(2),
                  //             },
                  //             textDirection: TextDirection.ltr,
                  //             border:
                  //                 TableBorder.all(width: 1.0, color: Colors.white),
                  //             children: [
                  //               TableRow(
                  //                   decoration:
                  //                       BoxDecoration(color: Colors.blue[400]),
                  //                   children: [
                  //                     Container(
                  //                         padding: const EdgeInsets.all(4),
                  //                         child: Text("No",
                  //                             textScaleFactor: 1,
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.bold,
                  //                                 color: Colors.white,
                  //                                 backgroundColor:
                  //                                     Colors.blue[400]))),
                  //                     Container(
                  //                         padding: const EdgeInsets.all(4),
                  //                         child: Text("Item Pemeriksaan",
                  //                             textScaleFactor: 1,
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.bold,
                  //                                 color: Colors.white,
                  //                                 backgroundColor:
                  //                                     Colors.blue[400]))),
                  //                     Container(
                  //                         padding: const EdgeInsets.all(4),
                  //                         child: Text("Refrensi Standar",
                  //                             textScaleFactor: 1,
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.bold,
                  //                                 color: Colors.white,
                  //                                 backgroundColor:
                  //                                     Colors.blue[400]))),
                  //                     Container(
                  //                         padding: const EdgeInsets.all(4),
                  //                         child: Text("Hasil Pemeriksaan",
                  //                             textScaleFactor: 1,
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.bold,
                  //                                 color: Colors.white,
                  //                                 backgroundColor:
                  //                                     Colors.blue[400]))),
                  //                   ]),
                  //             ],
                  //           ),
                  //           SingleChildScrollView(
                  //             child: Table(
                  //               columnWidths: const {
                  //                 0: const FlexColumnWidth(1),
                  //                 1: const FlexColumnWidth(2),
                  //                 2: const FlexColumnWidth(2),
                  //                 3: const FlexColumnWidth(2),
                  //               },
                  //               children: _getpreventive.map((user) {
                  //                 return TableRow(children: [
                  //                   Container(
                  //                       padding: const EdgeInsets.all(5),
                  //                       child:
                  //                           Text(user['workorder_no'].toString())),
                  //                   Container(
                  //                       padding: const EdgeInsets.all(5),
                  //                       child:
                  //                           Text(user['description'].toString())),
                  //                   Container(
                  //                       padding: const EdgeInsets.all(5),
                  //                       child: Text(user['period'].toString())),
                  //                   Container(
                  //                       padding: const EdgeInsets.all(5),
                  //                       child: Text(user['period'].toString())),
                  //                 ]);
                  //               }).toList(),
                  //               border:
                  //                   TableBorder.all(width: 1, color: Colors.white),
                  //             ),
                  //           ),
                  //         ])),
                ]),
              ),
            ],
          ),
        ));
  }
}
