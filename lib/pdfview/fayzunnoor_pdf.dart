import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../core/app_colors.dart';
import '../core/app_theme_colors.dart';

class Fayzunoorpdf extends StatefulWidget {
  final String path;
  final String title;

  Fayzunoorpdf({required this.path,required this.title});

  @override
  State<Fayzunoorpdf> createState() => _FayzunoorpdfState();
}

class _FayzunoorpdfState extends State<Fayzunoorpdf> {
  late final PdfViewerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PdfViewerController();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.dispose();
    });
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: AppColors.emeraldDeepColor,
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(
              color: AppColors.antiqueGoldColor,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'Amiri'),
        ),
      ),
      body: RepaintBoundary(
        child: SfPdfViewer.asset(
          widget.path,
          controller: _controller,
          scrollDirection: PdfScrollDirection.vertical,
        ),
      ),
    );
  }
}
