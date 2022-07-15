import 'package:flutter/material.dart';
import 'package:mrt/NavDrawer.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:mrt/executewo.dart';
import 'package:mrt/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'globals.dart' as globals;

class pmchecksheet extends StatefulWidget {
  static const String routeName = '/pmchecksheet';

  @override
  State<pmchecksheet> createState() => _pmchecksheetState();
}

class _pmchecksheetState extends State<pmchecksheet> {
  final _headerStyle = const TextStyle(
      color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold);
  final _contentStyleHeader = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700);
  final _contentStyle = const TextStyle(
      color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold);
  final _formKey = GlobalKey<FormState>();

  List<dynamic> _getperiod = [];
  List<String> periodname = [];
  List<String> periodid = [];
  String selectsystem = '';
  String selectsubsystem = '';
  String selectequipment = '';
  String selectequipmentid = '';
  String selectperiod = '';
  List<dynamic> _gettoolstabel = [];
  List<String> toolsnametabel = [];
  List<String> toolsidtabel = [];

  List<dynamic> _getchecksheettabel = [];
  List<String> checksheetnametabel = [];
  List<String> checksheetidtabel = [];
  List<dynamic> _getmaterialtabel = [];
  List<String> materialnametabel = [];
  List<String> materialidtabel = [];
  List<dynamic> _getinputchecksheettabel = [];
  List<String> inputchecksheetnametabel = [];
  List<String> inputchecksheetidtabel = [];
  String wonumber2 = '';
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
  String _departmentg = '';
  bool showSelectedItem = true;
  String wonumber3 = '';
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

  String initialStartdate = 'Start Date';
  String initialEnddate = 'End Date';

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
  List<String> toolsname = [];
  List<String> toolsid = [];
  String selecttools = '';

  String system = '';
  String subsystem = '';
  String equipment = '';
  String equipment_id = '';

  TextEditingController? textController1;
  TextEditingController? textController2;
  TextEditingController? textController3;
  String? _valGender;
  List _listGender = ["Male", "Female"];

  final String url = 'http://147.139.134.143/mrtjakarta/public/api';
  void initState() {
    super.initState();
    textController1 = TextEditingController();
    textController2 = TextEditingController();
    textController3 = TextEditingController();
    init();
  }

  void init() async {
    String _token = await SecureStorage.getToken();
    String _cookies = await SecureStorage.getCookie();
    String _departmentlocal = await SecureStorage.getDepartment();
    setState(() {
      _tokenJwt = _token;
      _cookie = _cookies;
      _departmentg = _departmentlocal;
    });
    _WoNumber();
    // _userGet();
    _material();
  }

  Future<void> _addequipmentid() async {
    var headers = {'Authorization': 'Bearer ' + _tokenJwt, 'Cookie': _cookie};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/preventiveopen/save/3/'));
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
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }

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
            'http://147.139.134.143/mrtjakarta/public/api/preventiveopen/save/1/'));
    request.fields.addAll({
      'tools': selecttools,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }

    Navigator.of(context).pop();
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => pmchecksheet()));
  }

  Future<void> _addMaterial() async {
    var headers = {
      'Authorization': 'Bearer ' + _tokenJwt,
      'Cookie': _cookie,
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/preventiveopen/save/2/'));
    request.fields.addAll({
      'material': selectmaterial,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
    Navigator.of(context).pop();
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => pmchecksheet()));
  }

  Future<void> _inputchecksheettabel() async {
    var resp =
        await http.get(Uri.parse(url + "/preventiveopen/get/4/"), headers: {
      'Cookie': _cookie,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    setState(() {
      _getinputchecksheettabel = [...jsonDecode(resp.body)];
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
    print("department" + _departmentg.toString());
    setState(() {
      for (var i = 0; i < _getwonumber.length; i++) {
        if (_getwonumber[i]['department'].toString() ==
            _departmentg.toString()) {
          print('masuk if wo');
          newdata.add(_getwonumber[i]['workorder_no'].toString());
          newdataid.add(_getwonumber[i]['id'].toString());
        }
        if ('1' == _departmentg.toString()) {
          print('masuk if wo');
          newdata.add(_getwonumber[i]['workorder_no'].toString());
          newdataid.add(_getwonumber[i]['id'].toString());
        }
        // print(newdata);
      }
    });
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
      for (var i = 0; i < _getdepartment.length; i++) {
        newDepartment.add(_getdepartment[i]['name'].toString());
        newDepartmentid.add(_getdepartment[i]['id'].toString());
      }
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
    print('object' + _getmaterial.toString());
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

  Future<void> _userGet(String a) async {
    var resp =
        await http.get(Uri.parse(url + "/user/ajax/" + a.toString()), headers: {
      'Cookie': _cookie,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + _tokenJwt
    });
    print('object' + resp.body);
    _userget = [...jsonDecode(resp.body)];
    setState(() {
      for (var i = 0; i < _userget.length; i++) {
        username.add(_userget[i]['name'].toString());
        userid.add(_userget[i]['id'].toString());
      }
    });
  }

  Future<void> _woAdd() async {
    print('token: ' + _tokenJwt[0]);
    print('tokenasds: ' + _cookie);

    // datarole = json.deco
    // var resp =
    //     await http.post(Uri.parse(url + "/preventiveopen/save/0"), headers: {
    //   'Cookie': _cookie,
    //   'Content-Type': 'application/json',
    //   'Accept': 'application/json',
    //   'Authorization': 'Bearer ' + _tokenJwt
    // }, body: {
    //   json.encode({
    //     'workorder': wonumber2.toString(),
    //     'department': deparmtent2.toString(),
    //     'section': sectiononduty2.toString(),
    //     'technician': techniciane2.toString(),
    //     'start': starttime2.toString(),
    //     'end': endtime2.toString(),
    //   })
    // });
    // print('savee : ' + resp.body);
    // _userget = [...jsonDecode(resp.body)];
    var headers = {
      'Authorization': 'Bearer ' + _tokenJwt,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Cookie': _cookie,
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://147.139.134.143/mrtjakarta/public/api/preventiveopen/save/0'));
    request.body = json.encode({
      'workorder': wonumber2.toString(),
      'department': deparmtent2.toString(),
      'section': sectiononduty2.toString(),
      'technician': techniciane2.toString(),
      'start': starttime2.toString(),
      'end': endtime2.toString(),
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String data = await response.stream.bytesToString();
      String data2 = jsonDecode(data)['idmaster'].toString();
      print('data3: ' + data2);
      globals.woexecuteidtemp = data2;
      wonumber2 == '';
      deparmtent2 == '';
      sectiononduty2 == '';
      techniciane2 == '';
      starttime2 == '';
      endtime2 == '';

      Navigator.of(context).pop();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => executewo()));
      // globals.woexecuteidtemp = jsonDecode(request.body)['idmaster'].toString();
      // print('body id : ' + jsonDecode(response.stream.)['idmaster'].toString());
    } else {
      print(response.reasonPhrase);
    }

    // Navigator.of(context).pop();
    // Navigator.of(context).push(
    //     MaterialPageRoute(builder: (BuildContext context) => executewo()));
    //
    //print('resp: ' + request.statusCode.toString());
  } // ini untuk menambahkan failure baru, diperlukan input beberapa parameter untuk mengisi field yang di perlukan

  bool _autovalidate = false;
  String? selectedSalution;
  String? technician;
  String? workorder;
  String? department;
  String? headonDuty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text(
          'Add Workorder',
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
                      // hint: "country in menu mode",
                      // validator: (value) => value == null
                      //     ? 'Pilih Workorder Number Terlebih Dahulu'
                      //     : null,
                      onChanged: (value) {
                        setState(() {
                          //wonumber3 = value;
                          int indexdata =
                              newdata.indexWhere((item) => item == value);
                          wonumber2 = value.toString();
                          // wonumber2 = newdata[indexdata];
                          print(wonumber2);
                          newDepartment = [];
                          newDepartmentid = [];
                          _department(wonumber2);
                        });
                      },
                      showClearButton: true,
                      showSearchBox: true,
                      //select
                      selectedItem: selected,
                    ),
                    // child: DropdownButtonFormField<String>(
                    //   value: selectedSalution,
                    //   hint: Text('Salutation'),
                    //   onChanged: (salutation) =>
                    //       setState(() => selectedSalution = salutation!),
                    //   validator: (value) => value == null
                    //       ? 'Pilih Workorder Number Terlebih Dahulu'
                    //       : null,
                    //   items: ['MR', ' MS']
                    //       .map<DropdownMenuItem<String>>((String value) {
                    //     return DropdownMenuItem<String>(
                    //       value: value,
                    //       child: Text(value),
                    //     );
                    //   }).toList(),
                    // ),
                  ),
                  Divider(),
                  Center(
                    child: DropdownSearch<String>(
                      mode: Mode.BOTTOM_SHEET,
                      // showSelectedItem: true,
                      items: newDepartment,
                      label: "Select Department Name",
                      // hint: "country in menu mode",
                      onChanged: (value) {
                        setState(() {
                          selectedint =
                              newDepartment.indexWhere((item) => item == value);
                          deparmtent2 = newDepartmentid[selectedint];
                          print(deparmtent2);
                          username = [];
                          userid = [];
                          _userGet(deparmtent2);
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
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Technician',
                    ),
                    onChanged: (value) {
                      setState(() {
                        techniciane2 = value;
                        print(techniciane2);
                      });
                    },
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
                          initialStartdate,
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
                          initialEnddate,
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
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.blue),
                      onPressed: () async {
                        if (wonumber2 == '' ||
                            deparmtent2 == '' ||
                            sectiononduty2 == '' ||
                            techniciane2 == '' ||
                            starttime2 == '' ||
                            endtime2 == '') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please fill all the fields"),
                          ));
                        } else {
                          print(selected);
                          await _woAdd();
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
