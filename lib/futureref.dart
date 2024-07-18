import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dpad_container/dpad_container.dart';

class PDFViewer extends StatefulWidget {
  static const String route = "PDFViewer";
  const PDFViewer({Key? key, required this.isbn}) : super(key: key);

  final String isbn;

  @override
  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  String? _presignedUrl;
  final controller = PdfViewerController();
  TapDownDetails? doubleTapDetails;

  @override
  void initState() {
    super.initState();
    _fetchPresignedUrl();
  }

  Future<void> _fetchPresignedUrl() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String username = prefs.getString('username') ?? 'hariuser';
      print(username);

      final url = 'https://pl-api.iiit.ac.in/rcts/ETL-PE-003/info/signedBook';
      final response = await http.get(
        Uri.parse('$url?username=$username&isbn=${widget.isbn}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _presignedUrl = jsonDecode(response.body)['signedUrl'];
        });
        print(_presignedUrl);
      } else {
        throw Exception('Failed to fetch presigned URL: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching presigned URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: DpadContainer(
          onClick: () {
            // Handle click event (if needed)
          },
          onFocus: (bool isFocused) {
            // Handle focus change (if needed)
          },
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
                            size: 30.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: _presignedUrl == null
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : FutureBuilder<File>(
                          future: DefaultCacheManager().getSingleFile(_presignedUrl!),
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
                              : Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
