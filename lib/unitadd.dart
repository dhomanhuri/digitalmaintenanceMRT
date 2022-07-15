import 'package:flutter/material.dart';
import 'package:mrt/NavDrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:mrt/material.dart';
import 'package:mrt/unit.dart';
import 'package:mrt/utils/secure_storage.dart';
import 'dart:async';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:mrt/failureinput.dart';
import 'package:mrt/unit.dart';

class unitAdd extends StatefulWidget {
  static const String routeName = '/failureAdd';

  @override
  State<unitAdd> createState() => _unitAddState();
}

class _unitAddState extends State<unitAdd> {
  final _formKey = GlobalKey<FormState>();

  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  // final String url = 'https://karyaku.id/mrtjakarta/public/api';

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
  String title = '';
  String location = '';
  String area = '';
  String delay = '';
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
  String qty = '';
  // int unit = 1;
  String WoNumber = '';
  int status = 1;
  String reportdate = '';
  String note = '';
  String initialreportdate = 'Select Report Date';
  String initialfailuredate = 'Select Failure Date';
  String initialfailuretime = 'Select Time Failure';
  String initialdelay = 'Select Delay';
  TimeOfDay selectedTime = TimeOfDay.now();
  _selectTime(BuildContext context) async {
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }

  final _headerStyle = const TextStyle(
      color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold);
  final _contentStyleHeader = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700);
  final _contentStyle = const TextStyle(
      color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold);

  // String? dropDownValue1;
  // String? dropDownValue2;
  // String? dropDownValue3;
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
    // _subsystemfunc();
  }

  Future<void> _addMaterial(String a) async {
    var headers = {
      'Authorization': 'Bearer ' + _tokenJwt,
      'Cookie': _cookies,
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('http://147.139.134.143/mrtjakarta/public/api/unit/save/0'));
    request.fields.addAll({
      'name': title,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => unit()));
    //
    //print('resp: ' + request.statusCode.toString());
  } // ini untuk menambahkan failure baru, diperlukan input beberapa parameter untuk mengisi field yang di perlukan

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Add Unit"),
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
                    height: 160,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue[100]),
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: 'Name',
                            labelText: 'Name',
                          ),
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Name tidak boleh kosong';
                            title = value.toString();
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
                                  await _addMaterial(
                                    title,
                                  );
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
