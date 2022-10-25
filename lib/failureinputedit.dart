import 'package:flutter/material.dart';
import 'package:mrt/NavDrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:mrt/utils/secure_storage.dart';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'globals.dart' as globals;

class failureinputedit extends StatefulWidget {
  static const String routeName = '/failureinputedit';

  @override
  State<failureinputedit> createState() => _failureinputeditState();
}

class _failureinputeditState extends State<failureinputedit> {
  final _formKey = GlobalKey<FormState>();

  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  // final String url = 'https://karyaku.id/mrtjakarta/public/api';

  List<dynamic> _getmateriallist = [];
  List<dynamic> _getrectifiertable = [];
  List<dynamic> _getunit = [];
  List<String> unitname = [];
  List<String> unitid = [];
  String selectunit = '';
  List<dynamic> _getmaterialtabel = [];
  // List<String> materialname = [];
  // List<String> materialid = [];
  List<dynamic> _getmaterial = [];
  List<String> materialname = [];
  List<String> materialid = [];
  String selectmaterial = '';
  int indexworkordertemp = 1;
  int indexareatemp = 1;
  int indexlocationtemp = 1;
  int indexdepartmenttemp = 1;
  int indexreceivedepartmenttemp = 1;
  int indexsystemtemp = 1;
  int indexsystem_subtemp = 1;
  int indexequipmenttemp = 1;
  int indexequipmentidtemp = 1;
  int indextrainsettemp = 1;
  // int indexfailure_descriptiontemp = 1;
  // int indexmitigrationtemp = 1;
  String pic = '';
  String result = '';
  String step = '';

  String datereq = '';
  String timereq = '';
  String qtymaterial = '';
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
  String title = globals.titletemp;
  String location = globals.locationtemp;
  String area = globals.areatemp.toString();
  String delay = globals.delaytemp;
  String reportedby = globals.reportdepartmenttemp.toString();
  String receivedby = globals.receivedepartmenttemp.toString();
  String failuredate = globals.failure_datetemp;
  String failuretime = globals.failure_timetemp;
  String reportdate = globals.report_datetemp;
  String system = globals.systemtemp.toString();
  String subsystem = globals.system_subtemp.toString();
  String equipment = globals.equipmenttemp.toString();
  String equipment_id = globals.equipment_idtemp.toString();
  String trainset = globals.trainsettemp.toString();
  String description = globals.failure_descriptiontemp;
  String mitigation = globals.report_actiontemp;
  String upload = '';
  String item = '';
  int qty = 1;
  int unit = 1;
  String WoNumber = globals.workorder_notemp;
  int status = 1;
  String note = '';
  String initialreportdate = globals.report_datetemp;
  String initialfailuredate = globals.failure_datetemp;
  String initialfailuretime = globals.failure_timetemp;
  String initialdelay = globals.delaytemp;
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

    _area();
    _WoNumber();
    _subsystem1();
    _trainsetfunc();
    _location();
    _department();
    _system();
    _equipment();
    _funcequipmentid();
    _material();
    _unit();
    _rectifiertabel();
    _materiltabel();
    print('globaltitle  = ' + title);
    print('indexarea  = ' + indexareatemp.toString());
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

