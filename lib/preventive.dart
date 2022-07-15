import 'package:flutter/material.dart';
import 'package:mrt/NavDrawer.dart';
import 'package:mrt/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mrt/inputwo.dart';
import 'dart:convert';
import 'dart:async';
import 'package:mrt/executewo.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'globals.dart' as globals;
import 'package:mrt/utils/excelinputwo.dart';

class preventive extends StatefulWidget {
  static const String routeName = '/preventive';

  @override
  State<preventive> createState() => _preventiveState();
}

class _preventiveState extends State<preventive> {
  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  String _tokenJwt = '';
  String _cookies = '';
  String _role = '';
  List<dynamic> _getpreventive = [];
  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _foundUsers = [];
  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    String _token = await SecureStorage.getToken();
    String _cookie = await SecureStorage.getCookie();
    String _rolelocal = await SecureStorage.getRole();
    setState(() {
      _tokenJwt = _token;
      _cookies = _cookie;
      _role = _rolelocal;
    });
    _Preventive();
  }

  Future<void> _Preventive() async {
    print('token: ' + _tokenJwt);
    var resp = await http.get(Uri.parse(url + "/preventiveopen/get"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    setState(() {
      _getpreventive = jsonDecode(resp.body);
      _allUsers = [
        for (var i = 0; i < _getpreventive.length; i++)
          {
            'id': _getpreventive[i]['id'].toString(),
            'workorder_no': _getpreventive[i]['workorder_no'].toString(),
            'departmentname': _getpreventive[i]['departmentname'].toString(),
            'equipment_idname':
                _getpreventive[i]['equipment_idname'].toString(),
            'section_headname':
                _getpreventive[i]['section_headname'].toString(),
            'technician': _getpreventive[i]['technician'].toString(),
            'start_time': _getpreventive[i]['start_time'].toString(),
            'end_time': _getpreventive[i]['end_time'].toString(),
            'status': _getpreventive[i]['status'],
            'status_proses': _getpreventive[i]['status_proses'],
          }
      ];
      _foundUsers = _allUsers;
    });
    print(jsonDecode(resp.body));
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
  bool isTime = false;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _isSearching ? const BackButton() : null,
        title: _isSearching ? _buildSearchField() : Text('Execute WO'),
        actions: _buildActions(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createExcel(_getpreventive),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.print),
      ),
      drawer: NavDrawer(),
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
                      setState(() => isTime = !isTime);
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
                          Text(isTime
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
                          //         setState(() => isTime = !isTime);
                          //       },
                          //       icon: Icon(Icons.format_line_spacing),
                          //       label: Text(
                          //         isTime
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
                                final sortedTime = _foundUsers
                                  ..sort(
                                    (a, b) => isTime
                                        ? a["start_time"]
                                            .compareTo(b["start_time"])
                                        : b["start_time"]
                                            .compareTo(a["start_time"]),
                                  );
                                return GestureDetector(
                                  onTap: () {
                                    // indexnum = _userGetdata[index]['id'].toString();
                                    setState(() {
                                      selectedIndex = index;
                                      print(selectedIndex);
                                    });
                                    globals.woexecuteidtemp =
                                        _foundUsers[index]['id'].toString();
                                    print(globals.woexecuteidtemp);
                                    // print('indexnum' + globals.woexecuteidtemp);
                                    if (_role == '1') {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildPopupDialog(context),
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildPopupDialog2(context),
                                      );
                                    }

                                    // _userDel(indexnum);
                                  },
                                  child: Card(
                                      color: selectedIndex == index
                                          ? Colors.blue[100]
                                          : Colors.white,
                                      elevation: 8,
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child:
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
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'Department  ',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'Section Head ',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'Technician  ',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'Start Time  ',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'End Time ',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'Status ',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ]),
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      ' : ' +
                                                          _foundUsers[index][
                                                                  'workorder_no']
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ' : ' +
                                                          _foundUsers[index][
                                                                  'departmentname']
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ' : ' +
                                                          _foundUsers[index][
                                                                  'section_headname']
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ' : ' +
                                                          _foundUsers[index]
                                                                  ['technician']
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ' : ${_foundUsers[index]['start_time'].toString()}',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ' : ' +
                                                          _foundUsers[index]
                                                                  ['end_time']
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    if (_foundUsers[index]
                                                            ['status'] ==
                                                        1) ...[
                                                      if (_foundUsers[index][
                                                              'status_proses'] ==
                                                          0) ...[
                                                        Text(
                                                          ' : Open',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ] else if (_getpreventive[
                                                                  index][
                                                              'status_proses'] ==
                                                          1) ...[
                                                        Text(
                                                          ' : In Progress',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ] else if (_getpreventive[
                                                                  index][
                                                              'status_proses'] ==
                                                          2) ...[
                                                        Text(
                                                          ' : Need-Approval',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ] else if (_getpreventive[
                                                                  index][
                                                              'status_proses'] ==
                                                          3) ...[
                                                        Text(
                                                          ' : Close',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ] else if (_getpreventive[
                                                                  index][
                                                              'status_proses'] ==
                                                          4) ...[
                                                        Text(
                                                          ' : Need-Revision',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ]
                                                    ] else ...[
                                                      Text(
                                                        ' : Not Active',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ]),
                                            ],
                                          )*/
                                            Table(
                                          columnWidths: {
                                            0: FlexColumnWidth(
                                                0.5), // this column has a fixed width of 50
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
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(' : ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                _foundUsers[index]
                                                    ['workorder_no'],
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ]),
                                            TableRow(children: [
                                              Text('Department',
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
                                                    ['departmentname'],
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ]),
                                            TableRow(children: [
                                              Text('Section Head',
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
                                                    ['section_headname'],
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ]),
                                            TableRow(children: [
                                              Text('Technician',
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
                                                _foundUsers[index]['technician']
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ]),
                                            TableRow(children: [
                                              Text('Start Time',
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
                                                    ['start_time'],
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ]),
                                            TableRow(
                                              children: [
                                                Text('End Time',
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
                                                      ['end_time'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                                if (_foundUsers[index]
                                                        ['status'] ==
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
                                        ),
                                      )),
                                );
                              })
                        ])
                  : const Text(
                      'No results found',
                      style: TextStyle(fontSize: 24),
                    ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}

Future<void> _aproved() async {
  String _token = await SecureStorage.getToken();
  String _cookie = await SecureStorage.getCookie();

  var resp = await http.post(
      Uri.parse(
          "http://147.139.134.143/mrtjakarta/public/api/preventiveprogress/delete/4/" +
              globals.woexecuteidtemp.toString()),
      headers: {
        'Cookie': _cookie,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + _token
      });
  print(resp.body);
}

Future<void> _aproval() async {
  String _token = await SecureStorage.getToken();
  String _cookie = await SecureStorage.getCookie();

  var resp = await http.post(
      Uri.parse(
          "http://147.139.134.143/mrtjakarta/public/api/preventiveprogress/delete/5/" +
              globals.woexecuteidtemp.toString()),
      headers: {
        'Cookie': _cookie,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + _token
      });
  print(resp.body);
}

Widget _buildPopupDialog(BuildContext context) {
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
                          builder: (BuildContext context) => executewo()));
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
                      _aproval();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => preventive()));
                    },
                    icon: Icon(
                      Icons.abc_rounded,
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
                      _aproved();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => preventive()));
                    },
                    icon: Icon(
                      Icons.check_circle,
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
                          builder: (context) => preventive()));
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

Widget _buildPopupDialog2(BuildContext context) {
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
                          builder: (BuildContext context) => executewo()));
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
                      _aproval();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => preventive()));
                    },
                    icon: Icon(
                      Icons.abc_rounded,
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
                          builder: (context) => preventive()));
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
