import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends StatefulWidget {
  final String s3BucketName;
  final String s3Region;
  final String s3AccessKey;
  final String s3SecretKey;
  final String fileName;

  PdfViewerPage({
    required this.s3BucketName,
    required this.s3Region,
    required this.s3AccessKey,
    required this.s3SecretKey,
    required this.fileName,
  });

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? localFilePath;
  PdfViewerController pdfViewerController = PdfViewerController();
  FocusNode _pdfViewerFocusNode = FocusNode();
  int _currentPage = 0;
  int _totalPages = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pdfViewerFocusNode.requestFocus();
    _initializePdfViewer();
  }

  @override
  void dispose() {
    _pdfViewerFocusNode.dispose();
    super.dispose();
  }

  void _initializePdfViewer() async {
    try {
      final url = await getSignedUrl(
        widget.s3BucketName,
        widget.fileName,
        widget.s3Region,
        widget.s3AccessKey,
        widget.s3SecretKey,
      );

      await downloadFile(url);
    } catch (e) {
      print('Error initializing PDF viewer: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> getSignedUrl(String bucket, String key, String region, String accessKey, String secretKey) async {
    final DateTime now = DateTime.now().toUtc(); // Use UTC time consistently
    final int expiry = now.add(Duration(minutes: 10)).millisecondsSinceEpoch ~/ 1000; // Consider a longer expiry for testing

    final String method = 'GET';
    final String service = 's3';
    final String host = '$bucket.s3.$region.amazonaws.com';
    final String canonicalUri = '/$key';
    final String signedHeaders = 'host';
    final String payloadHash = 'UNSIGNED-PAYLOAD';

    final String amzDate = now.toIso8601String().replaceAll(':', '').replaceAll('-', '').split('.')[0] + 'Z';
    final String dateStamp = amzDate.substring(0, 8);

    final String credentialScope = '$dateStamp/$region/$service/aws4_request';

    final String canonicalQueryString = 'X-Amz-Algorithm=AWS4-HMAC-SHA256'
        '&X-Amz-Credential=${Uri.encodeComponent('$accessKey/$credentialScope')}' // Double-check encoding
        '&X-Amz-Date=$amzDate'
        '&X-Amz-Expires=600'  // Consider a longer expiry for testing
        '&X-Amz-SignedHeaders=$signedHeaders';

    final String canonicalHeaders = 'host:$host\n';

    final String canonicalRequest = '$method\n$canonicalUri\n$canonicalQueryString\n$canonicalHeaders\n$signedHeaders\n$payloadHash';
    final String hashCanonicalRequest = sha256.convert(utf8.encode(canonicalRequest)).toString();

    final String stringToSign = 'AWS4-HMAC-SHA256\n$amzDate\n$credentialScope\n$hashCanonicalRequest';

    final signingKey = _getSignatureKey(secretKey, dateStamp, region, service); // Verify _getSignatureKey implementation
    final String signature = Hmac(sha256, signingKey).convert(utf8.encode(stringToSign)).toString();

    final String presignedUrl = 'https://$host$canonicalUri?$canonicalQueryString&X-Amz-Signature=$signature';

    return presignedUrl;
  }

  List<int> _getSignatureKey(String key, String dateStamp, String regionName, String serviceName) {
    final kDate = Hmac(sha256, utf8.encode('AWS4$key')).convert(utf8.encode(dateStamp)).bytes;
    final kRegion = Hmac(sha256, kDate).convert(utf8.encode(regionName)).bytes;
    final kService = Hmac(sha256, kRegion).convert(utf8.encode(serviceName)).bytes;
    final kSigning = Hmac(sha256, kService).convert(utf8.encode('aws4_request')).bytes;
    return kSigning;
  }

  Future<void> downloadFile(String presignedUrl) async {
    try {
      final stopwatch = Stopwatch()..start();
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/temp.pdf');
      if (await file.exists()) {
        await file.delete();
      }

      final response = await http.get(Uri.parse(presignedUrl));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        setState(() {
          localFilePath = file.path;
          _isLoading = false;
        });
        print('Download time: ${stopwatch.elapsedMilliseconds} ms');
      } else {
        print('Failed to download file: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error downloading file: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (_pdfViewerFocusNode.hasFocus) {
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          // Handle scroll up logic if needed
        } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          // Handle scroll down logic
        } else if (event.logicalKey == LogicalKeyboardKey.select) {
          _showPageJumpDialog(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : localFilePath != null
                ? RawKeyboardListener(
                    focusNode: _pdfViewerFocusNode,
                    onKey: _handleKeyEvent,
                    child: SfPdfViewer.file(
                      File(localFilePath!),
                      controller: pdfViewerController,
                      onPageChanged: (PdfPageChangedDetails details) {
                        setState(() {
                          _currentPage = details.newPageNumber;
                        });
                      },
                      onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                        setState(() {
                          _totalPages = details.document.pages.count;
                        });
                      },
                      onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                        print('Document load failed: ${details.error}');
                      },
                    ),
                  )
                : Text('Error loading PDF'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showPageJumpDialog(context);
        },
        tooltip: 'Jump to Page',
        child: Icon(Icons.forward),
      ),
    );
  }

  void _showPageJumpDialog(BuildContext context) {
    int currentPage = _currentPage;
    int totalPages = _totalPages;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController pageController =
            TextEditingController(text: (currentPage).toString());

        return AlertDialog(
          title: Text('Jump to Page'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: pageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Page Number'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                int pageNumber = int.tryParse(pageController.text) ?? 1;
                if (pageNumber >= 1 && pageNumber <= totalPages) {
                  pdfViewerController.jumpToPage(pageNumber);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invalid page number!'),
                    ),
                  );
                }
                Navigator.pop(context);
              },
              child: Text('Go'),
            ),
          ],
        );
      },
    );
  }
}
