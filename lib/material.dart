import 'package:flutter/material.dart';
import 'package:mrt/NavDrawer.dart';
import 'package:mrt/materialedit.dart';
import 'package:mrt/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:mrt/api/pdf_api.dart';
import 'package:mrt/widget/button_widget.dart';
import 'globals.dart' as globals;
import 'package:mrt/utils/excelclosewo.dart';
import 'package:mrt/api/pdf_api.dart';
import 'package:mrt/widget/button_widget.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:mrt/materialadd.dart';

class material extends StatefulWidget {
  static const String routeName = '/closewo';

  @override
  State<material> createState() => _materialState();
}

final String url = 'http://147.139.134.143/mrtjakarta/public/api';
String _tokenJwt = '';
String _cookies = '';

class _materialState extends State<material> {
  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  String _tokenJwt = '';
  String _cookies = '';
  List<dynamic> _getpreventive = [];

  List<dynamic> _getchecksheettabel = [];
  List<String> checksheetnametabel = [];
  List<String> checksheetidtabel = [];
  List<dynamic> _gettoolstabel = [];
  List<String> toolsnametabel = [];
  List<String> toolsidtabel = [];
  List<dynamic> _getmaterialtabel = [];
  List<String> materialnametabel = [];
  List<String> materialidtabel = [];
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
    _Preventive();
  }

  Future<void> _export(
      int indexnum,
      List<dynamic> _getselected,
      List<dynamic> _getmaterial,
      List<dynamic> _gettools,
      List<dynamic> _getchecksheet) async {
    final pdfFile = await PdfApi.generateImage(
        indexnum, _getselected, _getmaterial, _gettools, _getchecksheet);

    PdfApi.openFile(pdfFile);
  }

  Future<void> _unitDel() async {
    print('token: ' + _tokenJwt[0]);
    var resp = await http.post(
        Uri.parse(
            "http://147.139.134.143/mrtjakarta/public/api/material/status/2/" +
                globals.materialidtemp.toString()),
        headers: {
          'cookie': _cookies,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _tokenJwt
        });

    print(jsonDecode(resp.body));

    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => material()));
  } // i

  Future<void> _unitDisable() async {
    print('toasdsadken: ' + _tokenJwt[0]);
    var headers = {'Authorization': 'Bearer ' + _tokenJwt, 'Cookie': _cookies};
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/material/status/0/' +
                globals.materialidtemp.toString()));
    request.bodyFields = {};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }

    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => material()));
  } // i

  Future<void> _unitEnable() async {
    print('tokenasdsad: ' + _tokenJwt[0]);
    var resp = await http.post(
        Uri.parse(
            "http://147.139.134.143/mrtjakarta/public/api/material/status/1/" +
                globals.materialidtemp.toString()),
        headers: {
          'cookie': _cookies,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _tokenJwt
        });

    print(jsonDecode(resp.body));

    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => material()));
  } // i

  Future<void> _Preventive() async {
    print('token: ' + _tokenJwt);
    var resp = await http.get(Uri.parse(url + "/material/get"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    setState(() {
      _getpreventive = jsonDecode(resp.body);
      globals.closewopdf = _getpreventive;
    });
    print(jsonDecode(resp.body));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => materialAdd()))
          },
          mini: true,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add,
            color: Colors.blue[700],
          ),
        ),
        appBar: AppBar(
          title: Text("Material"),
        ),
        drawer: NavDrawer(),
        body: new SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                width: double.infinity,
                height: _getpreventive.length * 100.0 + 10,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue[300]),
                child: Column(children: <Widget>[
                  // Align(
                  //   child: Text('Workorders:',
                  //       style: TextStyle(fontSize: 30, color: Colors.black)),
                  //   alignment: Alignment.topLeft,
                  // ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _getpreventive.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            globals.materialidtemp =
                                _getpreventive[index]['id'].toString();
                            globals.materialnametemp =
                                _getpreventive[index]['name'].toString();
                            globals.materialqtytemp =
                                _getpreventive[index]['quantity'].toString();
                            print('tap ' + globals.materialidtemp);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  new AlertDialog(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        ButtonTheme(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              // FlatButton.icon(
                                              //   onPressed: () {
                                              //     Navigator.of(context).pop();
                                              //     Navigator.of(context).push(MaterialPageRoute(
                                              //         builder: (BuildContext context) => failureAdd()));
                                              //   },
                                              //   icon: Icon(
                                              //     Icons.add_circle,
                                              //     color: HexColor('#007BFF'),
                                              //   ),
                                              //   label: Text(
                                              //     'NEW',
                                              //     style: TextStyle(
                                              //         fontWeight:
                                              //             FontWeight.bold,
                                              //         color: Colors.white),
                                              //   ),
                                              //   // color: Colors.indigoAccent,
                                              //   color: HexColor('#343A40'),
                                              //   shape: RoundedRectangleBorder(
                                              //     borderRadius:
                                              //         BorderRadius.circular(10),
                                              //   ),
                                              // ),
                                              FlatButton.icon(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              materialEdit()));
                                                },
                                                icon: Icon(
                                                  Icons.remove_circle,
                                                  color: HexColor('#FFC107'),
                                                ),
                                                label: Text(
                                                  'EDIT',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                color: HexColor('#343A40'),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              FlatButton.icon(
                                                onPressed: () {
                                                  _unitDisable();
                                                },
                                                icon: Icon(
                                                  Icons.highlight_off,
                                                  color: HexColor('#DC3545'),
                                                ),
                                                label: Text(
                                                  'NOT ACTIVE',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                color: HexColor('#343A40'),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              FlatButton.icon(
                                                onPressed: () {
                                                  _unitEnable();
                                                },
                                                icon: Icon(
                                                  Icons.check_circle,
                                                  color: HexColor('#28A745'),
                                                ),
                                                label: Text(
                                                  'ACTIVE',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                color: HexColor('#343A40'),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              FlatButton.icon(
                                                onPressed: () {
                                                  _unitDel();
                                                  // Navigator.of(context).push(
                                                  //     MaterialPageRoute(builder: (context) => failure()));
                                                },
                                                icon: Icon(Icons.delete,
                                                    color: Colors.white),
                                                label: Text(
                                                  'DELETE',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                color: HexColor('#343A40'),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              FlatButton.icon(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              material()));
                                                },
                                                icon: Icon(
                                                  Icons.autorenew_sharp,
                                                  color: HexColor('#17A2B8'),
                                                ),
                                                label: Text(
                                                  'RELOAD',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                color: HexColor('#343A40'),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Card(
                              elevation: 8,
                              child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Table(
                                    columnWidths: {
                                      0: FixedColumnWidth(
                                          60), // this column has a fixed width of 50
                                      1: FlexColumnWidth(
                                          0.1), // take 1/3 of the remaining space
                                      2: FlexColumnWidth(
                                          1), // // take 2/3 of the remaining space
                                    },
                                    children: [
                                      TableRow(children: [
                                        Text('Name',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Text(' :',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                          _getpreventive[index]['name'],
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Text('Quantity',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Text(' : ',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                          _getpreventive[index]['quantity']
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ]),
                                      TableRow(
                                        children: [
                                          Text('Status',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text(' : ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          if (_getpreventive[index]['status']
                                                  .toString() ==
                                              '1') ...[
                                            Text(
                                              'Active',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green),
                                            ),
                                          ] else ...[
                                            Text(
                                              'Not Active',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green),
                                            ),
                                          ],
                                        ],
                                      )
                                    ],
                                  )
                                  /*Row(
                                    children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Name ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Quantity  ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Status  ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ]),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              ' : ' +
                                                  _getpreventive[index]['name']
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              ' : ' +
                                                  _getpreventive[index]
                                                          ['quantity']
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            if (_getpreventive[index]['status']
                                                    .toString() ==
                                                '1') ...[
                                              Text(
                                                ' : Active',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green),
                                              ),
                                            ] else ...[
                                              Text(
                                                ' : Not Active',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green),
                                              ),
                                            ]
                                          ]),
                                    ],
                                  )*/
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

// Widget _buildPopupDialog(BuildContext context) {
//   return new AlertDialog(
//     // title: const Text(
//     //   'Popup example',
//     //   textAlign: TextAlign.center,
//     // ),
//     content: new Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Column(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             ButtonTheme(
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   FlatButton.icon(
//                     onPressed: () {
//                       // Navigator.of(context).pop();
//                       // Navigator.of(context).push(MaterialPageRoute(
//                       //     builder: (BuildContext context) => failureAdd()));
//                     },
//                     icon: Icon(
//                       Icons.add_circle,
//                       color: HexColor('#007BFF'),
//                     ),
//                     label: Text(
//                       'NEW',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold, color: Colors.white),
//                     ),
//                     // color: Colors.indigoAccent,
//                     color: HexColor('#343A40'),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   FlatButton.icon(
//                     onPressed: () {},
//                     icon: Icon(
//                       Icons.remove_circle,
//                       color: HexColor('#FFC107'),
//                     ),
//                     label: Text(
//                       'EDIT',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold, color: Colors.white),
//                     ),
//                     color: HexColor('#343A40'),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   FlatButton.icon(
//                     onPressed: () {
//                       _unitDisable();
//                     },
//                     icon: Icon(
//                       Icons.highlight_off,
//                       color: HexColor('#DC3545'),
//                     ),
//                     label: Text(
//                       'NOT ACTIVE',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold, color: Colors.white),
//                     ),
//                     color: HexColor('#343A40'),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   FlatButton.icon(
//                     onPressed: () {
//                       _unitEnable();
//                     },
//                     icon: Icon(
//                       Icons.check_circle,
//                       color: HexColor('#28A745'),
//                     ),
//                     label: Text(
//                       'ACTIVE',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold, color: Colors.white),
//                     ),
//                     color: HexColor('#343A40'),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   FlatButton.icon(
//                     onPressed: () {
//                       _unitDel();
//                       // Navigator.of(context).push(
//                       //     MaterialPageRoute(builder: (context) => failure()));
//                     },
//                     icon: Icon(Icons.delete, color: Colors.white),
//                     label: Text(
//                       'DELETE',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold, color: Colors.white),
//                     ),
//                     color: HexColor('#343A40'),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   FlatButton.icon(
//                     onPressed: () {
//                       Navigator.of(context).push(
//                           MaterialPageRoute(builder: (context) => material()));
//                     },
//                     icon: Icon(
//                       Icons.autorenew_sharp,
//                       color: HexColor('#17A2B8'),
//                     ),
//                     label: Text(
//                       'RELOAD',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold, color: Colors.white),
//                     ),
//                     color: HexColor('#343A40'),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
