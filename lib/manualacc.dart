import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mrt/NavDrawer.dart';
import 'package:mrt/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:mrt/utils/excelclosewo.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

class manualacc extends StatefulWidget {
  static const String routeName = '/closewo';

  @override
  State<manualacc> createState() => _manualaccState();
}

class _manualaccState extends State<manualacc> {
  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  String _tokenJwt = '';
  String _cookies = '';
  List<dynamic> _getmanual = [];

  @override
  void initState() {
    init();
    super.initState();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  Future init() async {
    String _token = await SecureStorage.getToken();
    String _cookie = await SecureStorage.getCookie();
    setState(() {
      _tokenJwt = _token;
      _cookies = _cookie;
    });
    _manual();
  }

  // Future<void> _export(int indexnum, List<dynamic> _getselected) async {
  //   final pdfFile = await PdfApi.generateImage(indexnum, _getselected);

  //   PdfApi.openFile(pdfFile);
  // }
  static var httpClient = new HttpClient();
  Future<File> _downloadFile(String url, String filename) async {
    // print('babi');
    var request = await httpClient.getUrl(Uri.parse(
        'http://147.139.134.143/mrtjakarta/public/storage/manual/xzKdx3dt0rnMDYRlip7aqVSZ3DQS7Nc6suSOdr4s.pdf'));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _foundUsers = [];
  Future<void> _manual() async {
    print('token: ' + _tokenJwt);
    var resp = await http.get(
        Uri.parse("http://147.139.134.143/mrtjakarta/public/api/manual/get"),
        headers: {
          'Cookie': _cookies,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _tokenJwt
        });
    setState(() {
      _getmanual = jsonDecode(resp.body);
      _allUsers = [
        for (var i = 0; i < _getmanual.length; i++)
          {
            'id': _getmanual[i]['id'].toString(),
            'departmentname': _getmanual[i]['departmentname'].toString(),
            'systemname': _getmanual[i]['systemname'].toString(),
            'system_subname': _getmanual[i]['system_subname'].toString(),
            'equipmentname': _getmanual[i]['equipmentname'].toString(),
            'name': _getmanual[i]['name'].toString(),
            'file': _getmanual[i]['file'].toString(),
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

  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  bool order = true;
  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  Future download(String url) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final Storage = await getExternalStorageDirectory();

      await FlutterDownloader.enqueue(
          url: url,
          savedDir: Storage!.path,
          showNotification:
              true, // show download progress in status bar (for Android)
          openFileFromNotification:
              true, // click on notification to open downloaded file (for Android)
          saveInPublicStorage: true);
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => manualacc()));
  }

  ReceivePort _port = ReceivePort();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => createExcel(_getmanual),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.print),
      ),
      appBar: AppBar(
        leading: _isSearching ? const BackButton() : null,
        title: _isSearching ? _buildSearchField() : Text('Manual'),
        actions: _buildActions(),
      ),
      drawer: NavDrawer(),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(10),
        child: Column(
          children: [
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
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _foundUsers.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    // _getselected = _getpreventive[index] ;
                                    String indexnum =
                                        _foundUsers[index]['file'].toString();
                                    print('id = ' + indexnum);
                                    print('index = ' + index.toString());
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
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      FlatButton.icon(
                                                        onPressed: () => download(
                                                            'http://147.139.134.143/mrtjakarta/storage/app/' +
                                                                _foundUsers[index]
                                                                        ['file']
                                                                    .toString()),
                                                        // onPressed: () {

                                                        //   // _downloadFile(
                                                        //   //     'http://147.139.134.143/mrtjakarta/' +
                                                        //   //         _foundUsers[index]
                                                        //   //                 ['file']
                                                        //   //             .toString(),
                                                        //   //     _foundUsers[index]['name']
                                                        //   //             .toString() +
                                                        //   //         '.pdf');
                                                        // },
                                                        icon: Icon(
                                                          Icons.print,
                                                          color: HexColor(
                                                              '#FFC107'),
                                                        ),
                                                        label: Text(
                                                          'Download Attachment',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        color:
                                                            HexColor('#343A40'),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      FlatButton.icon(
                                                        onPressed: () {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          manualacc()));
                                                        },
                                                        icon: Icon(
                                                          Icons.autorenew_sharp,
                                                          color: HexColor(
                                                              '#17A2B8'),
                                                        ),
                                                        label: Text(
                                                          'RELOAD',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        color:
                                                            HexColor('#343A40'),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
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
                                    // _userDel(indexnum);
                                  },
                                  child: Card(
                                      elevation: 8,
                                      child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Table(columnWidths: {
                                            0: FixedColumnWidth(
                                                80), // this column has a fixed width of 50
                                            1: FlexColumnWidth(
                                                0.1), // take 1/3 of the remaining space
                                            2: FlexColumnWidth(
                                                1), // // take 2/3 of the remaining space
                                          }, children: [
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
                                              Text('System',
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
                                                    ['systemname'],
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ]),
                                            TableRow(children: [
                                              Text('Sub System',
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
                                                        ['system_subname']
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ]),
                                            TableRow(children: [
                                              Text('Equipment',
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
                                                    ['equipmentname'],
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ]),
                                            TableRow(
                                              children: [
                                                Text('Name',
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
                                                  _foundUsers[index]['name'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ])
                                          /* Row(
                                            children: [
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      'Department ',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'System ',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'Sub-System',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'Equipment  ',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    // Text(
                                                    //   'Start Time  ',
                                                    //   style: TextStyle(
                                                    //       fontSize: 15,
                                                    //       fontWeight: FontWeight.bold),
                                                    // ),
                                                    Text(
                                                      'Name ',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    // Text(
                                                    //   ' ',
                                                    //   style: TextStyle(
                                                    //       fontSize: 15,
                                                    //       fontWeight: FontWeight.bold),
                                                    // ),
                                                  ]),
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
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
                                                          _foundUsers[index]
                                                                  ['systemname']
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ' : ' +
                                                          _foundUsers[index][
                                                                  'system_subname']
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ' : ' +
                                                          _foundUsers[index][
                                                                  'equipmentname']
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ' : ' +
                                                          _foundUsers[index]
                                                                  ['name']
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ]),
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
      resizeToAvoidBottomInset: true,
    );
  }
}

Widget _buildPopupDialog(BuildContext context, String id, int index) {
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
                      // _aproval();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => manualacc()));
                    },
                    icon: Icon(
                      Icons.print,
                      color: HexColor('#FFC107'),
                    ),
                    label: Text(
                      'Export PDF',
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
                          MaterialPageRoute(builder: (context) => manualacc()));
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
