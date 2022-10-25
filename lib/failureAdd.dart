import 'package:flutter/material.dart';
import 'package:mrt/NavDrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:mrt/failureexecuteact.dart';
import 'package:mrt/utils/secure_storage.dart';
import 'dart:async';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'globals.dart' as globals;
import 'package:file_picker/file_picker.dart';
import 'package:numberpicker/numberpicker.dart';

class failureAdd extends StatefulWidget {
  static const String routeName = '/failureAdd';

  @override
  State<failureAdd> createState() => _failureAddState();
}

class _failureAddState extends State<failureAdd> {
  final _formKey = GlobalKey<FormState>();

  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  // final String url = 'https://karyaku.id/mrtjakarta/public/api';

  List<dynamic> _getdepartmentreport = [];
  List<String> departmentnamereport = [];
  List<String> departmentidreport = [];
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
  String _gdepartment = '';
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
  int qty = 1;
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
  int _currentValue = 3;
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
    String _departmentlocal = await SecureStorage.getDepartment();
    // print('_cookie: ' + _cookie);
    setState(() {
      _tokenJwt = _token;
      _cookies = _cookie;
      _gdepartment = _departmentlocal;
      // print(object)
    });
    // _subsystemfunc();

    _area();
    _WoNumber();
    _trainsetfunc();
    _location();
    _department();
    // _system();
    _departmentreport();
    // _subsystem1();
    // _equipment();
    // _funcequipmentid();
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

