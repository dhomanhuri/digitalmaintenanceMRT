import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import '../globals.dart' as globals;

class User {
  final String workorder;
  final String department;
  final String sectionhead;
  final String datetime;
  final String note;
  final String status;

  const User(
      {required this.workorder,
      required this.department,
      required this.sectionhead,
      required this.datetime,
      required this.note,
      required this.status});
}

class PdfApi {
  static Future<File> generateTable() async {
    List<dynamic> closewopdf = globals.closewopdf;
    for (var i = 0; i < closewopdf.length; i++) {
      print('index0');
      print(closewopdf[i]['workorder_no']);
      print(closewopdf[i]['department']);
      print(closewopdf[i]['section_head']);
      print(closewopdf[i]['start_time']);
      print(closewopdf[i]['departmentname']);
      print(closewopdf[i]['status']);
    }

    final pdf = Document();

    final headers = [
      'Workorder',
      'Deparatment',
      'Section Head',
      'Date Time',
      'Note',
      'Status'
    ];

    final users = [
      for (var i = 0; i < closewopdf.length; i++)
        User(
            workorder: closewopdf[i]['workorder_no'].toString(),
            department: closewopdf[i]['department'].toString(),
            sectionhead: closewopdf[i]['section_head'].toString(),
            datetime: closewopdf[i]['start_time'].toString(),
            note: closewopdf[i]['departmentname'].toString(),
            status: closewopdf[i]['status'].toString())
    ];
    final data = users
        .map((user) => [
              user.workorder,
              user.department,
              user.sectionhead,
              user.datetime,
              user.note,
              user.status
            ])
        .toList();

    pdf.addPage(Page(
      build: (context) => Table.fromTextArray(
        headers: headers,
        data: data,
      ),
    ));

    return saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  static Future<File> generateImage(
      int indexnum,
      List<dynamic> _getselected,
      List<dynamic> _getmaterial,
      List<dynamic> _gettools,
      List<dynamic> _getchecksheet) async {
    final pdf = Document();
    // final int index = int.parse(indexnum);

    final imageSvg = await rootBundle.loadString('assets/fruit.svg');
    final imageJpg =
        (await rootBundle.load('assets/person.jpg')).buffer.asUint8List();

    final pageTheme = PageTheme(
      pageFormat: PdfPageFormat.a4,
      buildBackground: (context) {
        if (context.pageNumber == 1) {
          return FullPage(
            ignoreMargins: true,
            child: Image(MemoryImage(imageJpg), fit: BoxFit.cover),
          );
        } else {
          return Container();
        }
      },
    );

    pdf.addPage(
      MultiPage(
        pageTheme: pageTheme,
        build: (context) => [
          Center(
              child: Column(children: [
            Divider(height: 150, indent: 250, endIndent: 250),
            Text('No.' + _getselected[indexnum]['id'].toString()),
            Divider(height: 10, indent: 250, endIndent: 250),
            Text('Information'),
            Container(
                width: 520,
                height: 110,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.0, color: PdfColors.black),
                    left: BorderSide(width: 1.0, color: PdfColors.black),
                    right: BorderSide(width: 1.0, color: PdfColors.black),
                    bottom: BorderSide(width: 1.0, color: PdfColors.black),
                  ),
                ),
                child: Row(
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Workorder ',
                          ),
                          Text(
                            'Department  ',
                          ),
                          Text(
                            'Section Head ',
                          ),
                          Text(
                            'Technician  ',
                          ),
                          Text(
                            'Start Time  ',
                          ),
                          Text(
                            'End Time ',
                          ),
                        ]),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            ' : ' +
                                _getselected[indexnum]['workorder_no']
                                    .toString(),
                          ),
                          Text(
                            ' : ' +
                                _getselected[indexnum]['departmentname']
                                    .toString(),
                          ),
                          Text(
                            ' : ' +
                                _getselected[indexnum]['section_headname']
                                    .toString(),
                          ),
                          Text(
                            ' : ' +
                                _getselected[indexnum]['technician'].toString(),
                          ),
                          Text(
                            ' : ' +
                                _getselected[indexnum]['start_time'].toString(),
                          ),
                          Text(
                            ' : ' +
                                _getselected[indexnum]['end_time'].toString(),
                          ),
                        ]),
                  ],
                )),
            Text('\n '),
            Container(
                width: 520,
                height: ((_getmaterial.length + _gettools.length) * 15) + 40,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tools : '),
                      for (var i = 0; i < _gettools.length; i++)
                        Text('   - ' + _gettools[i]['materialname'].toString()),
                      Text('\n '),
                      Text('Material : '),
                      for (var i = 0; i < _getmaterial.length; i++)
                        Text('   - ' +
                            _getmaterial[i]['materialname'].toString()),
                      Text('\n '),
                      Text('\n '),
                      Text('Equipment'),
                    ])),
            Container(
              margin: EdgeInsets.all(20),
              child: Table(
                defaultColumnWidth: FixedColumnWidth(120.0),
                border: TableBorder.all(style: BorderStyle.solid, width: 1),
                children: [
                  TableRow(children: [
                    Column(children: [Text('No')]),
                    Column(children: [Text('System')]),
                    Column(children: [Text('Sub-System')]),
                    Column(children: [Text('Equipment')]),
                    Column(children: [Text('Equipment ID')]),
                    Column(children: [
                      Text(
                        'Period',
                      )
                    ]),
                  ]),
                  for (var i = 0; i < _getchecksheet.length; i++)
                    TableRow(children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getchecksheet[i]['id'].toString(),
                            )
                          ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getchecksheet[i]['systemname'].toString(),
                            )
                          ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getchecksheet[i]['system_subname'].toString(),
                            )
                          ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getchecksheet[i]['equipmentname'].toString(),
                            )
                          ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getchecksheet[i]['equipment_idname'].toString(),
                            )
                          ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getchecksheet[i]['period'].toString(),
                            )
                          ]),
                    ]),
                ],
              ),
            ),
            Container(
                width: 520,
                height: ((_getmaterial.length + _gettools.length) * 15) + 40,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('\n '),
                      Text('\n '),
                      Text('Checksheet'),
                    ])),
            Container(
              margin: EdgeInsets.all(20),
              child: Table(
                defaultColumnWidth: FixedColumnWidth(120.0),
                border: TableBorder.all(style: BorderStyle.solid, width: 1),
                children: [
                  TableRow(children: [
                    Column(children: [Text('No')]),
                    Column(children: [Text('System')]),
                    Column(children: [Text('Sub-System')]),
                    Column(children: [Text('Equipment')]),
                    Column(children: [Text('Equipment ID')]),
                    Column(children: [
                      Text(
                        'Period',
                      )
                    ]),
                  ]),
                  for (var i = 0; i < _getchecksheet.length; i++)
                    TableRow(children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getchecksheet[i]['id'].toString(),
                            )
                          ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getchecksheet[i]['systemname'].toString(),
                            )
                          ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getchecksheet[i]['system_subname'].toString(),
                            )
                          ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getchecksheet[i]['equipmentname'].toString(),
                            )
                          ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getchecksheet[i]['equipment_idname'].toString(),
                            )
                          ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getchecksheet[i]['period'].toString(),
                            )
                          ]),
                    ]),
                ],
              ),
            ),
          ]))
        ],
      ),
    );

    return saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  static Future<File> generateImage2(
      int indexnum, List<dynamic> _getselected) async {
    final pdf = Document();
    // final int index = int.parse(indexnum);

    final imageSvg = await rootBundle.loadString('assets/fruit.svg');
    final imageJpg =
        (await rootBundle.load('assets/person.jpg')).buffer.asUint8List();

    final pageTheme = PageTheme(
      pageFormat: PdfPageFormat.a4,
      buildBackground: (context) {
        if (context.pageNumber == 1) {
          return FullPage(
            ignoreMargins: true,
            child: Image(MemoryImage(imageJpg), fit: BoxFit.cover),
          );
        } else {
          return Container();
        }
      },
    );

    pdf.addPage(
      MultiPage(
        pageTheme: pageTheme,
        build: (context) => [
          Center(
              child: Column(children: [
            Divider(height: 150, indent: 250, endIndent: 250),
            Text('Information'),
            Container(
                width: 600,
                height: 310,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.0, color: PdfColors.black),
                    left: BorderSide(width: 1.0, color: PdfColors.black),
                    right: BorderSide(width: 1.0, color: PdfColors.black),
                    bottom: BorderSide(width: 1.0, color: PdfColors.black),
                  ),
                ),
                child: Row(
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'WO Number ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Title  ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Location ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Area ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Delay ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Reported By Department ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Received By Department ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Report Date ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Failure Date ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Failure Time ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'System ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Subsystem ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Equipment ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Equipment ID ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Train Set ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Failure Description ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Mitigration   ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ]),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            ' : ' +
                                _getselected[indexnum]['workorder_no']
                                    .toString(),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' : ' + _getselected[indexnum]['title'].toString(),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' : ' +
                                _getselected[indexnum]['location'].toString(),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' : ' + _getselected[indexnum]['area'].toString(),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' : ' + _getselected[indexnum]['delay'].toString(),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' : ' +
                                _getselected[indexnum]['reported_department']
                                    .toString(),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' : ' +
                                _getselected[indexnum]['received_department']
                                    .toString(),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' : ' +
                                _getselected[indexnum]['report_date']
                                    .toString(),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' : ' +
                                _getselected[indexnum]['failure_date']
                                    .toString(),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' : ' +
                                _getselected[indexnum]['failure_time']
                                    .toString(),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' : ' +
                                _getselected[indexnum]['systemname'].toString(),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' : ' +
                                _getselected[indexnum]['system_subname']
                                    .toString(),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' : ' +
                                _getselected[indexnum]['equipmentname']
                                    .toString(),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' : ' +
                                _getselected[indexnum]['equipment_idname']
                                    .toString(),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' : ' +
                                _getselected[indexnum]['trainset'].toString(),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' : ' +
                                _getselected[indexnum]['failure_description']
                                    .toString(),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' : ' +
                                _getselected[indexnum]['report_action']
                                    .toString(),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ],
                )),
          ]))
        ],
      ),
    );

    return saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
