import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Fayzunoorpdf extends StatelessWidget {
  final String path;
  final String title;

  Fayzunoorpdf({required this.path,required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'AutourOne'),
        ),
      ),
      body: SfPdfViewer.asset(
        path,
        scrollDirection: PdfScrollDirection.vertical,
      ),
    );
  }
}