  Future<void> _subsystem1(String a) async {
    print('masuksubsystem external');
    print('token: ' + _tokenJwt[0]);
    print('tokenasds: ' + _cookies);
    var resp = await http.get(
        Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/systemsub/ajax/' +
                a.toString()),
        headers: {
          'Cookie': _cookies,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _tokenJwt
        });
    print(resp.body);
    print('masuksubsystemwqewqewq');
    _getsubsystem1 = [...jsonDecode(resp.body)];
    print(jsonDecode(resp.body));
    setState(() {
      for (var i = 0; i < _getsubsystem1.length; i++) {
        subsystemname1.add(_getsubsystem1[i]['name'].toString());
        subsystemid1.add(_getsubsystem1[i]['id'].toString());
        // print(newdata);
      }
    });
  }

  Future<void> _failureopenadd(
    String workorder_no,
    String title,
    String location,
    String area,
    String delay,
    String reported_department,
    String received_department,
    String report_date,
    String failure_date,
    String failure_time,
    String system,
    String system_sub,
    String equipment,
    String equipment_id,
    String trainset,
    String failure_description,
    String report_action,
    String attach_file,
  ) async {
    var headers = {
      'Authorization': 'Bearer ' + _tokenJwt,
      'Cookie': _cookies,
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/failureopen/save/0'));
    request.fields.addAll({
      'workorder': WoNumber,
      'title': title,
      'location': location,
      'area': area,
      'delay': delay,
      'reported_department': reported_department,
      'received_department': received_department,
      'report_date': reportdate,
      'failure_date': failuredate,
      'failure_time': failuretime,
      'system': system,
      'system_sub': system_sub,
      'equipment': equipment,
      'equipment_id': equipment_id,
      'trainset': trainset,
      'failure_description': failure_description,
      'report_action': report_action,
    });
    request.files
        .add(await http.MultipartFile.fromPath('attach_file', attach_file));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String data = await response.stream.bytesToString();
      String data2 = jsonDecode(data)['idmaster'].toString();
      print(data);
      print(data2);
      globals.failureexecuteidtemp = data2;
      // indexnum = _userGetdata[index]['id'].toString();
      // print(_getfailure[index]['id'].toString());
      print(globals.failureexecuteidtemp);
      globals.areatemp = area;
      globals.workorder_notemp = WoNumber;
      globals.locationtemp = location;
      globals.reportdepartmenttemp = reported_department;
      globals.titletemp = title;
      globals.delaytemp = delay;
      globals.report_datetemp = reportdate;
      globals.failure_datetemp = failuredate;
      globals.failure_timetemp = failuretime;
      globals.failure_descriptiontemp = failure_description;
      globals.report_actiontemp = report_action;
      globals.receivedepartmenttemp = received_department;
      globals.systemtemp = system;
      globals.system_subtemp = system_sub;
      globals.equipmenttemp = equipment;
      globals.equipment_idtemp = equipment_id;
      globals.trainsettemp = trainset;
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => failureexecuteact()));
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> _departmentreport() async {
    var resp = await http.get(Uri.parse(url + "/department/get"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    _getdepartmentreport = [...jsonDecode(resp.body)];
    setState(() {
      for (var i = 0; i < _getdepartmentreport.length; i++) {
        if (_gdepartment.toString() == '1') {
          departmentnamereport.add(_getdepartmentreport[i]['name'].toString());
          departmentidreport.add(_getdepartmentreport[i]['id'].toString());
        } else if (_gdepartment.toString() ==
            _getdepartmentreport[i]['id'].toString()) {
          departmentnamereport.add(_getdepartmentreport[i]['name'].toString());
          departmentidreport.add(_getdepartmentreport[i]['id'].toString());
        }
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

  Future<void> _trainsetfunc() async {
    var resp = await http.get(Uri.parse(url + "/trainset/get"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    _gettrainset = [...jsonDecode(resp.body)];
    setState(() {
      for (var i = 0; i < _gettrainset.length; i++) {
        trainsetname.add(_gettrainset[i]['name'].toString());
        trainsetid.add(_gettrainset[i]['id'].toString());
      }
    });
  }

  Future<void> _area() async {
    var resp = await http.get(Uri.parse(url + "/area/get"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    _getarea = [...jsonDecode(resp.body)];
    setState(() {
      for (var i = 0; i < _getarea.length; i++) {
        areaname.add(_getarea[i]['name'].toString());
        areaid.add(_getarea[i]['id'].toString());
      }
    });
  }

  Future<void> _WoNumber() async {
    var resp = await http.get(Uri.parse(url + "/workorder/get"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    _getwonumber = [...jsonDecode(resp.body)];
    setState(() {
      for (var i = 0; i < _getwonumber.length; i++) {
        if (_getwonumber[i]['department'].toString() ==
            _gdepartment.toString()) {
          print('masuk if wo');
          newdata.add(_getwonumber[i]['workorder_no'].toString());
          newdataid.add(_getwonumber[i]['id'].toString());
        }
        if ('1' == _gdepartment.toString()) {
          print('masuk if wo');
          newdata.add(_getwonumber[i]['workorder_no'].toString());
          newdataid.add(_getwonumber[i]['id'].toString());
        }
      }
    });
  }

  // Future<void> _subsystem1() async {
  //   print('masuksubsystem');
  //   print('token: ' + _tokenJwt[0]);
  //   print('tokenasds: ' + _cookies);
  //   var resp = await http.get(
  //       Uri.parse('http://147.139.134.143/mrtjakarta/public/api/systemsub/get'),
  //       headers: {
  //         'Cookie': _cookies,
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer ' + _tokenJwt
  //       });
  //   print(resp);
  //   print('masuksubsystemwqewqewq');
  //   // _getsubsystem1 = [...jsonDecode(resp.body)];
  //   // print(jsonDecode(resp.body));
  //   // setState(() {
  //   //   for (var i = 0; i < _getsubsystem1.length; i++) {
  //   //     subsystemname1.add(_getsubsystem1[i]['name'].toString());
  //   //     subsystemid1.add(_getsubsystem1[i]['id'].toString());
  //   //     // print(newdata);
  //   //   }
  //   // });
  // }

  Future<void> _location() async {
    var resp = await http.get(Uri.parse(url + "/location/get"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    _getlocation = [...jsonDecode(resp.body)];
    setState(() {
      for (var i = 0; i < _getlocation.length; i++) {
        locationname.add(_getlocation[i]['name'].toString());
        locationid.add(_getlocation[i]['id'].toString());
      }
    });
  }

  Future<void> _system(String a) async {
    var resp = await http
        .get(Uri.parse(url + "/system/ajax/" + a.toString()), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    _getsystem = [...jsonDecode(resp.body)];
    // print(jsonDecode(resp.body));
    setState(() {
      for (var i = 0; i < _getsystem.length; i++) {
        systemname.add(_getsystem[i]['name'].toString());
        systemid.add(_getsystem[i]['id'].toString());
      }
    });
  }

  Future<void> _equipment(String a) async {
    var resp = await http
        .get(Uri.parse(url + "/equipment/ajax/" + a.toString()), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    _getequipment = [...jsonDecode(resp.body)];
    setState(() {
      for (var i = 0; i < _getequipment.length; i++) {
        equipmentname.add(_getequipment[i]['name'].toString());
        equipmentid.add(_getequipment[i]['id'].toString());
      }
    });
  }

  Future<void> _funcequipmentid(String a) async {
    var resp = await http
        .get(Uri.parse(url + "/equipmentid/ajax/" + a.toString()), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    _getequipmentid = [...jsonDecode(resp.body)];
    setState(() {
      for (var i = 0; i < _getequipmentid.length; i++) {
        equipmentidname.add(_getequipmentid[i]['name'].toString());
        equipmentidid.add(_getequipmentid[i]['id'].toString());
      }
    });
  }

  TextEditingController subsystemnew = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Failure Register"),
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
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue[100]),
                    child: Column(
                      children: [
                        Center(
                          child: DropdownSearch<String>(
                            mode: Mode.BOTTOM_SHEET,
                            // showSelectedItem: true,
                            showSearchBox: true,
                            items: newdata,
                            label: "Work Order Number",
                            // hint: "country in menu mode",
                            onChanged: (value) {
                              setState(() {
                                WoNumber = value.toString();
                                print(WoNumber);
                              });
                            },
                            showClearButton: true,
                            // selectedItem: (){
                            //   print();
                            // },
                          ),
                        ),
                        Divider(),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: 'Title',
                            labelText: 'Title',
                          ),
                          onChanged: (value) {
                            setState(() {
                              title = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Email tidak boleh kosong';
                            title = value.toString();
                            return null;
                          },
                          // onSaved: (value) => title = value.toString()
                        ),
                        Divider(),
                        Center(
                          child: DropdownSearch<String>(
                            mode: Mode.BOTTOM_SHEET,
                            // showSelectedItem: true,
                            items: locationname,
                            label: "Select Location",
                            // hint: "country in menu mode",
                            showSearchBox: true,
                            onChanged: (value) {
                              setState(() {
                                int selectedint = locationname
                                    .indexWhere((item) => item == value);
                                location = locationid[selectedint];
                                print(location);
                              });
                            },
                            showClearButton: true,
                            // selectedItem: (){
                            //   print();
                            // },
                          ),
                        ),
                        Divider(),
                        Center(
                          child: DropdownSearch<String>(
                            mode: Mode.BOTTOM_SHEET,
                            // showSelectedItem: true,
                            items: areaname,
                            label: "Select Area",
                            // hint: "country in menu mode",
                            onChanged: (value) {
                              setState(() {
                                int selectedint = areaname
                                    .indexWhere((item) => item == value);
                                area = areaid[selectedint];
                                print(area);
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
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Delay (in Second)',
                            labelText: 'Delay (in Second)',
                          ),
                          onChanged: (value) {
                            setState(() {
                              delay = value.toString();
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Email tidak boleh kosong';
                            delay = value.toString();
                            return null;
                          },
                          // onSaved: (value) => title = value.toString()
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(left: 5, bottom: 1, top: 1),
                        //   // height: 30,
                        //   width: MediaQuery.of(context).size.width -
                        //       (MediaQuery.of(context).size.width / 10),
                        //   // color: Colors.white,
                        //   child: OutlinedButton(
                        //       child: Text(
                        //         initialdelay,
                        //       ),
                        //       onPressed: () {
                        //         showTimePicker(
                        //           context: context,
                        //           initialTime: selectedTime,
                        //           initialEntryMode: TimePickerEntryMode.input,
                        //           confirmText: "CONFIRM",
                        //           cancelText: "NOT NOW",
                        //           helpText: "BOOKING TIME",
                        //         ).then((value) {
                        //           if (value != null) {
                        //             setState(() {
                        //               delay = value
                        //                   .toString()
                        //                   .split('(')[1]
                        //                   .split(')')[0];
                        //               initialdelay = delay;
                        //               print(delay);
                        //             });
                        //           }
                        //         });
                        //       }),
                        // ),
                        Divider(),
                        Center(
                          child: DropdownSearch<String>(
                            mode: Mode.BOTTOM_SHEET,
                            // showSelectedItem: true,
                            items: departmentnamereport,
                            label: "Select report by",
                            showSearchBox: true,
                            // hint: "country in menu mode",
                            onChanged: (value) {
                              setState(() {
                                int selectedint = departmentnamereport
                                    .indexWhere((item) => item == value);
                                reportedby = departmentidreport[selectedint];
                                print(reportedby);
                                _system(reportedby);
                              });
                            },
                            showClearButton: true,
                            // selectedItem: (){
                            //   print();
                            // },
                          ),
                        ),
                        Divider(),
                        Center(
                          child: DropdownSearch<String>(
                            mode: Mode.BOTTOM_SHEET,
                            // showSelectedItem: true,
                            items: departmentname,
                            label: "Select Received by",
                            showSearchBox: true,
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
                            // selectedItem: (){
                            //   print();
                            // },
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
                        Container(
                          margin: EdgeInsets.only(left: 5, bottom: 1, top: 1),
                          // height: 30,
                          width: MediaQuery.of(context).size.width -
                              (MediaQuery.of(context).size.width / 10),
                          // color: Colors.white,
                          child: OutlinedButton(
                              child: Text(
                                initialfailuredate,
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
                                      failuredate =
                                          value.toString().split(' ')[0];
                                      initialfailuredate = failuredate;
                                      print(failuredate);
                                    });
                                  }
                                });
                              }),
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
                                initialfailuretime,
                              ),
                              onPressed: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: selectedTime,
                                  initialEntryMode: TimePickerEntryMode.input,
                                  confirmText: "CONFIRM",
                                  cancelText: "NOT NOW",
                                  helpText: "BOOKING TIME",
                                ).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      failuretime = value
                                          .toString()
                                          .split('(')[1]
                                          .split(')')[0];
                                      initialfailuretime = failuretime;
                                      print(failuretime);
                                    });
                                  }
                                });
                              }),
                        ),
                        Divider(),
                        Center(
                          child: DropdownSearch<String>(
                            mode: Mode.BOTTOM_SHEET,
                            // showSelectedItem: true,
                            items: systemname,
                            label: "Select System",
                            showSearchBox: true,
                            // hint: "country in menu mode",
                            onChanged: (value) {
                              setState(() {
                                int selectedint = systemname
                                    .indexWhere((item) => item == value);
                                system = systemid[selectedint];
                                print(system);
                                subsystemid1 = [];
                                subsystemname1 = [];
                                _subsystem1(system);
                              });
                            },
                            showClearButton: true,
                            // selectedItem: (){
                            //   print();
                            // },
                          ),
                        ),
                        Divider(),
                        // FailInputDropSubSys(
                        //   label: 'Subsystem',
                        //   content: 'Text',
                        //   control: subsystemnew,
                        // ),
                        Center(
                          child: DropdownSearch<String>(
                            mode: Mode.BOTTOM_SHEET,
                            // showSelectedItem: true,
                            items: subsystemname1,
                            showSearchBox: true,
                            label: "Select Sub System",
                            // hint: "country in menu mode",
                            onChanged: (value) {
                              setState(() {
                                int selectedint = subsystemname1
                                    .indexWhere((item) => item == value);
                                subsystem = subsystemid1[selectedint];
                                print(subsystem);
                                equipmentid = [];
                                equipmentname = [];
                                _equipment(subsystem);
                              });
                            },
                            showClearButton: true,
                            // selectedItem: (){
                            //   print();
                            // },
                          ),
                        ),
                        Divider(),
                        Center(
                          child: DropdownSearch<String>(
                            mode: Mode.BOTTOM_SHEET,
                            // showSelectedItem: true,
                            items: equipmentname,
                            label: "Select Equipment",
                            showSearchBox: true,
                            // hint: "country in menu mode",
                            onChanged: (value) {
                              setState(() {
                                int selectedint = equipmentname
                                    .indexWhere((item) => item == value);
                                equipment = equipmentid[selectedint];
                                print(equipment);
                                equipmentidid = [];
                                equipmentidname = [];
                                _funcequipmentid(equipment);
                              });
                            },
                            showClearButton: true,
                            // selectedItem: (){
                            //   print();
                            // },
                          ),
                        ),
                        Divider(),
                        Center(
                          child: DropdownSearch<String>(
                            mode: Mode.BOTTOM_SHEET,
                            // showSelectedItem: true,
                            items: equipmentidname,
                            showSearchBox: true,
                            label: "Select Equipment ID",
                            // hint: "country in menu mode",
                            onChanged: (value) {
                              setState(() {
                                int selectedint = equipmentidname
                                    .indexWhere((item) => item == value);
                                equipment_id = equipmentidid[selectedint];
                                print(equipment_id);
                              });
                            },
                            showClearButton: true,
                            // selectedItem: (){
                            //   print();
                            // },
                          ),
                        ),
                        Divider(),
                        Center(
                          child: DropdownSearch<String>(
                            mode: Mode.BOTTOM_SHEET,
                            // showSelectedItem: true,
                            items: trainsetname,
                            showSearchBox: true,
                            label: "Select Trainset",
                            // hint: "country in menu mode",
                            onChanged: (value) {
                              setState(() {
                                int selectedint = trainsetname
                                    .indexWhere((item) => item == value);
                                trainset = trainsetid[selectedint];
                                print(trainset);
                              });
                            },
                            showClearButton: true,
                          ),
                        ),
                        Divider(),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Failure Description and Effect ',
                          ),
                          onChanged: (value) {
                            setState(() {
                              description = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Failure Description and Effect tidak boleh kosong';
                            setState(() {
                              description = value;
                            });
                            // description = value;
                            return null;
                          },
                        ),
                        Divider(),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Mitigration Action By Report',
                          ),
                          onChanged: (value) {
                            setState(() {
                              mitigation = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Mitigration Action By Report cant be empty';
                            setState(() {
                              mitigation = value;
                            });
                            return null;
                          },
                        ),
                        Divider(),
                        Container(
                          margin: EdgeInsets.only(left: 5, bottom: 1, top: 1),
                          // height: 30,
                          width: MediaQuery.of(context).size.width -
                              (MediaQuery.of(context).size.width / 10),
                          // color: Colors.white,
                          child: OutlinedButton(
                            child: Text('Attach File'),
                            onPressed: _openFileExplorer,
                          ),
                        ),
                        Divider(),
                        // ElevatedButton(
                        //     onPressed: _openFileExplorer,
                        //     child: Text('Open File Explorer')),
                        // Divider(),
                        ElevatedButton(
                            child: const Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                            style:
                                ElevatedButton.styleFrom(primary: Colors.blue),
                            onPressed: () async {
                              print('wo :' + WoNumber);
                              print('title :' + title);
                              print('location :' + location);
                              print('area :' + area);
                              print('delay :' + delay);
                              print('reportbydeparment :' + reportedby);
                              print('receivedby :' + receivedby);
                              print('reportdate :' + reportdate);
                              print('failuredate :' + failuredate);
                              print('failuretime :' + failuretime);
                              print('system :' + system);
                              print('subsystem :' + subsystem);
                              print('equipment :' + equipment);
                              print('equipment_id :' + equipment_id);
                              print('trainset :' + trainset);
                              print('description :' + description);
                              print('mitigation :' + mitigation);
                              print('upload :' + upload);

                              if (WoNumber == '' ||
                                  title == '' ||
                                  location == '' ||
                                  area == '' ||
                                  delay == '' ||
                                  reportedby == '' ||
                                  receivedby == '' ||
                                  reportdate == '' ||
                                  failuredate == '' ||
                                  failuretime == '' ||
                                  system == '' ||
                                  subsystem == '' ||
                                  equipment == '' ||
                                  equipment_id == '' ||
                                  trainset == '' ||
                                  description == '' ||
                                  mitigation == '') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Please fill all the fields'),
                                ));
                              } else {
                                await _failureopenadd(
                                    WoNumber,
                                    title,
                                    location,
                                    area,
                                    delay,
                                    reportedby,
                                    receivedby,
                                    reportdate,
                                    failuredate,
                                    failuretime,
                                    system,
                                    subsystem,
                                    equipment,
                                    equipment_id,
                                    trainset,
                                    description,
                                    mitigation,
                                    _files!.first.path.toString()
                                    //upload,
                                    // note,
                                    // qty,
                                    // unit,
                                    );
                              }
                            })
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
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
