import 'package:flutter/material.dart';
import 'pdf_viewer_screen.dart';

class PdfButtonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Button Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PdfViewerScreen(pdfAssetPath: 'assets/b.pdf'),
              ),
            );
          },
          child: Text('View PDF'),
        ),
      ),
    );
  }
}