  Future<void> _deletematerialdispatched(String a) async {
    var headers = {'Authorization': 'Bearer ' + _tokenJwt, 'Cookie': _cookies};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/failureopen/status/7/' +
                a.toString()));
    request.fields.addAll({});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => failureinputedit()));
  }

  Future<void> _deletrectification(String a) async {
    var headers = {'Authorization': 'Bearer ' + _tokenJwt, 'Cookie': _cookies};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/failureopen/status/8/' +
                a.toString()));
    request.fields.addAll({});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => failureinputedit()));
  }

  Future<void> _rectifiertabel() async {
    var resp = await http.get(
        Uri.parse(url +
            "/failureopen/get/2/" +
            globals.failureexecuteidtemp.toString()),
        headers: {
          'Cookie': _cookies,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _tokenJwt
        });
    setState(() {
      _getrectifiertable = [...jsonDecode(resp.body)];
      print(jsonDecode(resp.body));
    });
  }

  Future<void> _material() async {
    var resp = await http.get(Uri.parse(url + "/material/get"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    _getmaterial = [...jsonDecode(resp.body)];
    // print('object' + _getmaterial.toString());
    setState(() {
      for (var i = 0; i < _getmaterial.length; i++) {
        materialname.add(_getmaterial[i]['name'].toString());
        materialid.add(_getmaterial[i]['id'].toString());
      }
    });
  }

  Future<void> _addmateriallist() async {
    var headers = {
      'Authorization': 'Bearer ' + _tokenJwt,
      'Cookie': _cookies,
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/failureopen/save/1/' +
                globals.failureexecuteidtemp.toString()));
    request.fields.addAll({
      'material-detail': selectmaterial.toString(),
      'unit-detail': selectunit.toString(),
      'quantity-detail': qtymaterial.toString(),
      'workorder-detail': WoNumber.toString(),
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String data = await response.stream.bytesToString();
      if (jsonDecode(data)['success'].toString() == 'false') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonDecode(data)['errorMsg'].toString()),
        ));
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => failureinputedit()));
      }
      // print();
    } else {
      print(response.reasonPhrase);
    }

    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => failureinputedit()));
  }

  Future<void> _addrectification() async {
    print({
      'rectification_title': step.toString(),
      'rectification_description': result.toString(),
      'rectification_user': pic.toString(),
      'rectification_date': datereq.toString(),
      'rectification_time': timereq.toString()
    });
    var headers = {
      'Authorization': 'Bearer ' + _tokenJwt,
      'Cookie': _cookies,
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/failureopen/save/2/' +
                globals.failureexecuteidtemp));
    request.fields.addAll({
      'rectification_title': step.toString(),
      'rectification_description': result.toString(),
      'rectification_user': pic.toString(),
      'rectification_date': datereq.toString(),
      'rectification_time': timereq.toString()
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String data = await response.stream.bytesToString();
      String data2 = jsonDecode(data)['success'].toString();

      step == '';
      result == '';
      pic == '';
      datereq == '';
      timereq == '';
    } else {
      print(response.reasonPhrase);
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => failureinputedit()));
  }

  Future<void> _subsystem1() async {
    print('masuksubsystem external');
    print('token: ' + _tokenJwt[0]);
    print('tokenasds: ' + _cookies);
    var resp = await http.get(
        Uri.parse('http://147.139.134.143/mrtjakarta/public/api/systemsub/get'),
        headers: {
          'Cookie': _cookies,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _tokenJwt
        });
    // print(resp.body);
    _getsubsystem1 = [...jsonDecode(resp.body)];
    // print(jsonDecode(resp.body));
    setState(() {
      for (var i = 0; i < _getsubsystem1.length; i++) {
        subsystemname1.add(_getsubsystem1[i]['name'].toString());
        subsystemid1.add(_getsubsystem1[i]['id'].toString());
        // print(newdata);
        if (_getsubsystem1[i]['id'].toString() ==
            globals.system_subtemp.toString()) {
          indexsystem_subtemp = i;
          print('ketemu' + indexsystem_subtemp.toString());
          break;
        }
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
    print({
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
    var headers = {
      'Authorization': 'Bearer ' + _tokenJwt,
      'Cookie': _cookies,
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/failureopen/save/' +
                globals.failureexecuteidtemp.toString()));
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
      // print(await response.stream.bytesToString());
      String data = await response.stream.bytesToString();
      String data2 = data.split('"')[9];
      print(data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(data2.toString()),
      ));
    } else {
      print(response.reasonPhrase);
    }

    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => failureinput()));
  }

  Future<void> _materiltabel() async {
    var resp = await http.get(
        Uri.parse(url +
            "/failureopen/get/1/" +
            globals.failureexecuteidtemp.toString()),
        headers: {
          'Cookie': _cookies,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _tokenJwt
        });
    _getmaterialtabel = [...jsonDecode(resp.body)];
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
    for (var i = 0; i < _getdepartment.length; i++) {
      if (_getdepartment[i]['id'].toString() ==
          globals.receivedepartmenttemp.toString()) {
        indexdepartmenttemp = i;
        print('ketemu' + indexdepartmenttemp.toString());
      }
      if (_getdepartment[i]['id'].toString() ==
          globals.receivedepartmenttemp.toString()) {
        indexreceivedepartmenttemp = i;
        print('ketemu' + indexreceivedepartmenttemp.toString());
      }
    }
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
        if (_gettrainset[i]['id'].toString() ==
            globals.trainsettemp.toString()) {
          indextrainsettemp = i;
          print('ketemu' + indextrainsettemp.toString());
        }
      }
    });
    // for (var i = 0; i < _gettrainset.length; i++) {

    // }
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
        if (_getarea[i]['id'].toString() == globals.areatemp.toString()) {
          indexareatemp = i;
          print('ketemu');
          // break;
        }
      }

      // for (var i = 0; i < _getarea.length; i++) {
      //   // print('cari index' + globals.areatemp.toString());
      //   // print(areaid[i]);

      // }
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
        newdata.add(_getwonumber[i]['workorder_no'].toString());
        newdataid.add(_getwonumber[i]['id'].toString());
        if (_getwonumber[i]['id'].toString() ==
            globals.workorder_notemp.toString()) {
          indexworkordertemp = i;
          print('ketemu' + indexworkordertemp.toString());
        }
      }
    });
    // for (var i = 0; i < _getwonumber.length; i++) {

    // }
  }

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
        if (_getlocation[i]['id'].toString() ==
            globals.locationtemp.toString()) {
          indexlocationtemp = i;
          print('ketemu' + indexlocationtemp.toString());
          // break;
        }
      }
    });
    // for (var i = 0; i < _getlocation.length; i++) {

    // }
  }

  Future<void> _system() async {
    var resp = await http.get(Uri.parse(url + "/system/get"), headers: {
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
        if (_getsystem[i]['id'].toString() == globals.systemtemp.toString()) {
          indexsystemtemp = i;
          print('ketemu' + indexsystemtemp.toString());
        }
      }
    });
    // for (var i = 0; i < _getsystem.length; i++) {

    // }
  }

  Future<void> _equipment() async {
    var resp = await http.get(Uri.parse(url + "/equipment/get"), headers: {
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
        if (_getequipment[i]['id'].toString() ==
            globals.equipmenttemp.toString()) {
          indexequipmenttemp = i;
          print('ketemu' + indexequipmenttemp.toString());
        }
      }
    });
    // for (var i = 0; i < _getequipment.length; i++) {

    // }
  }

  Future<void> _unit() async {
    var resp = await http.get(Uri.parse(url + "/unit/get"), headers: {
      'Cookie': _cookies,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    _getunit = [...jsonDecode(resp.body)];
    // print(resp.body);
    setState(() {
      for (var i = 0; i < _getunit.length; i++) {
        unitname.add(_getunit[i]['name'].toString());
        unitid.add(_getunit[i]['id'].toString());
      }
    });
  }

  Future<void> _funcequipmentid() async {
    var resp = await http.get(Uri.parse(url + "/equipmentid/get"), headers: {
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
        if (_getequipmentid[i]['id'].toString() ==
            globals.equipment_idtemp.toString()) {
          indexequipmentidtemp = i;
          print('ketemu' + indexequipmentidtemp.toString());
        }
      }
    });
    // for (var i = 0; i < _getequipmentid.length; i++) {

    // }
  }

  TextEditingController subsystemnew = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Failure Input Edit"),
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
                    height: 1400.0 + 20.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue[100]),
                    child: Column(
                      children: [
                        Center(
                          child: DropdownSearch<String>(
                            mode: Mode.BOTTOM_SHEET,
                            // showSelectedItem: true,
                            items: newdata,
                            selectedItem: newdata[indexworkordertemp],

                            label: "Work Order Number",
                            // hint: "country in menu mode",
                            showSearchBox: true,
                            onChanged: (value) {
                              setState(() {
                                int selectedint =
                                    newdata.indexWhere((item) => item == value);
                                WoNumber = newdataid[selectedint];
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
                          initialValue: title,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: 'Title',
                            labelText: 'Title',
                          ),
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
                            showSearchBox: true,
                            selectedItem: locationname[indexlocationtemp],
                            // hint: "country in menu mode",
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
                            showSearchBox: true,
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
                            selectedItem: areaname[indexareatemp],
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
                              return 'Delay tidak boleh kosong';
                            delay = value.toString();
                            return null;
                          },
                          // onSaved: (value) => title = value.toString()
                        ),
                        // Divider(),
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
                            items: departmentname,
                            showSearchBox: true,
                            selectedItem: departmentname[indexdepartmenttemp],
                            label: "Select report by",
                            // hint: "country in menu mode",
                            onChanged: (value) {
                              setState(() {
                                int selectedint = departmentname
                                    .indexWhere((item) => item == value);
                                reportedby = departmentid[selectedint];
                                print(reportedby);
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
                            showSearchBox: true,
                            selectedItem:
                                departmentname[indexreceivedepartmenttemp],
                            label: "Select Received by",
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
                            // hint: "country in menu mode",
                            showSearchBox: true,
                            selectedItem: systemname[indexsystemtemp],
                            onChanged: (value) {
                              setState(() {
                                int selectedint = systemname
                                    .indexWhere((item) => item == value);
                                system = systemid[selectedint];
                                print(system);
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
                            label: "Select Sub System",
                            showSearchBox: true,
                            selectedItem: subsystemname1[indexsystem_subtemp],
                            // hint: "country in menu mode",
                            onChanged: (value) {
                              setState(() {
                                int selectedint = subsystemname1
                                    .indexWhere((item) => item == value);
                                subsystem = subsystemid1[selectedint];
                                print(subsystem);
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
                            showSearchBox: true,
                            label: "Select Equipment",
                            selectedItem: equipmentname[indexequipmenttemp],
                            // hint: "country in menu mode",
                            onChanged: (value) {
                              setState(() {
                                int selectedint = equipmentname
                                    .indexWhere((item) => item == value);
                                equipment = equipmentid[selectedint];
                                print(equipment);
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
                            selectedItem: equipmentidname[indexequipmentidtemp],
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
                            label: "Select Trainset",
                            // hint: "country in menu mode",
                            showSearchBox: true,
                            selectedItem: trainsetname[indextrainsettemp],
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
                          initialValue: description,
                          decoration: const InputDecoration(
                            labelText: 'Failure Description and Effect ',
                          ),
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
                          initialValue: mitigation,
                          decoration: const InputDecoration(
                            labelText: 'Mitigration Action By Report',
                          ),
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Mitigration Action By Report tidak boleh kosong';
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
                        ElevatedButton(
                            child: const Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                            style:
                                ElevatedButton.styleFrom(primary: Colors.blue),
                            onPressed: () async {
                              // print('wo :' + WoNumber);
                              // print('title :' + title);
                              // print('location :' + location);
                              // print('area :' + area);
                              // print('delay :' + delay);
                              // print('reportbydeparment :' + reportedby);
                              // print('receivedby :' + receivedby);
                              // print('reportdate :' + reportdate);
                              // print('failuredate :' + failuredate);
                              // print('failuretime :' + failuretime);
                              // print('system :' + system);
                              // print('subsystem :' + subsystem);
                              // print('equipment :' + equipment);
                              // print('equipment_id :' + equipment_id);
                              // print('trainset :' + trainset);
                              // print('description :' + description);
                              // print('mitigation :' + mitigation);
                              // print('upload :' + upload);

                              if (_formKey.currentState!.validate()) {
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
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => failureinputedit()));
                            }),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: _getmaterialtabel.length * 100 + 470,
                // height: (_getchecksheettabel.length) * 150 + 500,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                    width: 3,
                  ),
                ),
                child: Column(
                  // mainAxisSize: MainAxisSi
                  // ze.max,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      child: Text(
                        'Equipment ID',
                        style: _contentStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(10),
                          // border: Border.all(
                          //   width: 3,
                          // ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: Center(
                            child: DropdownSearch<String>(
                              mode: Mode.BOTTOM_SHEET,
                              // showSelectedItem: true,
                              items: materialname,
                              label: "Material",
                              showSearchBox: true,
                              // hint: "country in menu mode",
                              onChanged: (value) {
                                setState(() {
                                  int indextools = materialname
                                      .indexWhere((item) => item == value);
                                  selectmaterial = materialid[indextools];
                                  print(selectmaterial);
                                });
                              },
                              showClearButton: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(10),
                          // border: Border.all(
                          //   width: 3,
                          // ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: Center(
                            child: TextFormField(
                              // initialValue: title,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                setState(() {
                                  qtymaterial = value.toString();
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: 'Quantity',
                                labelText: 'Quantity',
                              ),
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'PIC tidak boleh kosong';
                                qtymaterial = value.toString();
                                return null;
                              },
                              // onSaved: (value) => title = value.toString()
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(10),
                          // border: Border.all(
                          //   width: 3,
                          // ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: Center(
                            child: DropdownSearch<String>(
                              mode: Mode.BOTTOM_SHEET,
                              // showSelectedItem: true,
                              items: unitname,
                              label: "Unit",
                              showSearchBox: true,
                              // hint: "country in menu mode",
                              onChanged: (value) {
                                setState(() {
                                  int indextools = unitname
                                      .indexWhere((item) => item == value);
                                  selectunit = unitid[indextools];
                                  print(selectunit);
                                });
                              },
                              showClearButton: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(10),
                          // border: Border.all(
                          //   width: 3,
                          // ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: Center(
                            child: DropdownSearch<String>(
                              mode: Mode.BOTTOM_SHEET,
                              // showSelectedItem: true,
                              items: newdata,
                              showSearchBox: true,
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
                        ),
                      ),
                    ),
                    Divider(),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(top: 5, right: 5, bottom: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton.icon(
                            onPressed: () {
                              _addmateriallist();
                            },
                            icon: Icon(
                              Icons.add_circle,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Add',
                              style: _headerStyle,
                            ),
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                        child: Column(children: [
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _getmaterialtabel.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                String indexnum =
                                    _getmaterialtabel[index]['id'].toString();

                                print(indexnum);
                                // indexnum = _userGetdata[index]['id'].toString();
                                // print(_getfailure[index]['id'].toString());
                                // showDialog(
                                //   context: context,
                                //   builder: (BuildContext context) =>
                                //       _buildPopupDialog(context,
                                //           _getfailure[index]['id'].toString()),
                                // );
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      new AlertDialog(
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
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  FlatButton.icon(
                                                    onPressed: () {
                                                      // _deleteequipmentid(
                                                      //     indexnum);
                                                      _deletematerialdispatched(
                                                          indexnum);
                                                    },
                                                    icon: Icon(
                                                      Icons.recycling,
                                                      color:
                                                          HexColor('#FFC107'),
                                                    ),
                                                    label: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                    color: HexColor('#343A40'),
                                                    shape:
                                                        RoundedRectangleBorder(
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
                                                                  failureinputedit()));
                                                    },
                                                    icon: Icon(
                                                      Icons.autorenew_sharp,
                                                      color:
                                                          HexColor('#17A2B8'),
                                                    ),
                                                    label: Text(
                                                      'RELOAD',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                    color: HexColor('#343A40'),
                                                    shape:
                                                        RoundedRectangleBorder(
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
                              },
                              child: Card(
                                  elevation: 8,
                                  child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Item ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  'Quantity ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  'Unit ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  'Wo Number ',
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
                                                      _getmaterialtabel[index]
                                                              ['materialname']
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  ' : ' +
                                                      _getmaterialtabel[index]
                                                              ['quantity']
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  ' : ' +
                                                      _getmaterialtabel[index]
                                                              ['unitname']
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  ' : ' +
                                                      _getmaterialtabel[index]
                                                              ['workorder_no']
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ]),
                                        ],
                                      ))),
                            );
                          })
                    ])),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: _getrectifiertable.length * 150 + 480,
                // height: (_getchecksheettabel.length) * 150 + 500,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                    width: 3,
                  ),
                ),
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      child: Text(
                        'Rectification',
                        style: _contentStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(10),
                          // border: Border.all(
                          //   width: 3,
                          // ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: Center(
                            child: TextFormField(
                              // initialValue: title,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                setState(() {
                                  step = value.toString();
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: 'Langkah Perbaikan',
                                labelText: 'Langkah Perbaikan',
                              ),
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Langkah Perbaikan tidak boleh kosong';
                                step = value.toString();
                                return null;
                              },
                              // onSaved: (value) => title = value.toString()
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(10),
                          // border: Border.all(
                          //   width: 3,
                          // ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: Center(
                            child: TextFormField(
                              // initialValue: title,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                setState(() {
                                  result = value.toString();
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: 'Hasil Perbaikan',
                                labelText: 'Hasil Perbaikan',
                              ),
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Hasil Perbaikan tidak boleh kosong';
                                result = value.toString();
                                return null;
                              },
                              // onSaved: (value) => title = value.toString()
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(10),
                          // border: Border.all(
                          //   width: 3,
                          // ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: Center(
                            child: TextFormField(
                              // initialValue: title,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                setState(() {
                                  pic = value.toString();
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: 'PIC',
                                labelText: 'PIC',
                              ),
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'PIC tidak boleh kosong';
                                pic = value.toString();
                                return null;
                              },
                              // onSaved: (value) => title = value.toString()
                            ),
                          ),
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
                                  datereq = value.toString().split(' ')[0];
                                  print(datereq);
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
                                  timereq = value
                                      .toString()
                                      .split('(')[1]
                                      .split(')')[0];
                                  print(timereq);
                                });
                              }
                            });
                          }),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(top: 5, right: 5, bottom: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton.icon(
                            onPressed: () {
                              if (step == '' ||
                                  result == '' ||
                                  pic == '' ||
                                  datereq == '' ||
                                  timereq == '') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Please fill all the fields"),
                                ));
                              } else {
                                _addrectification();
                              }
                            },
                            icon: Icon(
                              Icons.add_circle,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Add',
                              style: _headerStyle,
                            ),
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                        child: Column(children: [
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _getrectifiertable.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                String indexnum =
                                    _getrectifiertable[index]['id'].toString();

                                print(indexnum);
                                // indexnum = _userGetdata[index]['id'].toString();
                                // print(_getfailure[index]['id'].toString());
                                // showDialog(
                                //   context: context,
                                //   builder: (BuildContext context) =>
                                //       _buildPopupDialog(context,
                                //           _getfailure[index]['id'].toString()),
                                // );
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
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  FlatButton.icon(
                                                    onPressed: () {
                                                      _deletrectification(
                                                          indexnum);
                                                    },
                                                    icon: Icon(
                                                      Icons.recycling,
                                                      color:
                                                          HexColor('#FFC107'),
                                                    ),
                                                    label: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                    color: HexColor('#343A40'),
                                                    shape:
                                                        RoundedRectangleBorder(
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
                                                                  failureinputedit()));
                                                    },
                                                    icon: Icon(
                                                      Icons.autorenew_sharp,
                                                      color:
                                                          HexColor('#17A2B8'),
                                                    ),
                                                    label: Text(
                                                      'RELOAD',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                    color: HexColor('#343A40'),
                                                    shape:
                                                        RoundedRectangleBorder(
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
                              },
                              child: Card(
                                  elevation: 8,
                                  child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Langkah Perbaikan ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  'Hasil Perbaikan ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  'PIC ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  'Date ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  'Time ',
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
                                                      _getrectifiertable[index][
                                                          'rectification_title'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  ' : ' +
                                                      _getrectifiertable[index][
                                                          'rectification_description'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  ' : ' +
                                                      _getrectifiertable[index][
                                                          'rectification_user'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  ' : ' +
                                                      _getrectifiertable[index][
                                                          'rectification_date'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  ' : ' +
                                                      _getrectifiertable[index][
                                                          'rectification_time'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ]),
                                        ],
                                      ))),
                            );
                          })
                    ])),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: NavDrawer(),
    );
  }
}
