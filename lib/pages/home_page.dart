import 'package:flutter/material.dart';
import 'package:mrt/NavDrawer.dart';
import 'package:mrt/excel.dart';
import 'package:mrt/preventive.dart';
import 'package:mrt/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../globals.dart' as globals;
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

List<dynamic> _getsubsystemfromhome = [];

class _HomePageState extends State<HomePage> {
  late List<GDPData> _chartData;
  late TooltipBehavior _tooltipBehavior;

  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  // final String url = 'https://karyaku.id/mrtjakarta/public/api';
  String _tokenJwt = '';
  String _cookies = '';
  String _role = '';
  List<dynamic> _getpreventive = [];
  List<dynamic> _getfailure = [];

  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _foundUsers = [];

  // Wheater to loop through elements
  bool _loop = true;
  int a = 0, b = 0, c = 0, d = 0;

  // Maintain current index of carousel
  int _selectedIndex = 0;
  int open = 0;
  int progress = 0;
  int close = 0;
  int need = 0;
  int popen = 0;
  int pprogress = 0;
  int pclose = 0;
  int pneed = 0;
  // Width of each item
  double? _itemExtent;

  //SORT BY DATE
  bool isDate = false;
  @override
  void initState() {
    // _timeString =
    //     "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
    // Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
    // datas = getData();
    // // _controller = InfiniteScrollController(initialItem: _selectedIndex);

    _tooltipBehavior = TooltipBehavior(enable: true);
    // _dataSource = DataSource(data: datas);
    super.initState();
    init();
  }

  final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();

  Future init() async {
    String _token = await SecureStorage.getToken();
    String _cookie = await SecureStorage.getCookie();
    String _rolelocal = await SecureStorage.getRole();
    // String _departmentname = await SecureStorage.getFkdepartment();
    // print('_cookie: ' + _cookie);
    // print('_token: ' + _token);
    // print('_fkdepartment: ' + _departmentname);

    setState(() {
      _tokenJwt = _token;
      _cookies = _cookie;
      _role = _rolelocal;
      // print('_role: ' + _role);
      // _fkdepartment = _departmentname;
    });
    // await SecureStorage.deleteSecureData('token', _token);
    // _FailureProgress();
    // _FailureClose();
    // _FailureOpen();
    _Failure();
    _Preventive();
    // _PreventiveOpen();
    // _PreventiveClose();
    // _PreventiveProgress();
  }

  Future<void> _Failure() async {
    var resp = await http.get(Uri.parse(url + "/failureopen/get"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt,
    });
    setState(() {
      _getfailure = jsonDecode(resp.body);

      _allUsers = [
        for (var i = 0; i < _getfailure.length; i++)
          {
            'id': _getfailure[i]['id'].toString(),
            'workorder_no': _getfailure[i]['workorder_no'].toString(),
            'departmentname': _getfailure[i]['departmentname'].toString(),
            'equipment_idname': _getfailure[i]['equipment_idname'].toString(),
            'status': _getfailure[i]['status'],
            'status_proses': _getfailure[i]['status_proses'],
          }
      ];
      _foundUsers = _allUsers;
      // data = jsonDecode(resp.body);
      for (var i = 0; i < _getfailure.length; i++) {
        if (_getfailure[i]['status'] == 1) {
          if (_getfailure[i]['status_proses'] == 0) {
            open++;
            // print('open: ' + open.toString());
          } else if (_getfailure[i]['status_proses'] == 1) {
            progress++;
          } else if (_getfailure[i]['status_proses'] == 3) {
            close++;
          } else if (_getfailure[i]['status_proses'] == 4) {
            need++;
          }
        }
      }
      // print('fopen: ' + open.toString());
      // print('fprogress: ' + progress.toString());
      // print('fclose: ' + close.toString());
      // print('fneed: ' + need.toString());
      _chartData = getChartData(open, progress, close, need);
    });
  }

