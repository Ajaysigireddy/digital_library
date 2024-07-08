import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for handling key events
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfAssetPath;

  PdfViewerScreen({Key? key, required this.pdfAssetPath}) : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final PdfViewerController pdfViewerController = PdfViewerController();
  final FocusNode _pdfViewerFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Set initial focus
    _pdfViewerFocusNode.requestFocus();
    // Listen for raw key events
    RawKeyboard.instance.addListener(_handleKeyEvent);
  }

  @override
  void dispose() {
    // Clean up
    RawKeyboard.instance.removeListener(_handleKeyEvent);
    _pdfViewerFocusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (_pdfViewerFocusNode.hasFocus) {
        // Handle directional navigation
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          // Navigate up logic
        } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          // Navigate down logic
        } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          // Navigate left logic
        } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          // Navigate right logic
        } else if (event.logicalKey == LogicalKeyboardKey.select) {
          // OK/Enter key logic (e.g., show page jump dialog)
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
        child: Focus(
          focusNode: _pdfViewerFocusNode,
          child: SfPdfViewer.asset(
            widget.pdfAssetPath,
            controller: pdfViewerController,
            onPageChanged: (PdfPageChangedDetails details) {
              // Handle page change
              print('Page changed to: ${details.newPageNumber}');
            },
            onDocumentLoaded: (PdfDocumentLoadedDetails details) {
              // Document is loaded, you can get the total number of pages here
              int totalPages = pdfViewerController.pageCount;
              print('Total pages: $totalPages');
            },
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
              // Handle document load failures here
              print('Document load failed: ${details.error}');
            },
            enableDoubleTapZooming: true,
            enableTextSelection: true,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showPageJumpDialog(context);
        },
        tooltip: 'Jump to Page',
        child: Icon(Icons.forward), // Replace with appropriate icon
      ),
    );
  }

  void _showPageJumpDialog(BuildContext context) {
    int currentPage = pdfViewerController.pageNumber;
    int totalPages = pdfViewerController.pageCount;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController pageController =
            TextEditingController(text: (currentPage + 1).toString());

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
                  pdfViewerController.jumpToPage(pageNumber - 1);
                } else {
                  // Handle invalid page number input
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
