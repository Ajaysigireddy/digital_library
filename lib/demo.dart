import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:pdf_render/pdf_render_widgets.dart';

class PDFViewer extends StatefulWidget {
  static const String route = "PDFViewer";
  const PDFViewer({Key? key, required this.pdfUrl, required String isbn}) : super(key: key);

  final String pdfUrl;

  @override
  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  @override
  void initState() {
    // TODO: implement initState
    print(widget.pdfUrl);
    super.initState();
  }

  final controller = PdfViewerController();
  TapDownDetails? doubleTapDetails;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Prescription View',
                      textAlign: TextAlign.center,
                  
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: FutureBuilder<File>(
                  future: DefaultCacheManager().getSingleFile(widget.pdfUrl),
                  builder: (context, snapshot) => snapshot.hasData
                      ? GestureDetector(
                          onDoubleTapDown: (details) => doubleTapDetails = details,
                          onDoubleTap: () => controller.ready?.setZoomRatio(
                            zoomRatio: controller.zoomRatio * 1.5,
                            center: doubleTapDetails?.localPosition,
                          ),
                          child: PdfViewer.openFile(
                            snapshot.data!.path,
                            viewerController: controller,
                          ),
                        )
                      : Container(
                          child: Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}