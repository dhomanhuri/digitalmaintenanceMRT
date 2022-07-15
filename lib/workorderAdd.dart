import 'package:flutter/material.dart';
import 'package:mrt/NavDrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:mrt/testsearch.dart';
import 'package:mrt/utils/secure_storage.dart';
import 'dart:async';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:mrt/unit.dart';

class WorkorderAdd extends StatefulWidget {
  static const String routeName = '/failureAdd';

  @override
  State<WorkorderAdd> createState() => _WorkorderAddState();
}

class _WorkorderAddState extends State<WorkorderAdd> {
  final _formKey = GlobalKey<FormState>();

  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  // final String url = 'https://karyaku.id/mrtjakarta/public/api';

  List<dynamic> _getperiod = [];
  List<String> periodname = [];
  List<String> periodid = [];
  String selectperiod = '';
  List<dynamic> _getdepartment = [];
  List<String> departmentname = [];
  List<String> departmentid = [];
  String _tokenJwt = '';
  String _cookies = '';
  String title = '';
  String desc = '';
  String location = '';
  String area = '';
  String delay = '';
  String reportedby = '';
  String receivedby = '';
  String failuredate = '';
  String failuretime = '';
  String system = '';
  String subsystem = '';
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
  String initialreportdate = 'Start - Date';
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
    _period();
    _department();
  }

  Future<void> _period() async {
    print('masuksubsystem external');
    var resp = await http.get(
        // ignore: avoid_print
        Uri.parse('http://147.139.134.143/mrtjakarta/public/api/period/get'),
        headers: {
          'Cookie': _cookies,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _tokenJwt
        });
    print(resp.body);
    // print('masuksubsystemwqewqewq');
    _getperiod = [...jsonDecode(resp.body)];
    print(jsonDecode(resp.body));
    setState(() {
      for (var i = 0; i < _getperiod.length; i++) {
        periodname.add(_getperiod[i]['name'].toString());
        periodid.add(_getperiod[i]['code'].toString());
        // print(newdata);
      }
    });
  }

  Future<void> _department() async {
    var resp = await http.get(Uri.parse(url + "/department/get"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    _getdepartment = [...jsonDecode(resp.body)];
    setState(() {
      for (var i = 0; i < _getdepartment.length; i++) {
        departmentname.add(_getdepartment[i]['name'].toString());
        departmentid.add(_getdepartment[i]['id'].toString());
      }
    });
  }

  Future<void> _addMaterial(String a) async {
    var headers = {
      'Authorization': 'Bearer ' + _tokenJwt,
      'Cookie': _cookies,
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/workorder/save/0'));
    request.fields.addAll({
      'workorder_no': title,
      'description': desc,
      'period': selectperiod,
      'start_date': reportdate,
      'department': receivedby
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => testsearch()));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add data'),
      ));
    }

    //
    //print('resp: ' + request.statusCode.toString());
  } // ini untuk menambahkan failure baru, diperlukan input beberapa parameter untuk mengisi field yang di perlukan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule WO Add"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                    width: double.infinity,
                    height: 430,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue[100]),
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: 'Workorder Number',
                            labelText: 'Workorder Number',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Workorder tidak boleh kosong';
                            }
                            title = value.toString();
                            return null;
                          },
                          // onSaved: (value) => title = value.toString()
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: 'Description',
                            labelText: 'Description',
                          ),
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Description tidak boleh kosong';
                            desc = value.toString();
                            return null;
                          },
                          // onSaved: (value) => title = value.toString()
                        ),
                        const Divider(),
                        Center(
                          child: DropdownSearch<String>(
                            mode: Mode.BOTTOM_SHEET,
                            // showSelectedItem: true,
                            items: departmentname,
                            label: "Department",
                            // hint: "country in menu mode",
                            onChanged: (value) {
                              setState(() {
                                int selectedint = departmentname
                                    .indexWhere((item) => item == value);
                                receivedby = departmentid[selectedint];
                                print(receivedby);
                              });
                            },
                            showClearButton: true,
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.zero,
                          child: Center(
                            child: DropdownSearch<String>(
                              mode: Mode.BOTTOM_SHEET,
                              // showSelectedItem: true,
                              items: periodname,
                              label: "Period",
                              // hint: "country in menu mode",
                              onChanged: (value) {
                                setState(() {
                                  int indexperiod = periodname
                                      .indexWhere((item) => item == value);
                                  selectperiod = periodid[indexperiod];
                                  print(selectperiod);
                                });
                              },
                              showClearButton: true,
                            ),
                          ),
                        ),
                        Divider(),
                        Container(
                          margin: EdgeInsets.only(left: 5, bottom: 1, top: 1),
                          // height: 30,
                          width: MediaQuery.of(context).size.width -
                              (MediaQuery.of(context).size.width / 10),
                          // color: Colors.white,
                          child: OutlinedButton(
                              child: Text(
                                initialreportdate,
                              ),
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2025),
                                        initialEntryMode:
                                            DatePickerEntryMode.calendarOnly)
                                    .then((value) {
                                  if (value != null) {
                                    setState(() {
                                      reportdate =
                                          value.toString().split(' ')[0];
                                      initialreportdate = reportdate;
                                      print(reportdate);
                                    });
                                  }
                                });
                              }),
                        ),
                        Divider(),
                        ElevatedButton(
                            child: const Text(
                              'Add',
                              style: TextStyle(color: Colors.white),
                            ),
                            style:
                                ElevatedButton.styleFrom(primary: Colors.blue),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await _addMaterial(
                                  title,
                                );
                              }
                              _isLoading = 1;
                            })
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
