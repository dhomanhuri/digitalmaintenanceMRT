import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mrt/inputchecksheetedit.dart';
import 'package:mrt/widget/button_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mrt/NavDrawer.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:mrt/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:snippet_coder_utils/hex_color.dart';
import 'globals.dart' as globals;

class executewo extends StatefulWidget {
  static const String routeName = '/executewo';

  @override
  State<executewo> createState() => _executewoState();
}

class _executewoState extends State<executewo> {
  final _headerStyle = const TextStyle(
      color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold);
  final _contentStyleHeader = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700);
  final _contentStyle = const TextStyle(
      color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold);
  final _formKey = GlobalKey<FormState>();
  String wonumber2 = globals.wonumberexecutetemp;

  bool equipmentisselect = false;
  String selectsystem = '';
  String selectsubsystem = '';
  String selectequipment = '';
  String selectequipmentid = '';
  String selectperiod = '';

  int selectnameequipmentid = 0;
  List<dynamic> _getwonumber = [];
  List<dynamic> _userget = [];
  String deparmtent2 = '';
  String sectiononduty2 = '';
  String techniciane2 = '';
  String starttime2 = '';
  String endtime2 = '';
  String? selected;
  int selectedint = 0;
  String _tokenJwt = '';
  String _cookie = '';
  bool showSelectedItem = true;
  String wonumber3 = '';

  String initialStartdate = 'Start Date';
  String initialEnddate = 'End Date';
  String initializesectioni = '';
  String initializeworkorder = '';

  List<dynamic> _getinputchecksheettabel = [];
  List<String> inputchecksheetnametabel = [];
  List<String> inputchecksheetidtabel = [];
  List<dynamic> _getmaterialtabel = [];
  List<String> materialnametabel = [];
  List<String> materialidtabel = [];
  List<dynamic> _getchecksheettabel = [];
  List<String> checksheetnametabel = [];
  List<String> checksheetidtabel = [];
  List<dynamic> _gettoolstabel = [];
  List<String> toolsnametabel = [];
  List<String> toolsidtabel = [];
  List<String> newdataint = [];
  List<String> username = [];
  List<String> userid = [];
  List<String> newdata = [];
  List<String> newdataid = [];
  List<dynamic> _getdepartment = [];
  List<String> newDepartment = [];
  List<String> newDepartmentid = [];
  List<dynamic> _getmaterial = [];
  List<String> materialname = [];
  List<String> materialid = [];
  String selectmaterial = '';
  String initializedepartment = '';
  List<String> toolsname = [];
  List<String> toolsid = [];
  String selecttools = '';
  List<dynamic> _getsystem = [];
  List<String> systemname = [];
  List<String> systemid = [];
  List<dynamic> _getperiod = [];
  List<String> periodname = [];
  List<String> periodid = [];
  List<dynamic> _getsubsystem1 = [];
  List<String> subsystemname1 = [];
  List<String> subsystemid1 = [];
  List<dynamic> _getequipment = [];
  List<String> equipmentname = [];
  List<String> equipmentid = [];
  List<dynamic> _getequipmentid = [];
  List<String> equipmentidname = [];
  List<String> equipmentidid = [];

  String qrselect = '';
  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  void initState() {
    super.initState();
    init();
  }

  String qrCode = 'Unknown';
  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        this.qrCode = qrCode;
        print('qr ' + qrCode);
        int indextools = equipmentidname.indexWhere((item) => item == qrCode);
        selectequipmentid = equipmentidid[indextools];
        print(selectequipmentid);

        selectnameequipmentid = indextools;
        // equipmentidid = [];
        _ajaxequipment(selectequipmentid.toString(), qrCode.toString());
      });
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }

  void init() async {
    String _token = await SecureStorage.getToken();
    String _cookies = await SecureStorage.getCookie();
    setState(() {
      _tokenJwt = _token;
      _cookie = _cookies;
    });
    _preventiveopen();
    _WoNumber();
    newDepartment = [];
    newDepartmentid = [];
    _department(wonumber2);
    _materialtabel();
    _tools();
    _material();
    _equipmentid();
    _funcequipmentid('nothing');
    _period();
    _checksheettabel();
    _inputchecksheettabel();

    _funcequipmentid(selectequipment);
  }

  Future<void> _deletetoolspreventive(String a) async {
    var headers = {
      'Authorization': 'Bearer ' + _tokenJwt,
      'Cookie': _cookie,
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/preventiveopen/delete/1/' +
                a.toString()));
    request.fields.addAll({});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }

    Navigator.of(context).pop();
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => executewo()));
  }

  Future<void> _deletematerialspreventive(String a) async {
    var headers = {
      'Authorization': 'Bearer ' + _tokenJwt,
      'Cookie': _cookie,
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/preventiveopen/delete/2/' +
                a.toString()));
    request.fields.addAll({});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }

    Navigator.of(context).pop();
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => executewo()));
  }

  Future<void> _addMaterial() async {
    var headers = {
      'Authorization': 'Bearer ' + _tokenJwt,
      'Cookie': _cookie,
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/preventiveopen/save/2/' +
                globals.woexecuteidtemp.toString()));
    request.fields.addAll({
      'material': selectmaterial,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String databack = await response.stream.bytesToString();
      if (json.decode(databack)!['success'] == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(json.decode(databack)!['errorMsg']),
        ));
      } else {
        selectmaterial = '';
        Navigator.of(context).pop();
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => executewo()));
      }
    } else {
      print(response.reasonPhrase);
    }
    // selectmaterial = '';
    // Navigator.of(context).pop();
    // Navigator.of(context).push(
    //     MaterialPageRoute(builder: (BuildContext context) => executewo()));
  }

  Future<void> _addequipmentid() async {
    var headers = {'Authorization': 'Bearer ' + _tokenJwt, 'Cookie': _cookie};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/preventiveopen/save/3/' +
                globals.woexecuteidtemp.toString()));
    request.fields.addAll({
      'system': selectsystem,
      'system_sub': selectsubsystem,
      'equipment': selectequipment,
      'equipment_id': selectequipmentid,
      'period': selectperiod,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String databack = await response.stream.bytesToString();
      if (json.decode(databack)!['success'] == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(json.decode(databack)!['errorMsg']),
        ));
      } else {
        selectequipmentid = '';
        selectequipment = '';
        selectsystem = '';
        selectsubsystem = '';
        Navigator.of(context).pop();
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => executewo()));
      }
    } else {
      print(response.reasonPhrase);
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => executewo()));
    // Navigator.of(context).pop();
    // Navigator.of(context).push(
    //     MaterialPageRoute(builder: (BuildContext context) => executewo()));
  }

  Future<void> _addTools() async {
    var headers = {
      'Authorization': 'Bearer ' + _tokenJwt,
      'Cookie': _cookie,
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/preventiveopen/save/1/' +
                globals.woexecuteidtemp.toString()));
    request.fields.addAll({
      'tools': selecttools,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String databack = await response.stream.bytesToString();
      if (json.decode(databack)!['success'] == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(json.decode(databack)!['errorMsg']),
        ));
      } else {
        selecttools = '';
        Navigator.of(context).pop();
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => executewo()));
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> _checksheettabel() async {
    var resp = await http.get(
        Uri.parse(url +
            "/preventiveopen/get/3/" +
            globals.woexecuteidtemp.toString()),
        headers: {
          'Cookie': _cookie,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _tokenJwt
        });
    setState(() {
      _getchecksheettabel = [...jsonDecode(resp.body)];
    });
  }

  Future<void> _inputchecksheettabel() async {
    var resp = await http.get(
        Uri.parse(url +
            "/preventiveopen/get/4/" +
            globals.woexecuteidtemp.toString()),
        headers: {
          'Cookie': _cookie,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _tokenJwt
        });
    setState(() {
      _getinputchecksheettabel = [...jsonDecode(resp.body)];
    });
  }

  Future<void> _period() async {
    print('masuksubsystem external');
    var resp = await http.get(
        Uri.parse('http://147.139.134.143/mrtjakarta/public/api/period/get'),
        headers: {
          'Cookie': _cookie,
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

  Future<void> _subsystem1(String subs) async {
    print('masuksubsystem external');
    var resp = await http.get(
        Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/systemsub/ajax/' +
                subs.toString()),
        headers: {
          'Cookie': _cookie,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _tokenJwt
        });
    _getsubsystem1 = [...jsonDecode(resp.body)];
    print(jsonDecode(resp.body));
    setState(() {
      for (var i = 0; i < _getsubsystem1.length; i++) {
        subsystemname1.add(_getsubsystem1[i]['name'].toString());
        subsystemid1.add(_getsubsystem1[i]['id'].toString());
      }
    });
  }

  Future<void> _equipment(String c) async {
    var resp = await http.get(Uri.parse(url + "/equipment/get"), headers: {
      'Cookie': _cookie,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    _getequipment = [...jsonDecode(resp.body)];
    print(jsonDecode(resp.body));
    setState(() {
      for (var i = 0; i < _getequipment.length; i++) {
        if (_getequipment[i]['system_id'].toString() == c) {
          equipmentname.add(_getequipment[i]['name'].toString());
          equipmentid.add(_getequipment[i]['id'].toString());
        }
        equipmentname.add(_getequipment[i]['name'].toString());
        equipmentid.add(_getequipment[i]['id'].toString());
      }
    });
  }

  Future<void> _funcequipmentid(String a) async {
    var resp = await http.get(Uri.parse(url + "/equipmentid/get/"), headers: {
      'Cookie': _cookie,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    _getequipmentid = [...jsonDecode(resp.body)];
    setState(() {
      for (var i = 0; i < _getequipmentid.length; i++) {
        if (a.toString() == 'nothing') {
          equipmentidname.add(_getequipmentid[i]['name'].toString());
          equipmentidid.add(_getequipmentid[i]['id'].toString());
        } else {
          if (_getequipmentid[i]['name'].toString() == a.toString()) {
            equipmentidname.add(_getequipmentid[i]['name'].toString());
            equipmentidid.add(_getequipmentid[i]['id'].toString());
            break;
          }
        }
      }
    });
  }

  Future<void> _equipmentid() async {
    var resp = await http.get(Uri.parse(url + "/equipmentid/get/"), headers: {
      'Cookie': _cookie,
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

  Future<void> _ajaxequipment(String a, String b) async {
    var resp = await http.get(
        Uri.parse(url + "/equipmentid/ajaxequipment/" + a.toString()),
        headers: {
          'Cookie': _cookie,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _tokenJwt
        });
    _getequipmentid = [...jsonDecode(resp.body)];
    equipmentname = [];
    equipmentid = [];
    subsystemid1 = [];
    subsystemname1 = [];
    systemid = [];
    systemname = [];
    setState(() {
      for (var i = 0; i < _getequipmentid.length; i++) {
        equipmentname.add(_getequipmentid[i]['equipmentname'].toString());
        equipmentid.add(_getequipmentid[i]['equipmentid'].toString());
        subsystemname1.add(_getequipmentid[i]['system_subname'].toString());
        subsystemid1.add(_getequipmentid[i]['system_subid'].toString());
        systemname.add(_getequipmentid[i]['systemname'].toString());
        systemid.add(_getequipmentid[i]['systemid'].toString());
      }
      selectequipmentid = a.toString();
      selectequipment = equipmentid[0].toString();
      selectsubsystem = subsystemid1[0].toString();
      selectsystem = systemid[0].toString();
      equipmentisselect = true;
    });
  }

  Future<void> _preventiveopen() async {
    var resp = await http.get(Uri.parse(url + "/preventiveopen/get"), headers: {
      'Cookie': _cookie,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    _getwonumber = [...jsonDecode(resp.body)];
    setState(() {
      for (var i = 0; i < _getwonumber.length; i++) {
        print('cari = ' +
            _getwonumber[i]['id'].toString() +
            ' || data now = ' +
            globals.woexecuteidtemp.toString());
        if (_getwonumber[i]['id'].toString() ==
            globals.woexecuteidtemp.toString()) {
          print('found = ' + _getwonumber[i]['id'].toString());
          wonumber2 = _getwonumber[i]['workorder_no'].toString();
          deparmtent2 = _getwonumber[i]['department'].toString();
          sectiononduty2 = _getwonumber[i]['section_head'].toString();
          techniciane2 = _getwonumber[i]['technician'].toString();
          starttime2 = _getwonumber[i]['start_time'].toString();
          endtime2 = _getwonumber[i]['end_time'].toString();
          initialStartdate = _getwonumber[i]['start_time'].toString();
          initialEnddate = _getwonumber[i]['end_time'].toString();
          break;
        }
      }
      newDepartment = [];
      newDepartmentid = [];
      // print(initializeworkorder);
      _department(wonumber2);
    });
  }

  Future<void> _WoNumber() async {
    var resp = await http.get(Uri.parse(url + "/workorder/get"), headers: {
      'Cookie': _cookie,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    _getwonumber = [...jsonDecode(resp.body)];
    setState(() {
      for (var i = 0; i < _getwonumber.length; i++) {
        newdata.add(_getwonumber[i]['workorder_no'].toString());
        newdataid.add(_getwonumber[i]['id'].toString());
        int selectordepartment = 0;
        if (globals.workorder_notemp.toString() ==
                _getwonumber[i]['id'].toString() &&
            selectordepartment == 0) {
          initializeworkorder = _getwonumber[i]['workorder_no'].toString();
          print('ketemu = ' + initializeworkorder);
          selectordepartment = 1;
        }
      }
    });
  }

  Future<void> _deleteequipmentid(String a) async {
    var headers = {
      'Authorization': 'Bearer ' + _tokenJwt,
      'Cookie': _cookie,
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/preventiveprogress/delete/3/' +
                a.toString()));
    request.bodyFields = {};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => executewo()));
  }

  Future<void> _deleteinputchecksheetid(String a) async {
    var headers = {
      'Authorization': 'Bearer ' + _tokenJwt,
      'Cookie': _cookie,
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/preventiveprogress/delete/3/' +
                a.toString()));
    request.bodyFields = {};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => executewo()));
  }

  Future<void> _department(String a) async {
    var resp = await http
        .get(Uri.parse(url + "/workorder/ajax/" + a.toString()), headers: {
      'Cookie': _cookie,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    _getdepartment = [...jsonDecode(resp.body)];
    setState(() {
      String iddepartment = '';
      for (var i = 0; i < _getdepartment.length; i++) {
        newDepartment.add(_getdepartment[i]['name'].toString());
        newDepartmentid.add(_getdepartment[i]['id'].toString());
        int selectordepartment = 0;
        if (deparmtent2.toString() == _getdepartment[i]['id'].toString() &&
            selectordepartment == 0) {
          iddepartment = _getdepartment[i]['id'].toString();
          initializedepartment = _getdepartment[i]['name'].toString();
          print('ketemu = ' + initializedepartment);
          selectordepartment = 1;
        }
      }
      username = [];
      userid = [];
      _userGet(iddepartment);
    });
  }

  Future<void> _material() async {
    var resp = await http.get(Uri.parse(url + "/material/get"), headers: {
      'Cookie': _cookie,
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
      for (var i = 0; i < _getmaterial.length; i++) {
        toolsname.add(_getmaterial[i]['name'].toString());
        toolsid.add(_getmaterial[i]['id'].toString());
      }
    });
  }

  Future<void> _system() async {
    var resp = await http.get(Uri.parse(url + "/system/get"), headers: {
      'Cookie': _cookie,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    _getsystem = [...jsonDecode(resp.body)];
    print('object' + _getsystem.toString());
    setState(() {
      for (var i = 0; i < _getsystem.length; i++) {
        systemname.add(_getsystem[i]['name'].toString());
        systemid.add(_getsystem[i]['id'].toString());
      }
    });
  }

  Future<void> _tools() async {
    var resp = await http.get(
        Uri.parse(url +
            "/preventiveopen/get/1/" +
            globals.woexecuteidtemp.toString()),
        headers: {
          'Cookie': _cookie,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _tokenJwt
        });
    _gettoolstabel = [...jsonDecode(resp.body)];
    print('object' + jsonDecode(resp.body).toString());
    setState(() {
      for (var i = 0; i < _gettoolstabel.length; i++) {
        // toolsnametabel.add(_gettoolstabel[i]['materialname'].toString());
        toolsnametabel.add(_gettoolstabel[i]['materialname'].toString());
      }
    });
  }

  Future<void> _materialtabel() async {
    var resp = await http.get(
        Uri.parse(url +
            "/preventiveopen/get/2/" +
            globals.woexecuteidtemp.toString()),
        headers: {
          'Cookie': _cookie,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + _tokenJwt
        });
    _getmaterialtabel = [...jsonDecode(resp.body)];
    print('object' + jsonDecode(resp.body).toString());
    setState(() {
      for (var i = 0; i < _getmaterialtabel.length; i++) {
        materialnametabel.add(_getmaterialtabel[i]['materialname'].toString());
      }
    });
  }

  Future<void> _userGet(String a) async {
    var resp =
        await http.get(Uri.parse(url + "/user/ajax/" + a.toString()), headers: {
      'Cookie': _cookie,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    _userget = [...jsonDecode(resp.body)];
    setState(() {
      for (var i = 0; i < _userget.length; i++) {
        username.add(_userget[i]['name'].toString());
        userid.add(_userget[i]['id'].toString());

        int selectordepartment = 0;
        if (sectiononduty2.toString() == _userget[i]['id'].toString() &&
            selectordepartment == 0) {
          initializesectioni = _userget[i]['name'].toString();
          print('ketemu = ' + initializesectioni);
          selectordepartment = 1;
        }
      }
    });
  }

  Future<void> _woAdd(
    String wonumber2,
    String deparmtent2,
    String sectiononduty2,
    String techniciane2,
    String starttime2,
    String endtime2,
  ) async {
    print('token: ' + _tokenJwt[0]);
    print('tokenasds: ' + _cookie);
    print({
      'workorder_no': wonumber2,
      'department': deparmtent2,
      'section_head': sectiononduty2,
      'technician': techniciane2,
      'start_time': starttime2,
      'end_time': endtime2,
      'id_workorder': globals.woexecuteidtemp.toString()
    });
    var headers = {
      'Authorization': 'Bearer ' + _tokenJwt,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Cookie': _cookie,
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/preventiveopen/save/' +
                globals.woexecuteidtemp.toString()));
    request.body = json.encode({
      'workorder_no': wonumber2,
      'department': deparmtent2,
      'section': sectiononduty2,
      'technician': techniciane2,
      'start': starttime2,
      'end': endtime2,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String databack = await response.stream.bytesToString();
      if (json.decode(databack)!['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(json.decode(databack)!['successMsg']),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(json.decode(databack)!['errorMsg']),
        ));
      }
    } else {
      print(response.reasonPhrase);
    }
    //
    //print('resp: ' + request.statusCode.toString());
  } // ini untuk menambahkan failure baru, diperlukan input beberapa parameter untuk mengisi field yang di perlukan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text(
          'Execute WO Edit',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 5, left: 5, right: 5),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blue[100]),
              child: Column(
                children: <Widget>[
                  // Align(
                  //   child: Text('WO Information',
                  //       style:
                  //           TextStyle(fontSize: 20, color: Colors.blue[700])),
                  //   alignment: Alignment.topLeft,
                  // ),
                  Divider(),
                  Center(
                    child: DropdownSearch<String>(
                      mode: Mode.BOTTOM_SHEET,
                      // showSelectedItem: true,
                      items: newdata,

                      label: "Select Workorder Number",
                      // selectedItem: initializeworkorder,
                      // hint: "country in menu mode",
                      onChanged: (value) {
                        setState(() {
                          //wonumber3 = value;
                          int indexdata =
                              newdata.indexWhere((item) => item == value);
                          wonumber2 = newdata[indexdata];
                          print(wonumber2);
                        });
                      },
                      showClearButton: true,
                      showSearchBox: true,
                      //select
                      selectedItem: wonumber2,
                    ),
                  ),
                  Divider(),
                  Center(
                    child: DropdownSearch<String>(
                      mode: Mode.BOTTOM_SHEET,
                      // showSelectedItem: true,
                      items: newDepartment,
                      selectedItem: initializedepartment,
                      label: "Select Department Name",
                      // hint: "country in menu mode",
                      onChanged: (value) {
                        setState(() {
                          selectedint =
                              newDepartment.indexWhere((item) => item == value);
                          deparmtent2 = newDepartmentid[selectedint];
                          print(deparmtent2);
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
                      items: username,
                      selectedItem: initializesectioni,
                      label: "Section Head on Duty",
                      // hint: "country in menu mode",
                      onChanged: (value) {
                        setState(() {
                          int indexuser =
                              username.indexWhere((item) => item == value);
                          sectiononduty2 = userid[indexuser];
                          print(sectiononduty2);
                        });
                      },
                      showClearButton: true,
                    ),
                  ),
                  Divider(),
                  TextFormField(
                    initialValue: techniciane2,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Technician',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return 'Title tidak boleh kosong';
                      techniciane2 = value;
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
                        child: Text(
                          starttime2.split(' ')[0],
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
                                starttime2 = value.toString().split(' ')[0];
                                initialStartdate = starttime2;
                                print(starttime2);
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
                          endtime2.split(' ')[0],
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
                                endtime2 = value.toString().split(' ')[0];
                                initialEnddate = endtime2;
                                print(endtime2);
                              });
                            }
                          });
                        }),
                  ),
                  Divider(),
                  ElevatedButton(
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.blue),
                      onPressed: () async {
                        print(selected);
                        // if (_formKey.currentState!.validate()) {
                        await _woAdd(wonumber2, deparmtent2, sectiononduty2,
                            techniciane2, starttime2, endtime2);
                        // }
                      }),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: _gettoolstabel.length * 60 + 180,
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
                        'New Tools',
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
                              items: toolsname,
                              label: "New Tools",
                              // hint: "country in menu mode",
                              onChanged: (value) {
                                setState(() {
                                  int indextools = toolsname
                                      .indexWhere((item) => item == value);
                                  selecttools = materialid[indextools];
                                  print(selecttools);
                                });
                              },
                              showClearButton: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, right: 5, bottom: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton.icon(
                            onPressed: () {
                              if (selecttools == '') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Please Select Tools'),
                                ));
                              } else {
                                _addTools();
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
                          itemCount: _gettoolstabel.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    String a =
                                        _gettoolstabel[index]['id'].toString();
                                    print(
                                        _gettoolstabel[index]['id'].toString());
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
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
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
                                                              onPressed: () {
                                                                _deletetoolspreventive(
                                                                    a);
                                                                // _deleteequipmentid(
                                                                //     indexnum);
                                                              },
                                                              icon: Icon(
                                                                Icons.recycling,
                                                                color: HexColor(
                                                                    '#FFC107'),
                                                              ),
                                                              label: Text(
                                                                'Delete',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              color: HexColor(
                                                                  '#343A40'),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                            ),
                                                            FlatButton.icon(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                executewo()));
                                                              },
                                                              icon: Icon(
                                                                Icons
                                                                    .autorenew_sharp,
                                                                color: HexColor(
                                                                    '#17A2B8'),
                                                              ),
                                                              label: Text(
                                                                'RELOAD',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              color: HexColor(
                                                                  '#343A40'),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
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
                                            ));
                                  },
                                  child: Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          leading: Icon(Icons.key, size: 45),
                                          title: Text(_gettoolstabel[index]
                                              ['materialname']),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
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
                height: _getmaterialtabel.length * 60 + 180,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                    width: 3,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      child: Text(
                        'New Material',
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
                              label: "Section Material",
                              // hint: "country in menu mode",
                              onChanged: (value) {
                                setState(() {
                                  int indexmaterial = materialname
                                      .indexWhere((item) => item == value);
                                  selectmaterial = materialid[indexmaterial];
                                  print(selectmaterial);
                                });
                              },
                              showClearButton: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, right: 5, bottom: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton.icon(
                            onPressed: () {
                              if (selectmaterial == '') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Please Select Materials'),
                                ));
                              } else {
                                _addMaterial();
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
                          itemCount: _getmaterialtabel.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    String a = _getmaterialtabel[index]['id']
                                        .toString();
                                    print(_getmaterialtabel[index]['id']
                                        .toString());
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
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
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
                                                              onPressed: () {
                                                                _deletematerialspreventive(
                                                                    a);
                                                                // _deleteequipmentid(
                                                                //     indexnum);
                                                              },
                                                              icon: Icon(
                                                                Icons.recycling,
                                                                color: HexColor(
                                                                    '#FFC107'),
                                                              ),
                                                              label: Text(
                                                                'Delete',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              color: HexColor(
                                                                  '#343A40'),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                            ),
                                                            FlatButton.icon(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                executewo()));
                                                              },
                                                              icon: Icon(
                                                                Icons
                                                                    .autorenew_sharp,
                                                                color: HexColor(
                                                                    '#17A2B8'),
                                                              ),
                                                              label: Text(
                                                                'RELOAD',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              color: HexColor(
                                                                  '#343A40'),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
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
                                            ));
                                  },
                                  child: Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          leading: Icon(Icons.key, size: 45),
                                          title: Text(_getmaterialtabel[index]
                                              ['materialname']),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          })
                    ])),
                    // TEMPAT COLUMN CHECKSHEET ON PROGRESS HARI INI
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: (_getchecksheettabel.length) * 150 + 500,
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
                              child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 1.7,
                                child: DropdownSearch<String>(
                                  mode: Mode.BOTTOM_SHEET,
                                  // showSelectedItem: true,
                                  items: equipmentidname,
                                  showSearchBox: true,
                                  selectedItem: equipmentisselect == true
                                      ? equipmentidname[selectnameequipmentid]
                                      : null,
                                  // selectedItem: equipmentidname[0],
                                  label: "Equipment ID",
                                  // hint: "country in menu mode",
                                  onChanged: (value) {
                                    setState(() {
                                      int indextools = equipmentidname
                                          .indexWhere((item) => item == value);
                                      selectequipmentid =
                                          equipmentidid[indextools];
                                      selectnameequipmentid = indextools;

                                      print(selectequipmentid);
                                      equipmentname = [];
                                      equipmentid = [];
                                      _ajaxequipment(
                                          selectequipmentid.toString(),
                                          value.toString());
                                    });
                                  },
                                  showClearButton: true,
                                ),
                              ),
                              Text('            '),
                              GestureDetector(
                                child: Icon(Icons.qr_code),
                                onTap: () {
                                  scanQRCode();
                                },
                              ),
                              // ButtonWidget(
                              //   text: '',
                              //   onClicked: () => scanQRCode(),
                              //   key: const Key('start_qr_scan'),
                              // ),
                            ],
                          )),
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
                              items: equipmentname,
                              label: "Equipment",
                              selectedItem: equipmentisselect == true
                                  ? equipmentname[0]
                                  : null,
                              // selectedItem :
                              // hint: "country in menu mode",
                              onChanged: (value) {
                                setState(() {
                                  int indextools = equipmentname
                                      .indexWhere((item) => item == value);
                                  selectequipment = equipmentid[indextools];
                                  print(selectequipment);
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
                              items: subsystemname1,
                              label: "Sub System",
                              selectedItem: equipmentisselect == true
                                  ? subsystemname1[0]
                                  : null,
                              // hint: "country in menu mode",
                              onChanged: (value) {
                                setState(() {
                                  int indextools = subsystemname1
                                      .indexWhere((item) => item == value);
                                  selectsubsystem = subsystemid1[indextools];
                                  print(selectsubsystem);
                                  // equipmentname = [];
                                  // equipmentid = [];
                                  // _equipment(selectsubsystem);
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
                              items: systemname,
                              label: "System",
                              selectedItem: equipmentisselect == true
                                  ? systemname[0]
                                  : null,

                              // hint: "country in menu mode",
                              onChanged: (value) {
                                setState(() {
                                  int indextools = systemname
                                      .indexWhere((item) => item == value);
                                  selectsystem = systemid[indextools];
                                  print(selectsystem);
                                  // subsystemname1 = [];
                                  // subsystemid1 = [];
                                  // _subsystem1(selectsystem);
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
                      ),
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
                              if (selectequipmentid == '' ||
                                  selectequipment == '' ||
                                  selectsubsystem == '' ||
                                  selectsystem == '' ||
                                  selectperiod == '') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Please Complete Equipment'),
                                ));
                              } else {
                                print(selectequipmentid);
                                print(selectequipment);
                                print(selectsubsystem);
                                print(selectsystem);
                                print(selectperiod);
                                _addequipmentid();
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
                          itemCount: _getchecksheettabel.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                String indexnum =
                                    _getchecksheettabel[index]['id'].toString();

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
                                                      _deleteequipmentid(
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
                                                                  executewo()));
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
                                              _getchecksheettabel[index]
                                                  ['systemname'],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
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
                                              _getchecksheettabel[index]
                                                      ['system_subname']
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
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(' : ',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                              _getchecksheettabel[index]
                                                  ['equipmentname'],
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
                                                _getchecksheettabel[index]
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
                                              Text('Period',
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
                                                _getchecksheettabel[index]
                                                    ['period'],
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          // TableRow(
                                          //   children: [
                                          //     Text('Status',
                                          //         style: TextStyle(
                                          //             fontSize: 15,
                                          //             fontWeight:
                                          //                 FontWeight.bold)),
                                          //     Text(' : ',
                                          //         style: TextStyle(
                                          //             fontSize: 15,
                                          //             fontWeight:
                                          //                 FontWeight.bold)),
                                          //     if (_getchecksheettabel[index]
                                          //             ['status'] ==
                                          //         1) ...[
                                          //       if (_getchecksheettabel[index]
                                          //               ['status_proses'] ==
                                          //           0) ...[
                                          //         Text(
                                          //           'Open',
                                          //           style: TextStyle(
                                          //               fontSize: 15,
                                          //               fontWeight:
                                          //                   FontWeight.bold),
                                          //         )
                                          //       ] else if (_getchecksheettabel[
                                          //                   index]
                                          //               ['status_proses'] ==
                                          //           1) ...[
                                          //         Text(
                                          //           'In Progress',
                                          //           style: TextStyle(
                                          //               fontSize: 15,
                                          //               fontWeight:
                                          //                   FontWeight.bold),
                                          //         )
                                          //       ] else if (_getchecksheettabel[
                                          //                   index]
                                          //               ['status_proses'] ==
                                          //           2) ...[
                                          //         Text(
                                          //           'Need-Approval',
                                          //           style: TextStyle(
                                          //               fontSize: 15,
                                          //               fontWeight:
                                          //                   FontWeight.bold),
                                          //         )
                                          //       ] else if (_getchecksheettabel[
                                          //                   index]
                                          //               ['status_proses'] ==
                                          //           3) ...[
                                          //         Text(
                                          //           'Close',
                                          //           style: TextStyle(
                                          //               fontSize: 15,
                                          //               fontWeight:
                                          //                   FontWeight.bold),
                                          //         )
                                          //       ] else if (_getchecksheettabel[
                                          //                   index]
                                          //               ['status_proses'] ==
                                          //           4) ...[
                                          //         Text(
                                          //           'Need-Revision',
                                          //           style: TextStyle(
                                          //               fontSize: 15,
                                          //               fontWeight:
                                          //                   FontWeight.bold),
                                          //         )
                                          //       ]
                                          //     ] else ...[
                                          //       Text(
                                          //         'Not Active',
                                          //         style: TextStyle(
                                          //             fontSize: 15,
                                          //             fontWeight:
                                          //                 FontWeight.bold),
                                          //       ),
                                          //     ],
                                          //   ],
                                          // )
                                        ],
                                      )
                                      /*Row(
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'System ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  'Sub System ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  'Equipment ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  'Equipment ID ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  'Period ',
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
                                                      _getchecksheettabel[index]
                                                          ['systemname'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  ' : ' +
                                                      _getchecksheettabel[index]
                                                          ['system_subname'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  ' : ' +
                                                      _getchecksheettabel[index]
                                                          ['equipmentname'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  ' : ' +
                                                      _getchecksheettabel[index]
                                                          ['equipmentname'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  ' : ' +
                                                      _getchecksheettabel[index]
                                                          ['period'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  _getchecksheettabel[index]
                                                                  ['status']
                                                              .toString() ==
                                                          "1"
                                                      ? ' : Open'
                                                      : ' : Close',
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
                    ])),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: _getinputchecksheettabel.length * 150 + 50,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                    width: 3,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      child: Text(
                        'Input Checksheet',
                        style: _contentStyle,
                      ),
                    ),
                    SingleChildScrollView(
                        child: Column(children: [
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _getinputchecksheettabel.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                String indexnum =
                                    _getinputchecksheettabel[index]['id']
                                        .toString();

                                print(indexnum);
                                globals.checksheetequipmentidtemp =
                                    _getinputchecksheettabel[index]['id']
                                        .toString();
                                globals.checksheetperiodtemp =
                                    _getinputchecksheettabel[index]
                                            ['periodname']
                                        .toString();
                                globals.checksheetitemtemp =
                                    _getinputchecksheettabel[index]
                                            ['check_item']
                                        .toString();
                                globals.checksheetrefrencetemp =
                                    _getinputchecksheettabel[index]
                                            ['check_standard']
                                        .toString();
                                globals.checksheethasiltemp =
                                    _getinputchecksheettabel[index]
                                            ['check_result']
                                        .toString();
                                // print('object');
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
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  inputchecksheetedit()));
                                                    },
                                                    icon: Icon(
                                                      Icons.edit,
                                                      color:
                                                          HexColor('#FFC107'),
                                                    ),
                                                    label: Text(
                                                      'Edit',
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
                                                      // _deleteinputchecksheetid(
                                                      //     indexnum);
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
                                                                  executewo()));
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
                                                  'Equpment ID ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  'Period',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  'Item Pemeriksaan ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  'Refrensi Standar',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  'Tipe Hasil ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  'Hasil Pemeriksaan ',
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
                                                      _getinputchecksheettabel[
                                                                  index][
                                                              'equipment_idname']
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  ' : ' +
                                                      _getinputchecksheettabel[
                                                              index]['period']
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  ' : ' +
                                                      _getinputchecksheettabel[
                                                                  index]
                                                              ['check_item']
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  ' : ' +
                                                      _getinputchecksheettabel[
                                                                  index]
                                                              ['check_standard']
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  ' : ' +
                                                      _getinputchecksheettabel[
                                                                  index]
                                                              ['type_result']
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  ' : ' +
                                                      _getinputchecksheettabel[
                                                                  index]
                                                              ['check_result']
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
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