  Future<void> _Preventive() async {
    var resp = await http.get(Uri.parse(url + "/preventiveopen/get"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    setState(() {
      _getpreventive = jsonDecode(resp.body);
      print(_getpreventive);
      for (var i = 0; i < _getpreventive.length; i++) {
        if (_getpreventive[i]['status'] == 1) {
          if (_getpreventive[i]['status_proses'] == 0) {
            popen++;
            // print('open: ' + open.toString());
          } else if (_getpreventive[i]['status_proses'] == 1) {
            pprogress++;
          } else if (_getpreventive[i]['status_proses'] == 3) {
            pclose++;
          } else if (_getpreventive[i]['status_proses'] == 4) {
            pneed++;
          }
        }
      }
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
          .where((description) => description["equipment_idname"]
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
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text("Hello World"),
          );
        }));
    final bytes = pdf.save();
    // final blob = html.Blob([bytes], 'application/pdf');

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        leading: _isSearching ? const BackButton() : null,
        title: _isSearching ? _buildSearchField() : Text('MRT DASHBOARD'),
        actions: _buildActions(),
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
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
              Padding(
                padding: EdgeInsets.all(0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: SizedBox(
                    height: 10,
                    width: 10, // card height
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        dragDevices: {
                          PointerDeviceKind.touch,
                          // PointerDeviceKind.mouse,
                        },
                      ),
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 1,
                        itemBuilder: (_, i) {
                          return Transform.scale(
                            scale: i == _index ? 1 : 0.9,
                            child: Padding(
                              padding: EdgeInsets.only(top: 20, bottom: 20),
                              child: Container(
                                width: 50,
                                height: 50,
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (i == 0) ...[
                                          if (open == 0 &&
                                              progress == 0 &&
                                              close == 0 &&
                                              need == 0) ...[
                                            Icon(
                                              Icons.error_outline,
                                              color: Colors.red,
                                            ),
                                          ] else ...[
                                            SfCircularChart(
                                              title: ChartTitle(
                                                  text: 'Failure Chart'),
                                              legend: Legend(
                                                  isVisible: true,
                                                  overflowMode:
                                                      LegendItemOverflowMode
                                                          .wrap),
                                              tooltipBehavior: _tooltipBehavior,
                                              series: <CircularSeries>[
                                                PieSeries<GDPData, String>(
                                                  dataSource: _chartData,
                                                  xValueMapper:
                                                      (GDPData data, _) =>
                                                          data.contient,
                                                  yValueMapper:
                                                      (GDPData data, _) =>
                                                          data.gdp,
                                                  dataLabelSettings:
                                                      DataLabelSettings(
                                                          isVisible: true),
                                                  enableTooltip: true,
                                                ),
                                              ],
                                            ),
                                          ]
                                        ] else if (i == 1) ...[
                                          Align(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  popen.toString() +
                                                      ' Preventive Open',
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  pprogress.toString() +
                                                      ' Preventive Progress',
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  pclose.toString() +
                                                      ' Preventive Close',
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  pneed.toString() +
                                                      ' Need Revision',
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                        ] else ...[
                                          Align(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  open.toString() +
                                                      ' Failure Open',
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  progress.toString() +
                                                      ' Failure In-Progress',
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  close.toString() +
                                                      ' Failure Closed',
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  need.toString() +
                                                      ' Failure Need-Revision',
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                        ]
                                      ],
                                      //   ),
                                      // ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                //create
                padding: EdgeInsets.all(0),
                child: Card(
                  //decoration radius
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: ClipRRect(
                      child: Container(
                        // height: 70,
                        // color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Container(
                              //decoration radius
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.yellow[700],
                              ),
                              // color: Colors.red,
                              width: 70,
                              height: 70,
                              child: Icon(Icons.copy, color: Colors.white),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Workorder - Open'),
                                  Divider(
                                    color: Colors.black,
                                    endIndent: 200,
                                  ),
                                  Text(
                                    popen.toString(),
                                    // style: TextStyle(color: Colors.grey)
                                  )
                                ],
                              ),
                            ),
                            // Icon(Icons.arrow_forward_ios, color: Colors.blue),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                //create
                padding: EdgeInsets.all(0),
                child: Card(
                  //decoration radius
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: ClipRRect(
                      child: Container(
                        // height: 70,
                        // color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Container(
                              //decoration radius
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue[700],
                              ),
                              // color: Colors.red,
                              width: 70,
                              height: 70,
                              child: Icon(Icons.message_outlined,
                                  color: Colors.white),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Work Order - Progress'),
                                  Divider(
                                    color: Colors.black,
                                    endIndent: 200,
                                  ),
                                  Text(
                                    pprogress.toString(),
                                    // style: TextStyle(color: Colors.grey)
                                  )
                                ],
                              ),
                            ),
                            // Icon(Icons.arrow_forward_ios, color: Colors.blue),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                //create
                padding: EdgeInsets.all(0),
                child: Card(
                  //decoration radius
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: ClipRRect(
                      child: Container(
                        // height: 70,
                        // color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Container(
                              //decoration radius
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green[700],
                              ),
                              // color: Colors.red,
                              width: 70,
                              height: 70,
                              child: Icon(Icons.flag, color: Colors.white),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Work Order - Close'),
                                  Divider(
                                    color: Colors.black,
                                    endIndent: 200,
                                  ),
                                  Text(
                                    pclose.toString(),
                                    // style: TextStyle(color: Colors.grey)
                                  )
                                ],
                              ),
                            ),
                            // Icon(Icons.arrow_forward_ios, color: Colors.blue),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                //create
                padding: EdgeInsets.all(0),
                child: Card(
                  //decoration radius
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: ClipRRect(
                      child: Container(
                        // height: 70,
                        // color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Container(
                              //decoration radius
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.red[700],
                              ),
                              // color: Colors.red,
                              width: 70,
                              height: 70,
                              child: Icon(Icons.star, color: Colors.white),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Work Order - Need Revision'),
                                  Divider(
                                    color: Colors.black,
                                    endIndent: 200,
                                  ),
                                  Text(
                                    pneed.toString(),
                                    // style: TextStyle(color: Colors.grey)
                                  )
                                ],
                              ),
                            ),
                            // Icon(Icons.arrow_forward_ios, color: Colors.blue),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    // height: 200,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Card(
                      color: Colors.yellow[700],
                      //decoration radius
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: ClipRRect(
                          child: Container(
                            // height: 70,
                            // color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  //decoration radius
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // color: Colors.red[700],
                                  ),
                                  // color: Colors.red,
                                  width: 0,
                                  height: 70,
                                  // child: Icon(Icons.star, color: Colors.white),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Failure - Open'),
                                      Divider(
                                        color: Colors.black,
                                        endIndent: 90,
                                      ),
                                      Text(
                                        open.toString(),
                                        // style: TextStyle(color: Colors.grey)
                                      )
                                    ],
                                  ),
                                ),
                                // Icon(Icons.arrow_forward_ios, color: Colors.blue),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // height: 200,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Card(
                      color: Colors.blue[700],
                      //decoration radius
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: ClipRRect(
                          child: Container(
                            // height: 70,
                            // color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  //decoration radius
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.red[700],
                                  ),
                                  // color: Colors.red,
                                  width: 0,
                                  height: 70,
                                  // child: Icon(Icons.star, color: Colors.white),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Failure - Progress'),
                                      Divider(
                                        color: Colors.black,
                                        endIndent: 90,
                                      ),
                                      Text(
                                        progress.toString(),
                                        // style: TextStyle(color: Colors.grey)
                                      )
                                    ],
                                  ),
                                ),
                                // Icon(Icons.arrow_forward_ios, color: Colors.blue),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    // height: 200,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Card(
                      color: Colors.green[700],
                      //decoration radius
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: ClipRRect(
                          child: Container(
                            // height: 70,
                            // color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  //decoration radius
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.red[700],
                                  ),
                                  // color: Colors.red,
                                  width: 0,
                                  height: 70,
                                  // child: Icon(Icons.star, color: Colors.white),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Failure - Close'),
                                      Divider(
                                        color: Colors.black,
                                        endIndent: 90,
                                      ),
                                      Text(
                                        close.toString(),
                                        // style: TextStyle(color: Colors.grey)
                                      )
                                    ],
                                  ),
                                ),
                                // Icon(Icons.arrow_forward_ios, color: Colors.blue),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // height: 200,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Card(
                      color: Colors.red[700],
                      //decoration radius
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: ClipRRect(
                          child: Container(
                            // height: 70,
                            // color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  //decoration radius
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.red[700],
                                  ),
                                  // color: Colors.red,
                                  width: 0,
                                  height: 70,
                                  // child: Icon(Icons.star, color: Colors.white),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Failure - Need Revision'),
                                      Divider(
                                        color: Colors.black,
                                        endIndent: 90,
                                      ),
                                      Text(
                                        need.toString(),
                                        // style: TextStyle(color: Colors.grey)
                                      )
                                    ],
                                  ),
                                ),
                                // Icon(Icons.arrow_forward_ios, color: Colors.blue),
                              ],
                            ),
                          ),
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
                            //       label: Text(
                            //         order ? 'Z - A' : 'A - Z',
                            //       ),
                            //     ),
                            //     RaisedButton.icon(
                            //       onPressed: () {
                            //         setState(() => isDate = !isDate);
                            //       },
                            //       icon: Icon(Icons.format_line_spacing),
                            //       label: Text(
                            //         isDate
                            //             ? 'Sort By Date (New - Old)'
                            //             : 'Sort By Date (Old - New)',
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
                                  final sortedDate = _getfailure
                                    ..sort(
                                      (a, b) => isDate
                                          ? a["report_date"]
                                              .compareTo(b["report_date"])
                                          : b["report_date"]
                                              .compareTo(a["report_date"]),
                                    );
                                  return GestureDetector(
                                    onTap: () {
                                      // print('indexnum');
                                    },
                                    child: Card(
                                        elevation: 8,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Table(
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
                                                Text('Title',
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
                                                  _getfailure[index]['title'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ]),
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
                                                  _getfailure[index]
                                                          ['workorder_no']
                                                      .toString(),
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
                                                  _getfailure[index]
                                                      ['departmentname'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                                    _getfailure[index]
                                                        ['equipment_idname'],
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
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ] else if (_foundUsers[
                                                                index]
                                                            ['status_proses'] ==
                                                        1) ...[
                                                      Text(
                                                        'In Progress',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ] else if (_foundUsers[
                                                                index]
                                                            ['status_proses'] ==
                                                        2) ...[
                                                      Text(
                                                        'Need-Approval',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ] else if (_foundUsers[
                                                                index]
                                                            ['status_proses'] ==
                                                        3) ...[
                                                      Text(
                                                        'Close',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ] else if (_foundUsers[
                                                                index]
                                                            ['status_proses'] ==
                                                        4) ...[
                                                      Text(
                                                        'Need-Revision',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                          /*
                                            Row(
                                              children: [

                                                //standart
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      if (_getfailure[index]
                                                                  ['title']
                                                              .toString()
                                                              .length >
                                                          37) ...[
                                                        Text(
                                                          'Title ',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(' '),
                                                      ] else ...[
                                                        Text(
                                                          'Title ',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                      Text(
                                                        'Workorder ',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        'Department ',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        'Equipment ID',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        'Status ',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ]),
                                                Column(
                                                  children: [
                                                    if (_getfailure[index]
                                                                ['title']
                                                            .toString()
                                                            .length >
                                                        37) ...[
                                                      Text(
                                                        ':',
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                      Text(' ',
                                                          style: TextStyle(
                                                              fontSize: 15)),
                                                    ] else ...[
                                                      Text(
                                                        ' : ',
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                    Text(' : ',
                                                        style: TextStyle(
                                                            fontSize: 15)),
                                                    Text(' : ',
                                                        style: TextStyle(
                                                            fontSize: 15)),
                                                    Text(' : ',
                                                        style: TextStyle(
                                                            fontSize: 15)),
                                                    Text(' : ',
                                                        style: TextStyle(
                                                            fontSize: 15)),
                                                  ],
                                                ),
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        _getfailure[index]
                                                            ['title'],
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        '${_getfailure[index]['report_date'].toString()}',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        _getfailure[index]
                                                            ['departmentname'],
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        _getfailure[index][
                                                            'equipment_idname'],
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      if (_foundUsers[index]
                                                              ['status'] ==
                                                          1) ...[
                                                        if (_foundUsers[index][
                                                                'status_proses'] ==
                                                            0) ...[
                                                          Text(
                                                            'Open',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ] else if (_foundUsers[
                                                                    index][
                                                                'status_proses'] ==
                                                            1) ...[
                                                          Text(
                                                            'In Progress',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ] else if (_foundUsers[
                                                                    index][
                                                                'status_proses'] ==
                                                            2) ...[
                                                          Text(
                                                            'Need-Approval',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ] else if (_foundUsers[
                                                                    index][
                                                                'status_proses'] ==
                                                            3) ...[
                                                          Text(
                                                            'Close',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ] else if (_foundUsers[
                                                                    index][
                                                                'status_proses'] ==
                                                            4) ...[
                                                          Text(
                                                            'Need-Revision',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ]
                                                      ] else ...[
                                                        Text(
                                                          'Not Active',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )*/
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
      ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.add),
        overlayColor: Colors.blue,
        overlayOpacity: 0.3,
        children: [
          SpeedDialChild(
              child: Icon(Icons.add),
              label: 'New Failure Thread',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => preventive()),
                  )),
          SpeedDialChild(
              child: Icon(Icons.add),
              label: 'New WO PM',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => preventive()),
                  )),
          SpeedDialChild(
              child: Icon(Icons.add),
              label: 'Export to Excel',
              onTap: () => createExcel(_getfailure)),
        ],
      ),
    );
  }

  List<GDPData> getChartData(int a, int b, int c, int d) {
    final List<GDPData> chartData = [
      GDPData('Failure Close', a),
      GDPData('Failure Open', b),
      GDPData('Failure Proress', c),
      GDPData('Need Revision', d),
    ];
    return chartData;
  }
}

class GDPData {
  GDPData(this.contient, this.gdp);
  final String contient;
  final int gdp;
}
