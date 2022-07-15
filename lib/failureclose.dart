import 'package:flutter/material.dart';
import 'package:mrt/NavDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:mrt/utils/secure_storage.dart';
import 'dart:convert';
import 'package:mrt/utils/excelclosefailure.dart';
import 'globals.dart' as globals;

import 'package:mrt/api/pdf_api.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'revisionfailure.dart';

class closefailure extends StatefulWidget {
  static const String routeName = '/failure';

  @override
  State<closefailure> createState() => _closefailureState();
}

class _closefailureState extends State<closefailure> {
  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  // final String url = 'https://karyaku.id/mrtjakarta/public/api';
  String _tokenJwt = '';
  String _cookies = '';
  List<dynamic> _getopenfailure = [];
  List<dynamic> _getfailure = [];
  List<dynamic> _getprogressfailure = [];
  List<dynamic> _getclosefailure = [];
  // const Login({Key? key}) : super(key: key);
  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _foundUsers = [];

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

      // _failure();
      // _progressfailure();
      // _closefailure();
    });
    _closefailure();
  }

  Future<void> _export(int indexnum, List<dynamic> _getselected) async {
    final pdfFile = await PdfApi.generateImage2(indexnum, _getselected);

    PdfApi.openFile(pdfFile);
  }

  Future<void> _closefailure() async {
    print('token: ' + _tokenJwt[0]);
    var resp = await http.get(Uri.parse(url + "/failureclose/get"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    // _getclosefailure = [...jsonDecode(resp.body)]; //ini data fauilure close
    setState(() {
      _getclosefailure = [...jsonDecode(resp.body)];
      print(_getclosefailure);
      _allUsers = [
        for (var i = 0; i < _getclosefailure.length; i++)
          {
            'id': _getclosefailure[i]['id'].toString(),
            'title': _getclosefailure[i]['title'].toString(),
            'location': _getclosefailure[i]['location'].toString(),
            'area': _getclosefailure[i]['area'].toString(),
            'delay': _getclosefailure[i]['delay'].toString(),
            'reported_department':
                _getclosefailure[i]['reported_department'].toString(),
            'received_department':
                _getclosefailure[i]['received_department'].toString(),
            'report_date': _getclosefailure[i]['report_date'].toString(),
            'failure_date': _getclosefailure[i]['failure_date'].toString(),
            'failure_time': _getclosefailure[i]['failure_time'].toString(),
            'systemname': _getclosefailure[i]['systemname'].toString(),
            'system_subname': _getclosefailure[i]['system_subname'].toString(),
            'trainset': _getclosefailure[i]['trainset'].toString(),
            'failure_description':
                _getclosefailure[i]['failure_description'].toString(),
            'report_action': _getclosefailure[i]['report_action'].toString(),
            'workorder_no': _getclosefailure[i]['workorder_no'].toString(),
            'departmentname': _getclosefailure[i]['departmentname'].toString(),
            'equipmentname': _getclosefailure[i]['equipmentname'].toString(),
            'note': _getclosefailure[i]['note'].toString(),
            'equipment_idname':
                _getclosefailure[i]['equipment_idname'].toString(),
            'status': _getclosefailure[i]['status'],
            'status_proses': _getclosefailure[i]['status_proses'],
            'start_time': _getclosefailure[i]['updated_at'].toString(),
          }
      ];
      _foundUsers = _allUsers;
    });
  }

// This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allUsers;
    } else {
      results = _allUsers
          .where((description) => description["workorder_no"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search Data...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      // onChanged: (query) => updateSearchQuery(query),
      onChanged: (value) => _runFilter(value),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
        ?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  Future<void> _closeact() async {
    var headers = {
      'Authorization': 'Bearer ' + _tokenJwt,
      'Cookie': _cookies,
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/failureclose/delete/6/' +
                globals.revisionidtemp.toString()));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => closefailure()));
  }

  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  bool order = true;
  bool sortUpdate = false;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => createExcel(_getclosefailure),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.print),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: _isSearching ? const BackButton() : null,
        title: _isSearching ? _buildSearchField() : Text('Failure Close'),
        actions: _buildActions(),
      ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 42,
                  width: MediaQuery.of(context).size.width / 2,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        order = !order;
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.1),
                      ),
                      margin: EdgeInsets.only(right: 0.9),
                      clipBehavior: Clip.antiAlias,
                      elevation: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.sort),
                          Text(order ? 'Z - A' : 'A - Z')
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 42,
                  width: MediaQuery.of(context).size.width / 2,
                  child: GestureDetector(
                    onTap: () {
                      setState(() => sortUpdate = !sortUpdate);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.1),
                      ),
                      clipBehavior: Clip.antiAlias,
                      margin: EdgeInsets.zero,
                      elevation: 2,
                      child: Row(
                        children: [
                          Icon(Icons.sort),
                          Text(sortUpdate
                              ? 'Sort By Date (New - Old)'
                              : 'Sort By Date (Old - New)')
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(
            //   height: 20,
            // ),
            Container(
              padding: const EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 5, left: 5, right: 5),
              width: double.infinity,
              // height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blue[300]),
              child: _foundUsers.isNotEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Row(
                        //   mainAxisSize: MainAxisSize.max,
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     RaisedButton.icon(
                        //       onPressed: () {
                        //         setState(() {
                        //           order = !order;
                        //         });
                        //       },
                        //       icon: Icon(Icons.format_line_spacing),
                        //       label: Text(''),
                        //     ),
                        //     RaisedButton.icon(
                        //       onPressed: () {
                        //         setState(() => sortUpdate = !sortUpdate);
                        //       },
                        //       icon: Icon(Icons.format_line_spacing),
                        //       label: Text(
                        //         sortUpdate
                        //             ? 'Sort by Time (New - Old)'
                        //             : 'Sort by Time (Old - New)',
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        ListView.builder(
                          reverse: order,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _foundUsers.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                  print(selectedIndex);
                                });
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                  FlatButton.icon(
                                                    onPressed: () {
                                                      _export(
                                                          index, _foundUsers);
                                                    },
                                                    icon: Icon(
                                                      Icons.print,
                                                      color:
                                                          HexColor('#FFC107'),
                                                    ),
                                                    label: Text(
                                                      'Export PDF',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                    color: HexColor('#343A40'),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  FlatButton.icon(
                                                    onPressed: () {
                                                      // Navigator.of(context).push(
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) =>
                                                      //             closewo()));
                                                      _closeact();
                                                    },
                                                    icon: Icon(
                                                      Icons.close_rounded,
                                                      color:
                                                          HexColor('#17A2B8'),
                                                    ),
                                                    label: Text(
                                                      'Close WO',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                    color: HexColor('#343A40'),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  FlatButton.icon(
                                                    onPressed: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  revisionfailure()));
                                                    },
                                                    icon: Icon(
                                                      Icons.pages,
                                                      color:
                                                          HexColor('#17A2B8'),
                                                    ),
                                                    label: Text(
                                                      'Need-Revision',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                    color: HexColor('#343A40'),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  FlatButton.icon(
                                                    onPressed: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  closefailure()));
                                                    },
                                                    icon: Icon(
                                                      Icons.autorenew_sharp,
                                                      color:
                                                          HexColor('#17A2B8'),
                                                    ),
                                                    label: Text(
                                                      'RELOAD',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                    color: HexColor('#343A40'),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
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
                                color: selectedIndex == index
                                    ? Colors.blue[100]
                                    : Colors.white,
                                elevation: 8,
                                child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Table(
                                      columnWidths: {
                                        0: FixedColumnWidth(
                                            100), // this column has a fixed width of 50
                                        1: FlexColumnWidth(
                                            0.1), // take 1/3 of the remaining space
                                        2: FlexColumnWidth(
                                            1), // // take 2/3 of the remaining space
                                      },
                                      children: [
                                        TableRow(children: [
                                          Text('Title',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text(' : ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                            _foundUsers[index]['title'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          Text('Workorder',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text(' : ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                            _foundUsers[index]['workorder_no'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          Text('Department',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text(' : ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                            _foundUsers[index]
                                                ['departmentname'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          Text('Equipment',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text(' : ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                            _foundUsers[index]['equipmentname'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ]),
                                        TableRow(
                                          children: [
                                            Text('Equipment ID',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(' : ',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                              _foundUsers[index]
                                                  ['equipment_idname'],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        TableRow(children: [
                                          Text('Note',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text(' : ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                            _foundUsers[index]['note'],
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
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(' : ',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            if (_foundUsers[index]['status'] ==
                                                1) ...[
                                              if (_foundUsers[index]
                                                      ['status_proses'] ==
                                                  0) ...[
                                                Text(
                                                  'Open',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ] else if (_foundUsers[index]
                                                      ['status_proses'] ==
                                                  1) ...[
                                                Text(
                                                  'In Progress',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ] else if (_foundUsers[index]
                                                      ['status_proses'] ==
                                                  2) ...[
                                                Text(
                                                  'Need-Approval',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ] else if (_foundUsers[index]
                                                      ['status_proses'] ==
                                                  3) ...[
                                                Text(
                                                  'Close',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ] else if (_foundUsers[index]
                                                      ['status_proses'] ==
                                                  4) ...[
                                                Text(
                                                  'Need-Revision',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ]
                                            ] else ...[
                                              Text(
                                                'Not Active',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                              'Title ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Workorder ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Department ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Equipment ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Equipment ID ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Note Revision',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Status ',
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
                                            ' : ' + _foundUsers[index]['title'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            ' : ' +
                                                _foundUsers[index]
                                                    ['workorder_no'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            ' : ' +
                                                _foundUsers[index]
                                                    ['departmentname'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            ' : ' +
                                                _foundUsers[index]
                                                    ['equipmentname'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            ' : ' +
                                                _foundUsers[index]
                                                    ['equipment_idname'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            ' : ' + _foundUsers[index]['note'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          if (_foundUsers[index]['status'] ==
                                              1) ...[
                                            if (_foundUsers[index]
                                                    ['status_proses'] ==
                                                0) ...[
                                              Text(
                                                ' : Open',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ] else if (_foundUsers[index]
                                                    ['status_proses'] ==
                                                1) ...[
                                              Text(
                                                ' : In Progress',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ] else if (_foundUsers[index]
                                                    ['status_proses'] ==
                                                2) ...[
                                              Text(
                                                ' : Need-Approval',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ] else if (_foundUsers[index]
                                                    ['status_proses'] ==
                                                3) ...[
                                              Text(
                                                ' : Close',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ] else if (_foundUsers[index]
                                                    ['status_proses'] ==
                                                4) ...[
                                              Text(
                                                ' : Need-Revision',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ]
                                          ] else ...[
                                            Text(
                                              ' : Not Active',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                          // Text(
                                          //   '${_foundUsers[index]['start_time'].toString()}',
                                          //   style: TextStyle(
                                          //       fontSize: 15,
                                          //       fontWeight: FontWeight.bold),
                                          // ),
                                          Visibility(
                                            child: Text(
                                              '${_foundUsers[index]['start_time'].toString()}',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            visible: false,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),*/
                                    ),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : const Text(
                      'No results found',
                      style: TextStyle(fontSize: 24),
                    ),
            ),
          ],
        ),
      ),
      drawer: NavDrawer(),
    );
  }
}
