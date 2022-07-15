import 'package:flutter/material.dart';
import 'package:mrt/NavDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:mrt/failureAdd.dart';
import 'package:mrt/failureexecuteact.dart';
import 'package:mrt/utils/secure_storage.dart';
import 'dart:convert';
import 'package:snippet_coder_utils/hex_color.dart';
import 'globals.dart' as globals;
import 'package:mrt/utils/excellistfailure.dart';

class failureexecute extends StatefulWidget {
  static const String routeName = '/failureexecute';

  @override
  State<failureexecute> createState() => _failureexecuteState();
}

String _tokenJwt = '';
String _cookies = '';
String _role = '';

class _failureexecuteState extends State<failureexecute> {
  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _foundUsers = [];
  List<dynamic> _getopenfailure = [];
  List<dynamic> _getfailure = [];
  List<dynamic> _getprogressfailure = [];
  List<dynamic> _getclosefailure = [];
  int indexworkorder = 0;
  int indexlocation = 0;
  int indexarea = 0;
  int indexreportdepartment = 0;
  int indexreceivedepartment = 0;
  int indexsystem = 0;
  int indexsystem_sub = 0;
  int indexequipment = 0;
  int indexequipment_id = 0;
  int indextrainset = 0;

  List<dynamic> _getdepartment = [];
  List<String> departmentname = [];
  List<String> departmentid = [];
  List<dynamic> _gettrainset = [];
  List<String> trainsetname = [];
  List<String> trainsetid = [];
  List<dynamic> _getlocation = [];
  List<String> locationname = [];
  List<String> locationid = [];
  List<dynamic> _getarea = [];
  List<String> areaname = [];
  List<String> areaid = [];
  List<dynamic> _getsystem = [];
  List<String> systemname = [];
  List<String> systemid = [];
  List<dynamic> _getsubsystem1 = [];
  List<String> subsystemname1 = [];
  List<String> subsystemid1 = [];
  List<dynamic> _getequipment = [];
  List<String> equipmentname = [];
  List<String> equipmentid = [];
  List<dynamic> _getequipmentid = [];
  List<String> equipmentidname = [];
  List<String> equipmentidid = [];

