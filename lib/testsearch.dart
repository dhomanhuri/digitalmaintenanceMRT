import 'package:flutter/material.dart';
import 'package:mrt/NavDrawer.dart';
import 'package:mrt/workorderAdd.dart';
import 'globals.dart' as globals;
import 'workorderEdit.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:mrt/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
// import '../models/user.dart';
// import 'package:mrt/utils/excelschedulewo.dart';

class testsearch extends StatefulWidget {
  static const String routeName = '/testsearch';

  @override
  State<testsearch> createState() => _testsearchState();
}

class _testsearchState extends State<testsearch> {
  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  String _tokenJwt = '';
  String _cookies = '';
  List<dynamic> _getpreventive = [];
  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _foundUsers = [];
  bool isDate = false;
  bool isLoading = true;

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
    // _Preventive();
  }

  Future<void> _Preventive() async {
    var resp = await http.get(Uri.parse(url + "/workorder/get"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    try {
      if (resp.statusCode == 200) {
        _getpreventive = jsonDecode(resp.body);
        // setState(() {
        _allUsers = [
          for (var i = 0; i < _getpreventive.length; i++)
            {
              'id': _getpreventive[i]['id'].toString(),
              'workorder_no': _getpreventive[i]['workorder_no'].toString(),
              'period': _getpreventive[i]['period'].toString(),
              'department': _getpreventive[i]['departmentname'].toString(),
              'departmentid': _getpreventive[i]['department'].toString(),
              'description': _getpreventive[i]['description'].toString(),
              'start_date': _getpreventive[i]['start_date'].toString(),
              'status': _getpreventive[i]['status'].toString(),
            }
        ];
        _foundUsers = _allUsers;
        isLoading = false;
        // });
      } else {
        throw (resp.statusCode);
      }
    } catch (e) {
      print(e);
    }

    // try {
    //   if (resp.statusCode == 200) {

    //   } else {
    //     print(resp.statusCode);
    //     throw (resp.statusCode);
    //   }
    // } catch (err) {
    //   throw (err);
    // }
  }

// This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allUsers;
    } else {
      results = _allUsers
          .where((description) => description["description"]
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

  final TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  bool order = true;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => WorkorderAdd()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        leading: _isSearching ? const BackButton() : null,
        title: _isSearching ? _buildSearchField() : const Text('Schedule WO'),
        actions: _buildActions(),
      ),
      body: FutureBuilder(
        future: _Preventive(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            return showData(context);
          }
        },
      ),
    );
  }

  SingleChildScrollView showData(BuildContext context) {
    return SingleChildScrollView(
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
                        const Icon(Icons.sort),
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
                    setState(() => isDate = !isDate);
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
                        Text(isDate
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
            margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
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
                      ListView.builder(
                        reverse: order,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _foundUsers.length,
                        itemBuilder: (context, index) {
                          final sortedDate = _foundUsers
                            ..sort(
                              (a, b) => isDate
                                  ? a["start_date"].compareTo(b["start_date"])
                                  : b["start_date"].compareTo(a["start_date"]),
                            );
                          return GestureDetector(
                            onTap: () {
                              // setState(() {
                              //   selectedIndex = index;
                              //   print(_foundUsers[index]['id'].toString());
                              // });
                              String a = _foundUsers[index]['id'].toString();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text(
                                    _foundUsers[index]['workorder_no'],
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Column(
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
                                                // FlatButton.icon(
                                                //   onPressed: () {
                                                //     // Navigator.of(context).pop();
                                                //     // Navigator.of(context).push(MaterialPageRoute(
                                                //     //     builder: (BuildContext context) => pmchecksheet()));
                                                //   },
                                                //   icon: Icon(
                                                //     Icons.add_circle,
                                                //     color: HexColor('#007BFF'),
                                                //   ),
                                                //   label: const Text(
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
                                                //         BorderRadius.circular(
                                                //             10),
                                                //   ),
                                                // ),
                                                FlatButton.icon(
                                                  onPressed: () {
                                                    globals.workorderdepartmentidtemp =
                                                        _foundUsers[index]
                                                            ['departmentid'];
                                                    globals.workorderdepartmenttemp =
                                                        _foundUsers[index]
                                                            ['department'];
                                                    globals.workorderidtemp = a;
                                                    globals.workordernotemp =
                                                        _foundUsers[index]
                                                                ['workorder_no']
                                                            .toString();
                                                    globals.workorderdescriptiontemp =
                                                        _foundUsers[index]
                                                                ['description']
                                                            .toString();
                                                    globals.workorderstartdatetemp =
                                                        _foundUsers[index]
                                                                ['start_date']
                                                            .toString();
                                                    globals.workorderperiodtemp =
                                                        _foundUsers[index]
                                                                ['period']
                                                            .toString();

                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                WorkorderEdit()));
                                                  },
                                                  icon: Icon(
                                                    Icons.remove_circle,
                                                    color: HexColor('#FFC107'),
                                                  ),
                                                  label: const Text(
                                                    'EDIT',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                  color: HexColor('#343A40'),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                FlatButton.icon(
                                                  onPressed: () {
                                                    _woDisable(a, context);
                                                    // print(a);
                                                  },
                                                  icon: Icon(
                                                    Icons.highlight_off,
                                                    color: HexColor('#DC3545'),
                                                  ),
                                                  label: const Text(
                                                    'NOT ACTIVE',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                  color: HexColor('#343A40'),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                FlatButton.icon(
                                                  onPressed: () {
                                                    _woEnable(a, context);
                                                    print(context);
                                                  },
                                                  icon: Icon(
                                                    Icons.check_circle,
                                                    color: HexColor('#28A745'),
                                                  ),
                                                  label: const Text(
                                                    'ACTIVE',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                  color: HexColor('#343A40'),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                FlatButton.icon(
                                                  onPressed: () {
                                                    _woDel(a, context);
                                                    // print(a);
                                                  },
                                                  icon: const Icon(Icons.delete,
                                                      color: Colors.white),
                                                  label: const Text(
                                                    'DELETE',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                  color: HexColor('#343A40'),
                                                  shape: RoundedRectangleBorder(
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
                                                                testsearch()));
                                                  },
                                                  icon: Icon(
                                                    Icons.autorenew_sharp,
                                                    color: HexColor('#17A2B8'),
                                                  ),
                                                  label: const Text(
                                                    'RELOAD',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                  color: HexColor('#343A40'),
                                                  shape: RoundedRectangleBorder(
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
                              // indexnum = _userGetdata[index]['id'].toString();
                              print('indexnuma');

                              // _userDel(indexnum);
                            },
                            child: Card(
                              color: selectedIndex == index
                                  ? Colors.blue[100]
                                  : Colors.white,
                              elevation: 8,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(
                                        0.5), // this column has a fixed width of 50
                                    1: FlexColumnWidth(
                                        0.1), // take 1/3 of the remaining space
                                    2: FlexColumnWidth(
                                        1), // // take 2/3 of the remaining space
                                  },
                                  children: [
                                    TableRow(children: [
                                      const Text('Workorder',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      const Text(' : ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        _foundUsers[index]['workorder_no'],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      const Text('Description',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      const Text(' : ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        _foundUsers[index]['description']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      const Text('Period',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      const Text(' : ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        _foundUsers[index]['period'],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                                    TableRow(
                                      children: [
                                        const Text('Start Date',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        const Text(' : ',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                          _foundUsers[index]['start_date'],
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        const Text('Status',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        const Text(' : ',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                          _foundUsers[index]['status']
                                                      .toString() ==
                                                  '1'
                                              ? 'Active'
                                              : 'Not Active',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
    );
  }

  Future<void> _woDisable(String a, context) async {
    print('token: ' + _tokenJwt[0]);
    var resp = await http.post(
        Uri.parse(
            "http://147.139.134.143/mrtjakarta/public/api/workorder/status/0/" +
                a),
        headers: {
          'cookie': _cookies,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _tokenJwt
        });
    print(resp.body);
    if (resp.statusCode == 200) {
      print('success');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => testsearch()));
    } else {
      print('failed');
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to disable workorder'),
        ),
      );
    }
  }

  Future<void> _woEnable(String a, context) async {
    print('token: ' + _tokenJwt[0]);
    var resp = await http.post(
        Uri.parse(
            "http://147.139.134.143/mrtjakarta/public/api/workorder/status/1/" +
                a),
        headers: {
          'cookie': _cookies,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _tokenJwt
        });
    print(resp.body);
    if (resp.statusCode == 200) {
      print('success');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => testsearch()));
    } else {
      print('failed');
    }
  }

  Future<void> _woDel(String a, context) async {
    print('token: ' + _tokenJwt[0]);
    var resp = await http.post(
        Uri.parse(
            "http://147.139.134.143/mrtjakarta/public/api/workorder/status/2/" +
                a),
        headers: {
          'cookie': _cookies,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _tokenJwt
        });
    print(resp.body);
    if (resp.statusCode == 200) {
      print('success');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => testsearch()));
    } else {
      print('failed');
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete workorder'),
        ),
      );
    }
  }
}
