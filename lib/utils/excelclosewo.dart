import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

Future<void> createExcel(List<dynamic> data) async {
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];

  //Set data in the worksheet.
  sheet.getRangeByName('B2').setDateTime(DateTime.now());
  sheet.getRangeByName('B2').numberFormat =
      r'[$-x-sysdate]yyyy-mm-dd, hh-mm-ss';

  sheet.getRangeByName('H2').setText('Exported Data');
  sheet.getRangeByName('H2').cellStyle.fontSize = 12;

  sheet.getRangeByName('E3').setText('Exported Data');
  sheet.getRangeByName('E3').cellStyle.fontSize = 12;
  sheet.getRangeByName('E3').cellStyle.bold = true;
  sheet.getRangeByName('E3').cellStyle.hAlign = HAlignType.center;

  final Range range1 = sheet.getRangeByName('C4:G4');

  range1.merge();

  sheet
      .getRangeByName('C4')
      .setText('This is the first time you have printed this document#');
  range1.cellStyle.fontSize = 12;
  range1.cellStyle.bold = true;
  range1.cellStyle.hAlign = HAlignType.center;

  sheet.getRangeByName('B5').setText('No.');
  sheet.getRangeByName('B5').cellStyle.fontSize = 12;
  sheet.getRangeByName('B5').columnWidth = 6;

  sheet.getRangeByName('C5').setText('Workorder');
  sheet.getRangeByName('C5').cellStyle.fontSize = 12;
  sheet.getRangeByName('C5').columnWidth = 20;

  sheet.getRangeByName('D5').setText('Department');
  sheet.getRangeByName('D5').cellStyle.fontSize = 12;
  sheet.getRangeByName('D5').columnWidth = 30;
  sheet.getRangeByName('E5').setText('Section Head');
  sheet.getRangeByName('E5').cellStyle.fontSize = 12;
  sheet.getRangeByName('E5').columnWidth = 30;
  // sheet.getRangeByName('E5').cellStyle

  sheet.getRangeByName('F5').setText('Technician');
  sheet.getRangeByName('F5').cellStyle.fontSize = 12;
  sheet.getRangeByName('F5').columnWidth = 30;

  sheet.getRangeByName('F5').setText('Note');
  sheet.getRangeByName('F5').cellStyle.fontSize = 12;
  sheet.getRangeByName('F5').columnWidth = 50;

  sheet.getRangeByName('G5').setText('Status');
  sheet.getRangeByName('G5').cellStyle.fontSize = 12;
  sheet.getRangeByName('G5').columnWidth = 12;

  for (int i = 0; i < data.length; i++) {
    sheet.getRangeByName('B' + (i + 6).toString()).setText((i + 1).toString());
    sheet
        .getRangeByName('C' + (i + 6).toString())
        .setText(data[i]['workorder_no'].toString());
    sheet
        .getRangeByName('D' + (i + 6).toString())
        .setText(data[i]['departmentname'].toString());
    sheet
        .getRangeByName('E' + (i + 6).toString())
        .setText(data[i]['section_headname'].toString());
    sheet
        .getRangeByName('F' + (i + 6).toString())
        .setText(data[i]['note'].toString());

    if (data[i]['status'] == 1) {
      if (data[i]['status_proses'] == 0) {
        sheet.getRangeByName('G' + (i + 6).toString()).setText('Open');
      } else if (data[i]['status_proses'] == 1) {
        sheet.getRangeByName('G' + (i + 6).toString()).setText('In Progress');
      } else if (data[i]['status_proses'] == 2) {
        sheet
            .getRangeByName('G' + (i + 6).toString())
            .setText('Need - Approval');
      } else if (data[i]['status_proses'] == 3) {
        sheet.getRangeByName('G' + (i + 6).toString()).setText('Close');
      } else if (data[i]['status_proses'] == 4) {
        sheet.getRangeByName('G' + (i + 6).toString()).setText('Need-Revision');
      }
    } else {
      sheet.getRangeByName('G' + (i + 6).toString()).setText('Not Active');
    }
  }
  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  if (kIsWeb) {
    // AnchorElement(
    //     href:
    //         'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
    //   ..setAttribute('download', 'Output.xlsx')
    //   ..click();
  } else {
    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName =
        Platform.isWindows ? '$path\\Output.xlsx' : '$path/Output.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }
}
