import 'package:flutter/material.dart';
import 'package:mrt/NavDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:mrt/failureAdd.dart';
import 'package:mrt/utils/secure_storage.dart';
import 'dart:convert';
import 'package:snippet_coder_utils/hex_color.dart';

class failure extends StatefulWidget {
  static const String routeName = '/failure';

  @override
  State<failure> createState() => _failureState();
}

String _tokenJwt = '';
String _cookies = '';

class _failureState extends State<failure> {
  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  // final String url = 'https://karyaku.id/mrtjakarta/public/api';
  // String _tokenJwt = '';
  // String _cookies = '';
  List<dynamic> _getopenfailure = [];
  List<dynamic> _getfailure = [];
  List<dynamic> _getprogressfailure = [];
  List<dynamic> _getclosefailure = [];
  // const Login({Key? key}) : super(key: key);

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
      _openfailure();
      _failure();
      // _subsystem1();
      // _progressfailure();
      // _closefailure();
    });
  }

  Future<void> _failureDel(String a) async {
    print('token: ' + _tokenJwt[0]);
    var resp = await http
        .post(Uri.parse(url + "/failureopen/status/2/" + a), headers: {
      'cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });

    print(jsonDecode(resp.body));
  } // i

  Future<void> _closefailure() async {
    print('token: ' + _tokenJwt[0]);
    var resp = await http.get(Uri.parse(url + "/failureclose/get"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    _getclosefailure = [...jsonDecode(resp.body)]; //ini data fauilure close
    print(jsonDecode(resp.body));
  }

  Future<void> _progressfailure() async {
    print('token: ' + _tokenJwt[0]);
    var resp =
        await http.get(Uri.parse(url + "/failureprogress/get"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    _getprogressfailure = [
      ...jsonDecode(resp.body)
    ]; //ini data fauilure progress
  }

  Future<void> _openfailure() async {
    print('token: ' + _tokenJwt[0]);
    var resp = await http.get(Uri.parse(url + "/failureopen/get"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    setState(() {
      _getopenfailure = [...jsonDecode(resp.body)]; //ini data fauilure open
    });
    //print(jsonDecode(resp.body));
  }

  Future<void> _failure() async {
    print('token: ' + _tokenJwt[0]);
    var resp = await http.get(Uri.parse(url + "/failure/get"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    setState(() {
      _getfailure = [...jsonDecode(resp.body)]; //ini data fauilure
    });
  }

  Future<void> _FailureOpenAdd(
    String workorder_no,
    String title,
    int location,
    int area,
    String delay,
    int reported_department,
    int received_department,
    String report_date,
    String failure_date,
    String failure_time,
    int system,
    int system_sub,
    int equipment,
    int equipment_id,
    String trainset,
    String failure_description,
    String report_action,
    String attach_file,
    String note,
    int status,
    int status_procces,
    int status_aprove,
    int create_user,
    int update_user,
    String departmentname,
  ) async {
    print('token: ' + _tokenJwt[0]);
    var resp =
        await http.post(Uri.parse(url + "/failureopen/save/0"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    }, body: {
      "workorder_no": workorder_no,
      "title": title,
      "location": location,
      "area": area,
      "delay": delay,
      "reported_department": reported_department,
      "received_department": received_department,
      "report_date": reported_department,
      "failure_date": failure_date,
      "failure_time": failure_time,
      "system": system,
      "system_sub": system_sub,
      "equipment": equipment,
      "equipment_id": equipment_id,
      "trainset": trainset,
      "failure_description": failure_description,
      "report_action": report_action,
      "attach_file": attach_file,
      "note": note,
      "status": status,
      "status_proses": status_procces,
      "status_approve": status_aprove,
      "created_user": create_user,
      "updated_user": update_user,
      "departmentname": departmentname,
    });
  } // ini untuk menambahkan failure baru, diperlukan input beberapa parameter untuk mengisi field yang di perlukan

  Future<void> _FailureOpenUpdate(
      String workorder_no,
      String title,
      int location,
      int area,
      String delay,
      int reported_department,
      int received_department,
      String report_date,
      String failure_date,
      String failure_time,
      int system,
      int system_sub,
      int equipment,
      int equipment_id,
      String trainset,
      String failure_description,
      String report_action,
      String attach_file,
      String note,
      int status,
      int status_procces,
      int status_aprove,
      int create_user,
      int update_user,
      String departmentname,
      int indexfail) async {
    print('token: ' + _tokenJwt[0]);
    var resp = await http.post(
        Uri.parse(url + "/failureopen/save/" + indexfail.toString()),
        headers: {
          'Cookie': _cookies,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _tokenJwt
        },
        body: {
          "workorder_no": workorder_no,
          "title": title,
          "location": location,
          "area": area,
          "delay": delay,
          "reported_department": reported_department,
          "received_department": received_department,
          "report_date": reported_department,
          "failure_date": failure_date,
          "failure_time": failure_time,
          "system": system,
          "system_sub": system_sub,
          "equipment": equipment,
          "equipment_id": equipment_id,
          "trainset": trainset,
          "failure_description": failure_description,
          "report_action": report_action,
          "attach_file": attach_file,
          "note": note,
          "status": status,
          "status_proses": status_procces,
          "status_approve": status_aprove,
          "created_user": create_user,
          "updated_user": update_user,
          "departmentname": departmentname,
        });
  } // ini untuk menambahkan failure baru, diperlukan input beberapa parameter untuk mengisi field yang di perlukan

  Future<void> _FailureProgressAdd(
    String workorder_no,
    String title,
    int location,
    int area,
    String delay,
    int reported_department,
    int received_department,
    String report_date,
    String failure_date,
    String failure_time,
    int system,
    int system_sub,
    int equipment,
    int equipment_id,
    String trainset,
    String failure_description,
    String report_action,
    String attach_file,
    String note,
    int status,
    int status_procces,
    int status_aprove,
    int create_user,
    int update_user,
    String departmentname,
  ) async {
    print('token: ' + _tokenJwt[0]);
    var resp =
        await http.post(Uri.parse(url + "/failureprogress/save/0"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    }, body: {
      "workorder_no": workorder_no,
      "title": title,
      "location": location,
      "area": area,
      "delay": delay,
      "reported_department": reported_department,
      "received_department": received_department,
      "report_date": reported_department,
      "failure_date": failure_date,
      "failure_time": failure_time,
      "system": system,
      "system_sub": system_sub,
      "equipment": equipment,
      "equipment_id": equipment_id,
      "trainset": trainset,
      "failure_description": failure_description,
      "report_action": report_action,
      "attach_file": attach_file,
      "note": note,
      "status": status,
      "status_proses": status_procces,
      "status_approve": status_aprove,
      "created_user": create_user,
      "updated_user": update_user,
      "departmentname": departmentname,
    });
  } // ini untuk menambahkan failure baru, diperlukan input beberapa parameter untuk mengisi field yang di perlukan

  Future<void> _FailureProgressUpdate(
      String workorder_no,
      String title,
      int location,
      int area,
      String delay,
      int reported_department,
      int received_department,
      String report_date,
      String failure_date,
      String failure_time,
      int system,
      int system_sub,
      int equipment,
      int equipment_id,
      String trainset,
      String failure_description,
      String report_action,
      String attach_file,
      String note,
      int status,
      int status_procces,
      int status_aprove,
      int create_user,
      int update_user,
      String departmentname,
      int indexfail) async {
    print('token: ' + _tokenJwt[0]);
    var resp = await http.post(
        Uri.parse(url + "/failureprogress/save/" + indexfail.toString()),
        headers: {
          'Cookie': _cookies,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _tokenJwt
        },
        body: {
          "workorder_no": workorder_no,
          "title": title,
          "location": location,
          "area": area,
          "delay": delay,
          "reported_department": reported_department,
          "received_department": received_department,
          "report_date": reported_department,
          "failure_date": failure_date,
          "failure_time": failure_time,
          "system": system,
          "system_sub": system_sub,
          "equipment": equipment,
          "equipment_id": equipment_id,
          "trainset": trainset,
          "failure_description": failure_description,
          "report_action": report_action,
          "attach_file": attach_file,
          "note": note,
          "status": status,
          "status_proses": status_procces,
          "status_approve": status_aprove,
          "created_user": create_user,
          "updated_user": update_user,
          "departmentname": departmentname,
        });
  } // ini untuk menambahkan failure baru, diperlukan input beberapa parameter untuk mengisi field yang di perlukan

  Future<void> _failureProgressDel(int indexnum) async {
    print('token: ' + _tokenJwt[0]);
    var resp = await http.post(
        Uri.parse(url + "/failureprogress/status/2/" + indexnum.toString()),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _tokenJwt
        });
  } // ini untuk menghapus user, di perlukan index user untuk menghapus user ke-index

  Future<void> _FailureCloseAdd(
    String workorder_no,
    String title,
    int location,
    int area,
    String delay,
    int reported_department,
    int received_department,
    String report_date,
    String failure_date,
    String failure_time,
    int system,
    int system_sub,
    int equipment,
    int equipment_id,
    String trainset,
    String failure_description,
    String report_action,
    String attach_file,
    String note,
    int status,
    int status_procces,
    int status_aprove,
    int create_user,
    int update_user,
    String departmentname,
  ) async {
    print('token: ' + _tokenJwt[0]);
    var resp =
        await http.post(Uri.parse(url + "/failureclose/save/0"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    }, body: {
      "workorder_no": workorder_no,
      "title": title,
      "location": location,
      "area": area,
      "delay": delay,
      "reported_department": reported_department,
      "received_department": received_department,
      "report_date": reported_department,
      "failure_date": failure_date,
      "failure_time": failure_time,
      "system": system,
      "system_sub": system_sub,
      "equipment": equipment,
      "equipment_id": equipment_id,
      "trainset": trainset,
      "failure_description": failure_description,
      "report_action": report_action,
      "attach_file": attach_file,
      "note": note,
      "status": status,
      "status_proses": status_procces,
      "status_approve": status_aprove,
      "created_user": create_user,
      "updated_user": update_user,
      "departmentname": departmentname,
    });
  } // ini untuk menambahkan failure baru, diperlukan input beberapa parameter untuk mengisi field yang di perlukan

  Future<void> _FailureCloseUpdate(
      String workorder_no,
      String title,
      int location,
      int area,
      String delay,
      int reported_department,
      int received_department,
      String report_date,
      String failure_date,
      String failure_time,
      int system,
      int system_sub,
      int equipment,
      int equipment_id,
      String trainset,
      String failure_description,
      String report_action,
      String attach_file,
      String note,
      int status,
      int status_procces,
      int status_aprove,
      int create_user,
      int update_user,
      String departmentname,
      int indexfail) async {
    print('token: ' + _tokenJwt[0]);
    var resp = await http.post(
        Uri.parse(url + "/failureclose/save/" + indexfail.toString()),
        headers: {
          'Cookie': _cookies,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _tokenJwt
        },
        body: {
          "workorder_no": workorder_no,
          "title": title,
          "location": location,
          "area": area,
          "delay": delay,
          "reported_department": reported_department,
          "received_department": received_department,
          "report_date": reported_department,
          "failure_date": failure_date,
          "failure_time": failure_time,
          "system": system,
          "system_sub": system_sub,
          "equipment": equipment,
          "equipment_id": equipment_id,
          "trainset": trainset,
          "failure_description": failure_description,
          "report_action": report_action,
          "attach_file": attach_file,
          "note": note,
          "status": status,
          "status_proses": status_procces,
          "status_approve": status_aprove,
          "created_user": create_user,
          "updated_user": update_user,
          "departmentname": departmentname,
        });
  } // ini untuk menambahkan failure baru, diperlukan input beberapa parameter untuk mengisi field yang di perlukan

  Future<void> _failureCloseDel(int indexnum) async {
    print('token: ' + _tokenJwt[0]);
    var resp = await http.post(
        Uri.parse(url + "/failureclose/status/2/" + indexnum.toString()),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _tokenJwt
        });
  } // ini untuk menghapus user, di perlukan index user untuk menghapus user ke-index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Failure Report',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
                child: Container(
              padding: const EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 5, left: 5, right: 5),
              width: double.infinity,
              height: _getopenfailure.length * 190.0 + 20.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blue[100]),
              child: Column(children: <Widget>[
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _getfailure.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // indexnum = _userGetdata[index]['id'].toString();
                          // print(_getfailure[index]['id'].toString());
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialog(context,
                                    _getfailure[index]['id'].toString()),
                          );
                        },
                        child: Card(
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Title                 : ' +
                                          _getfailure[index]['title'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Workorder      : ' +
                                          _getfailure[index]['report_date'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Department    : ' +
                                          _getfailure[index]['departmentname'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'System    : ' +
                                          _getfailure[index]['systemname'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Sub System    : ' +
                                          _getfailure[index]['system_subname'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Equipment     : ' +
                                          _getfailure[index]['equipmentname'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Equipment ID : ' +
                                          _getfailure[index]
                                              ['equipment_idname'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Status              : ' +
                                          _getfailure[index]['status']
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                            )),
                      );
                    })
                //     //ini untuk menampilkan list failure
                //     Align(
                //       child: Text('On Going Failure:',
                //           style: TextStyle(fontSize: 20, color: Colors.blue[700])),
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
                //               4: const FlexColumnWidth(2),
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
                //                         child: Text("Title",
                //                             textScaleFactor: 1,
                //                             style: TextStyle(
                //                                 fontWeight: FontWeight.bold,
                //                                 color: Colors.white,
                //                                 backgroundColor:
                //                                     Colors.blue[400]))),
                //                     Container(
                //                         padding: const EdgeInsets.all(4),
                //                         child: Text("WO Date",
                //                             textScaleFactor: 1,
                //                             style: TextStyle(
                //                                 fontWeight: FontWeight.bold,
                //                                 color: Colors.white,
                //                                 backgroundColor:
                //                                     Colors.blue[400]))),
                //                     Container(
                //                         padding: const EdgeInsets.all(4),
                //                         child: Text("Last Post",
                //                             textScaleFactor: 1,
                //                             style: TextStyle(
                //                                 fontWeight: FontWeight.bold,
                //                                 color: Colors.white,
                //                                 backgroundColor:
                //                                     Colors.blue[400]))),
                //                     Container(
                //                         padding: const EdgeInsets.all(4),
                //                         child: Text("Status",
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
                //                 4: const FlexColumnWidth(2),
                //               },
                //               children: _getopenfailure.map((user) {
                //                 return TableRow(children: [
                //                   Container(
                //                       padding: const EdgeInsets.all(5),
                //                       child: Text(user['id'].toString())),
                //                   Container(
                //                       padding: const EdgeInsets.all(5),
                //                       child: Text(user['title'].toString())),
                //                   Container(
                //                       padding: const EdgeInsets.all(5),
                //                       child: Text(user['failure_date'].toString())),
                //                   Container(
                //                       padding: const EdgeInsets.all(5),
                //                       child:
                //                           Text(user['departmentname'].toString())),
                //                   Container(
                //                       padding: const EdgeInsets.all(5),
                //                       child: (user['status'] == 1)
                //                           ? Text('Open')
                //                           : Text('Closed')),
                //                 ]);
                //               }).toList(),
                //               border:
                //                   TableBorder.all(width: 1, color: Colors.white),
                //             ),
                //           ),
                //         ])),
                //   ]),
                // )),
                // SingleChildScrollView(
                //     child: Container(
                //   padding: const EdgeInsets.all(10),
                //   margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                //   width: double.infinity,
                //   height: _getfailure.length * 50.0,
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(15),
                //       color: Colors.blue[100]),
                //   child: Column(children: <Widget>[
                //     Align(
                //       child: Text('All Failure Thread:',
                //           style: TextStyle(fontSize: 20, color: Colors.blue[700])),
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
                //               4: const FlexColumnWidth(2),
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
                //                         child: Text("Title",
                //                             textScaleFactor: 1,
                //                             style: TextStyle(
                //                                 fontWeight: FontWeight.bold,
                //                                 color: Colors.white,
                //                                 backgroundColor:
                //                                     Colors.blue[400]))),
                //                     Container(
                //                         padding: const EdgeInsets.all(4),
                //                         child: Text("WO Date",
                //                             textScaleFactor: 1,
                //                             style: TextStyle(
                //                                 fontWeight: FontWeight.bold,
                //                                 color: Colors.white,
                //                                 backgroundColor:
                //                                     Colors.blue[400]))),
                //                     Container(
                //                         padding: const EdgeInsets.all(4),
                //                         child: Text("Last Post",
                //                             textScaleFactor: 1,
                //                             style: TextStyle(
                //                                 fontWeight: FontWeight.bold,
                //                                 color: Colors.white,
                //                                 backgroundColor:
                //                                     Colors.blue[400]))),
                //                     Container(
                //                         padding: const EdgeInsets.all(4),
                //                         child: Text("Status",
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
                //                 4: const FlexColumnWidth(2),
                //               },
                //               children: _getfailure.map((auser) {
                //                 return TableRow(children: [
                //                   Container(
                //                       padding: const EdgeInsets.all(5),
                //                       child: Text(auser['id'].toString())),
                //                   Container(
                //                       padding: const EdgeInsets.all(5),
                //                       child: Text(auser['title'].toString())),
                //                   Container(
                //                       padding: const EdgeInsets.all(5),
                //                       child:
                //                           Text(auser['failure_date'].toString())),
                //                   Container(
                //                       padding: const EdgeInsets.all(5),
                //                       child:
                //                           Text(auser['departmentname'].toString())),
                //                   Container(
                //                       padding: const EdgeInsets.all(5),
                //                       child: (auser['status'] == 1)
                //                           ? Text('Open')
                //                           : Text('Closed'))
                //                 ]);
                //               }).toList(),
                //               border:
                //                   TableBorder.all(width: 1, color: Colors.white),
                //             ),
                //           ),
                //         ])),
              ]),
            )),
          ],
        ),
      ),
      drawer: NavDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => failureAdd()))
        },
        mini: true,
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color: Colors.blue[700],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}

