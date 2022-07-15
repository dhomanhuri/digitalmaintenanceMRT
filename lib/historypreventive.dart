import 'package:flutter/material.dart';
import 'package:mrt/NavDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:mrt/failureAdd.dart';
import 'package:mrt/utils/secure_storage.dart';
import 'dart:convert';
import 'package:mrt/utils/excelhistorypreventiv.dart';

class historypreventive extends StatefulWidget {
  static const String routeName = '/historypreventive';

  @override
  State<historypreventive> createState() => _preventivehistoryState();
}

class _preventivehistoryState extends State<historypreventive> {
  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  // final String url = 'https://karyaku.id/mrtjakarta/public/api';
  String _tokenJwt = '';
  String _cookies = '';
  List<dynamic> _getfailure = [];
  List<dynamic> _getsubsystem = [];
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
      // _openfailure();
      _failure();
      _subsystem();
      // _progressfailure();
      // _closefailure();
    });
  }

  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _foundUsers = [];
  Future<void> _failure() async {
    print('token: ' + _tokenJwt[0]);
    var resp =
        await http.get(Uri.parse(url + "/historypreventive/get"), headers: {
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
            'departmentname': _getfailure[i]['departmentname'].toString(),
            'systemname': _getfailure[i]['systemname'].toString(),
            'system_subname': _getfailure[i]['system_subname'].toString(),
            'equipmentname': _getfailure[i]['equipmentname'].toString(),
            'period': _getfailure[i]['period'].toString(),
            'equipment_idname': _getfailure[i]['equipment_idname'].toString(),
            'status': _getfailure[i]['status'],
            'status_proses': _getfailure[i]['status_proses'],
            'start_time': _getfailure[i]['updated_at'].toString(),
          }
      ];
      _foundUsers = _allUsers;
    });
    // print(jsonDecode(resp.body));
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

  Future<void> _subsystem() async {
    print('token: ' + _tokenJwt[0]);
    var resp = await http.get(Uri.parse(url + "/systemsub/get"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    print(jsonDecode(resp.body));
    setState(() {
      _getsubsystem = [...jsonDecode(resp.body)]; //ini data fauilure
    });
  }

  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  bool order = true;
  bool sortUpdate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: _isSearching ? const BackButton() : null,
        title: _isSearching ? _buildSearchField() : Text('History Preventive'),
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
                        // RaisedButton.icon(
                        //   onPressed: () {
                        //     setState(() {
                        //       order = !order;
                        //     });
                        //   },
                        //   icon: Icon(Icons.format_line_spacing),
                        //   label: Text(''),
                        // ),
                        ListView.builder(
                          reverse: order,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _foundUsers.length,
                          itemBuilder: (context, index) {
                            final sortedDate = _foundUsers
                              ..sort(
                                (a, b) => sortUpdate
                                    ? a["start_time"].compareTo(b["start_time"])
                                    : b["start_time"]
                                        .compareTo(a["start_time"]),
                              );
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
                                        TableRow(children: [
                                          Text('Period',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text(' : ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                            _foundUsers[index]['period'],
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
                                              'Period ',
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
                                              ' : ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              ' : ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            if (_foundUsers[index]
                                                        ['system_subname']
                                                    .length >
                                                30) ...[
                                              Text(
                                                ' : ',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                '  ',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ] else ...[
                                              Text(
                                                ' : ',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                            Text(
                                              ' : ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              ' : ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              ' : ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              ' : ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              ' : ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ]),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              _foundUsers[index]['workorder_no']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              _foundUsers[index]
                                                      ['departmentname']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              _foundUsers[index]['systemname']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              _foundUsers[index]
                                                      ['system_subname']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              _foundUsers[index]
                                                      ['equipmentname']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              _foundUsers[index]
                                                      ['equipment_idname']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              _foundUsers[index]['period']
                                                  .toString(),
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
                                            Visibility(
                                                child: Text(
                                                  ' : ' +
                                                      _foundUsers[index]
                                                              ['start_time']
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                visible: false),
                                          ],
                                        ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => createExcel(_getfailure),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.print),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
