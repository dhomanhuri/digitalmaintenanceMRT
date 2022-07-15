import 'package:flutter/material.dart';
import 'package:mrt/NavDrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:mrt/executewo.dart';
import 'package:mrt/material.dart';
import 'package:mrt/utils/secure_storage.dart';
import 'dart:async';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:mrt/failureinput.dart';
import 'globals.dart' as globals;

import 'package:file_picker/file_picker.dart';

class inputchecksheetedit extends StatefulWidget {
  static const String routeName = '/failureAdd';

  @override
  State<inputchecksheetedit> createState() => _inputchecksheeteditState();
}

class _inputchecksheeteditState extends State<inputchecksheetedit> {
  final _formKey = GlobalKey<FormState>();

  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  // final String url = 'https://karyaku.id/mrtjakarta/public/api';

  List<dynamic> _getsearchmat = [];
  List<String> searchmatname = [];
  List<String> searchmatid = [];
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
  List<dynamic> _getwonumber = [];
  List<String> newdata = [];
  List<String> newdataid = [];
  String _tokenJwt = '';
  String _cookies = '';
  String title = globals.materialnametemp;
  String location = '';
  String initialtitle = '';
  String initialqty = '';
  String reportedby = '';
  String receivedby = '';
  String failuredate = '';
  String failuretime = '';
  String system = '';
  String subsystem = '';
  String equipment = '';
  String equipment_id = '';
  String trainset = '';
  String description = '';
  String mitigation = '';
  String upload = '';
  String item = '';
  String qty = globals.materialqtytemp;
  int unit = 1;
  String WoNumber = '';
  int status = 1;
  String reportdate = '';
  String note = '';
  String initialreportdate = 'Select Report Date';
  String initialfailuredate = 'Select Failure Date';
  String initialfailuretime = 'Select Time Failure';
  String initialdelay = 'Select Delay';
  TimeOfDay selectedTime = TimeOfDay.now();
  String hasil = '';
  String tipehasil = '';
  // String? dropDownValue1;
  // String? dropDownValue2;
  // String? dropDownValue3;
  String itemCheck = globals.checksheetitemtemp;
  String refrence = globals.checksheetrefrencetemp;
  String typeresult = '';
  String filepath = '';
  String result = '';
  TextEditingController? textController1;
  TextEditingController? textController2;
  TextEditingController? textController3;
  int _isLoading = 0;
  String? _valGender;
  List _listGender = ["Male", "Female"];
  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    String _token = await SecureStorage.getToken();
    String _cookie = await SecureStorage.getCookie();
    // print('_cookie: ' + _cookie);
    setState(() {
      _tokenJwt = _token;
      _cookies = _cookie;
      // print(object)
    });
    // _searchmat();
  }

  List<PlatformFile>? _files;
  void _uploadFile() async {
    //TODO replace the url bellow with you ipv4 address in ipconfig
    var uri = Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/failureopen/save/93'),
        headers = {
          "Accept": "application/json",
          "Authorization": "Bearer $_tokenJwt",
          "Cookie": _cookies
        };
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath(
        'attach_file', _files!.first.path.toString()));
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Uploaded ...');
    } else {
      print('Something went wrong!');
    }
  }

  void _openFileExplorer() async {
    _files = (await FilePicker.platform.pickFiles(
            type: FileType.any, allowMultiple: false, allowedExtensions: null))!
        .files;

    print('Loaded file path is : ${_files!.first.path}');
  }

  Future<void> _savechecksheet() async {
    print('id :' + globals.checksheetequipmentidtemp);
    print('path: ' + _files!.first.path.toString());
    print('type_answer: ' + typeresult);
    print('result: ' + result);
    var headers = {'Authorization': 'Bearer ' + _tokenJwt, 'Cookie': _cookies};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/preventiveopen/save/4/' +
                globals.checksheetequipmentidtemp));
    request.fields
        .addAll({'type_answer-detail': typeresult, 'answer-detail': result});
    request.files.add(await http.MultipartFile.fromPath(
        'file', _files!.first.path.toString()));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> _addMaterial(String a, String b) async {
    var headers = {
      'Authorization': 'Bearer ' + _tokenJwt,
      'Cookie': _cookies,
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/material/save/' +
                globals.materialidtemp.toString()));
    request.fields.addAll({'name': title, 'quantity': qty});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => executewo()));
    //
    //print('resp: ' + request.statusCode.toString());
  } // ini untuk menambahkan failure baru, diperlukan input beberapa parameter untuk mengisi field yang di perlukan

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Edit Input Checksheet"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                    width: double.infinity,
                    height: 500,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue[100]),
                    child: Column(
                      children: [
                        TextFormField(
                          readOnly: true,
                          keyboardType: TextInputType.text,
                          initialValue: itemCheck,
                          decoration: const InputDecoration(
                            hintText: 'Item Pemeriksaan',
                            labelText: 'Item Pemeriksaan',
                          ),
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Item Pemeriksaan tidak boleh kosong';
                            itemCheck = value.toString();
                            return null;
                          },
                          // onSaved: (value) => title = value.toString()
                        ),
                        Divider(),
                        TextFormField(
                          readOnly: true,
                          keyboardType: TextInputType.text,
                          initialValue: refrence,
                          decoration: const InputDecoration(
                            hintText: 'Refrensi Standar',
                            labelText: 'Refrensi Standar',
                          ),
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Refrensi Standar tidak boleh kosong';
                            refrence = value.toString();
                            return null;
                          },
                          // onSaved: (value) => title = value.toString()
                        ),
                        Divider(),
                        Center(
                          child: DropdownSearch<String>(
                            mode: Mode.BOTTOM_SHEET,
                            // showSelectedItem: true,
                            items: ['Text/Number', 'image'],
                            label: "Tipe Hasil",
                            // hint: "country in menu mode",
                            onChanged: (value) {
                              setState(() {
                                if (value == 'Text/Number') {
                                  typeresult = '1';
                                } else {
                                  typeresult = '2';
                                }
                                print(typeresult);
                              });
                            },
                            showClearButton: true,
                            // selectedItem: (){
                            //   print();
                            // },
                          ),
                        ),
                        Divider(),
                        Divider(),
                        ElevatedButton(
                            onPressed: _openFileExplorer,
                            child: Text('Open File Explorer')),
                        Divider(),
                        Divider(),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          initialValue: qty,
                          decoration: const InputDecoration(
                            hintText: 'Hasil Pemeriksaan',
                            labelText: 'Hasil Pemeriksaan',
                          ),
                          onChanged: (value) {
                            result = value.toString();
                          },
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Hasil Pemeriksaan tidak boleh kosong';
                            result = value.toString();
                            return null;
                          },
                          // onSaved: (value) => title = value.toString()
                        ),
                        Divider(),
                        if (_isLoading == 0) ...[
                          ElevatedButton(
                              child: const Text(
                                'Add',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await _savechecksheet();
                                }
                                _isLoading = 1;
                              })
                        ] else ...[
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 3),
                              ),
                              child: LoadingBar(),
                            ),
                          ),
                        ]
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
      drawer: NavDrawer(),
    );
  }
}

class LoadingBar extends StatefulWidget {
  @override
  State<LoadingBar> createState() => _LoadingBarState();
}

class _LoadingBarState extends State<LoadingBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );

    _animationController.addListener(() => setState(() {}));
    // _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = _animationController.value * 100;
    return Center(
      child: Container(
        width: double.infinity,
        height: 15,
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: LiquidLinearProgressIndicator(
          value: _animationController.value,
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation(Colors.blue),
          borderRadius: 5,
          center: Text(
            "${percentage.toStringAsFixed(0)}%",
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