  // const Login({Key? key}) : super(key: key);

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    String _token = await SecureStorage.getToken();
    String _cookie = await SecureStorage.getCookie();
    String _rolelocal = await SecureStorage.getRole();
    setState(() {
      _tokenJwt = _token;
      _cookies = _cookie;
      _role = _rolelocal;
      _failure();
      // _progressfailure();
      // _closefailure();
    });
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
      _allUsers = [
        for (var i = 0; i < _getfailure.length; i++)
          {
            'id': _getfailure[i]['id'].toString(),
            'workorder_no': _getfailure[i]['workorder_no'].toString(),
            'title': _getfailure[i]['title'].toString(),
            'location': _getfailure[i]['location'].toString(),
            'area': _getfailure[i]['area'].toString(),
            'delay': _getfailure[i]['delay'].toString(),
            'reported_department':
                _getfailure[i]['reported_department'].toString(),
            'received_department':
                _getfailure[i]['received_department'].toString(),
            'report_date': _getfailure[i]['report_date'].toString(),
            'failure_date': _getfailure[i]['failure_date'].toString(),
            'failure_time': _getfailure[i]['failure_time'].toString(),
            'system': _getfailure[i]['system'].toString(),
            'system_sub': _getfailure[i]['system_sub'].toString(),
            'equipment': _getfailure[i]['equipment'].toString(),
            'equipment_id': _getfailure[i]['equipment_id'].toString(),
            'trainset': _getfailure[i]['trainset'].toString(),
            'failure_description':
                _getfailure[i]['failure_description'].toString(),
            'report_action': _getfailure[i]['report_action'].toString(),
            'attach_file': _getfailure[i]['attach_file'].toString(),
            'result_description':
                _getfailure[i]['result_description'].toString(),
            'note': _getfailure[i]['note'].toString(),
            'status': _getfailure[i]['status'],
            'status_proses': _getfailure[i]['status_proses'],
            'status_approve': _getfailure[i]['status_approve'],
            'create_at': _getfailure[i]['create_at'],
            'update_at': _getfailure[i]['update_at'],
            'approved_at': _getfailure[i]['approved_at'],
            'create_user': _getfailure[i]['create_user'],
            'update_user': _getfailure[i]['update_user'],
            'approved_user': _getfailure[i]['approved_user'],
            'departmentname': _getfailure[i]['departmentname'].toString(),
            'systemname': _getfailure[i]['systemname'].toString(),
            'system_subname': _getfailure[i]['system_subname'].toString(),
            'equipmentname': _getfailure[i]['equipmentname'].toString(),
            'equipment_idname': _getfailure[i]['equipment_idname'].toString(),
            'start_time': _getfailure[i]['updated_at'].toString(),
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

  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  bool order = true;
  bool sortUpdate = false;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: NavDrawer(),
      appBar: AppBar(
        leading: _isSearching ? const BackButton() : null,
        title: _isSearching ? _buildSearchField() : Text('Failure Execute'),
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
                          itemCount: _getfailure.length,
                          itemBuilder: (context, index) {
                            final sorted = _foundUsers
                              ..sort(
                                (a, b) => sortUpdate
                                    ? a["start_time"].compareTo(b["start_time"])
                                    : b["start_time"]
                                        .compareTo(a["start_time"]),
                              );
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                  print(selectedIndex);
                                });
                                globals.failureexecuteidtemp =
                                    _foundUsers[index]['id'].toString();
                                // indexnum = _userGetdata[index]['id'].toString();
                                // print(_foundUsers[index]['id'].toString());
                                print(globals.failureexecuteidtemp);
                                globals.areatemp =
                                    _foundUsers[index]['area'].toString();
                                globals.workorder_notemp = _foundUsers[index]
                                        ['workorder_no']
                                    .toString();
                                globals.locationtemp =
                                    _foundUsers[index]['location'].toString();
                                globals.reportdepartmenttemp =
                                    _foundUsers[index]['reported_department']
                                        .toString();
                                globals.titletemp = _foundUsers[index]['title'];
                                globals.delaytemp = _foundUsers[index]['delay'];
                                globals.report_datetemp =
                                    _foundUsers[index]['report_date'];
                                globals.failure_datetemp =
                                    _foundUsers[index]['failure_date'];
                                globals.failure_timetemp =
                                    _foundUsers[index]['failure_time'];
                                globals.failure_descriptiontemp =
                                    _foundUsers[index]['failure_description'];
                                globals.report_actiontemp =
                                    _foundUsers[index]['report_action'];
                                globals.receivedepartmenttemp =
                                    _foundUsers[index]['received_department']
                                        .toString();
                                globals.systemtemp =
                                    _foundUsers[index]['system'].toString();
                                globals.system_subtemp =
                                    _foundUsers[index]['system_sub'].toString();
                                globals.equipmenttemp =
                                    _foundUsers[index]['equipment'].toString();
                                globals.equipment_idtemp = _foundUsers[index]
                                        ['equipment_id']
                                    .toString();
                                globals.trainsettemp =
                                    _foundUsers[index]['trainset'].toString();
                                print('role : ' + _role);
                                if (_role == '1') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialog(
                                            context,
                                            _foundUsers[index]['id']
                                                .toString()),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialog2(
                                            context,
                                            _foundUsers[index]['id']
                                                .toString()),
                                  );
                                }
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
                                          Text('System',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text(' : ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                            _foundUsers[index]['systemname'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          Text('Sub System',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text(' : ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                            _foundUsers[index]['system_subname']
                                                .toString(),
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
                                    ) /*Row(
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
                                              'System ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Sub System ',
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
                                                        ['workorder_no']
                                                    .toString(),
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
                                                    ['systemname'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            ' : ' +
                                                _foundUsers[index]
                                                    ['system_subname'],
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
                                          Visibility(
                                            child: Text(
                                              ' : ${_foundUsers[index]['start_time'].toString()}',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => createExcel(_getfailure),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.print),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}

Future<void> _aproval(context) async {
  String _token = await SecureStorage.getToken();
  String _cookie = await SecureStorage.getCookie();

  var resp = await http.post(
      Uri.parse(
          "http://147.139.134.143/mrtjakarta/public/api/failureprogress/status/5/" +
              globals.failureexecuteidtemp.toString()),
      headers: {
        'Cookie': _cookie,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + _token
      });
  print(resp.body);
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => failureexecute()));
}

Future<void> _aproved(context) async {
  String _token = await SecureStorage.getToken();
  String _cookie = await SecureStorage.getCookie();

  var resp = await http.post(
      Uri.parse(
          "http://147.139.134.143/mrtjakarta/public/api/failureprogress/status/6/" +
              globals.failureexecuteidtemp.toString()),
      headers: {
        'Cookie': _cookie,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + _token
      });
  print(resp.body);
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => failureexecute()));
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

  // print(jsonDecode(resp.body));
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

  // print(jsonDecode(resp.body));
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

  // print(jsonDecode(resp.body));
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
                          builder: (BuildContext context) =>
                              failureexecuteact()));
                    },
                    icon: Icon(
                      Icons.add_circle,
                      color: HexColor('#007BFF'),
                    ),
                    label: Text(
                      'Execute',
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
                    onPressed: () {
                      _aproval(context);
                    },
                    icon: Icon(
                      Icons.gpp_maybe,
                      color: HexColor('#FFC107'),
                    ),
                    label: Text(
                      'Need-Aproval',
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
                      _aproved(context);
                    },
                    icon: Icon(
                      Icons.gpp_good,
                      color: HexColor('#FFC107'),
                    ),
                    label: Text(
                      'Aproved',
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => failureexecute()));
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

Widget _buildPopupDialog2(BuildContext context, String a) {
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
                          builder: (BuildContext context) =>
                              failureexecuteact()));
                    },
                    icon: Icon(
                      Icons.add_circle,
                      color: HexColor('#007BFF'),
                    ),
                    label: Text(
                      'Execute',
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
                    onPressed: () {
                      _aproval(context);
                    },
                    icon: Icon(
                      Icons.gpp_maybe,
                      color: HexColor('#FFC107'),
                    ),
                    label: Text(
                      'Need-Aproval',
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => failureexecute()));
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
