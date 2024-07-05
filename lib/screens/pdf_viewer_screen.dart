import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatelessWidget {
  final String pdfAssetPath;

  const PdfViewerScreen({Key? key, required this.pdfAssetPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: Center(
        child: SfPdfViewer.asset(
          pdfAssetPath,
          // Customize further with options like initialPage, enableDoubleTapZooming, etc.
          // initialPage: 0,
          // enableDoubleTapZooming: true,
          // ...
        ),
      ),
    );
  }
}
