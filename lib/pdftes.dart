import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrt/globals.dart' as globals;

// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class pdftes extends StatefulWidget {
  const pdftes({Key? key}) : super(key: key);

  @override
  State<pdftes> createState() => _pdftesState();
}

class _pdftesState extends State<pdftes> {
  Widget build(BuildContext context) {
    return Scaffold(body: SfPdfViewer.network(globals.manualViews));
  }
}