Future<void> _failureDel(String a) async {
  print('token: ' + _tokenJwt[0]);
  var resp = await http.post(
      Uri.parse(
          "http://147.139.134.143/mrtjakarta/public/api/failureopen/status/2/" +
              a),
      headers: {
        'cookie': _cookies,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + _tokenJwt
      });

  print(jsonDecode(resp.body));
} // i

Future<void> _failureDisable(String a) async {
  print('token: ' + _tokenJwt[0]);
  var resp = await http.post(
      Uri.parse(
          "http://147.139.134.143/mrtjakarta/public/api/failureopen/status/0/" +
              a),
      headers: {
        'cookie': _cookies,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + _tokenJwt
      });

  print(jsonDecode(resp.body));
} // i

Future<void> _failureEnable(String a) async {
  print('token: ' + _tokenJwt[0]);
  var resp = await http.post(
      Uri.parse(
          "http://147.139.134.143/mrtjakarta/public/api/failureopen/status/1/" +
              a),
      headers: {
        'cookie': _cookies,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + _tokenJwt
      });

  print(jsonDecode(resp.body));
} // i

Widget _buildPopupDialog(BuildContext context, String a) {
  return new AlertDialog(
    // title: const Text(
    //   'Popup example',
    //   textAlign: TextAlign.center,
    // ),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ButtonTheme(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FlatButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => failureAdd()));
                    },
                    icon: Icon(
                      Icons.add_circle,
                      color: HexColor('#007BFF'),
                    ),
                    label: Text(
                      'NEW',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    // color: Colors.indigoAccent,
                    color: HexColor('#343A40'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FlatButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.remove_circle,
                      color: HexColor('#FFC107'),
                    ),
                    label: Text(
                      'EDIT',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    color: HexColor('#343A40'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FlatButton.icon(
                    onPressed: () {
                      _failureDisable(a);
                      print(a);
                    },
                    icon: Icon(
                      Icons.highlight_off,
                      color: HexColor('#DC3545'),
                    ),
                    label: Text(
                      'NOT ACTIVE',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    color: HexColor('#343A40'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FlatButton.icon(
                    onPressed: () {
                      _failureEnable(a);
                      print(a);
                    },
                    icon: Icon(
                      Icons.check_circle,
                      color: HexColor('#28A745'),
                    ),
                    label: Text(
                      'ACTIVE',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    color: HexColor('#343A40'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FlatButton.icon(
                    onPressed: () {
                      _failureDel(a);
                      print(a);
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => failure()));
                    },
                    icon: Icon(Icons.delete, color: Colors.white),
                    label: Text(
                      'DELETE',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    color: HexColor('#343A40'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FlatButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => failure()));
                    },
                    icon: Icon(
                      Icons.autorenew_sharp,
                      color: HexColor('#17A2B8'),
                    ),
                    label: Text(
                      'RELOAD',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    color: HexColor('#343A40'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
