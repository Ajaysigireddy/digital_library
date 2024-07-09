import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../book.dart';

class BookDetailsScreen extends StatefulWidget {
  final Book book;
  final String pdfUrl; // URL for the PDF to display

  const BookDetailsScreen({Key? key, required this.book, required this.pdfUrl})
      : super(key: key);

  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  late FocusNode _readButtonFocusNode;
  late FocusNode _continueReadingButtonFocusNode;

  @override
  void initState() {
    super.initState();
    _readButtonFocusNode = FocusNode();
    _continueReadingButtonFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _readButtonFocusNode.dispose();
    _continueReadingButtonFocusNode.dispose();
    super.dispose();
  }

  void openPdfViewer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerScreen(pdfUrl: widget.pdfUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.book.title,
          style: TextStyle(color: Color.fromARGB(255, 122, 164, 212)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // White arrow icon
          onPressed: () {
            Navigator.pop(context); // Navigate back when pressed
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Card(
          color: Colors.black,
          elevation: 8.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: double.infinity, // Ensure the image takes full height
                  child: Image.network(
                    widget.book.coverImageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.book.title,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Authors: ${widget.book.authors.join(', ')}',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Publisher: ${widget.book.publisher}',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Subject: ${widget.book.subject}',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Reads: ${widget.book.reads}',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Focus(
                            focusNode: _readButtonFocusNode,
                            onFocusChange: (hasFocus) {
                              setState(() {}); // Rebuild widget on focus change
                            },
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 115, 224, 224),
                                shadowColor: Colors.white,
                                side: BorderSide(
                                  color: _readButtonFocusNode.hasFocus
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 2.0,
                                ),
                              ),
                              onPressed: () {
                                openPdfViewer(context); // Navigate to PDF viewer
                              },
                              child: Text(
                                'Read',
                                style: TextStyle(
                                  color: _readButtonFocusNode.hasFocus
                                      ? Colors.black
                                      : Color.fromARGB(255, 3, 3, 3),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Focus(
                            focusNode: _continueReadingButtonFocusNode,
                            onFocusChange: (hasFocus) {
                              setState(() {}); // Rebuild widget on focus change
                            },
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 115, 224, 224),
                                side: BorderSide(
                                  color: _continueReadingButtonFocusNode.hasFocus
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 2.0,
                                ),
                              ),
                              onPressed: () {
                                // Implement "Continue Reading" button functionality
                              },
                              child: Text(
                                'Continue Reading',
                                style: TextStyle(
                                  color: _continueReadingButtonFocusNode.hasFocus
                                      ? Colors.black
                                      : Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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

class PdfViewerScreen extends StatelessWidget {
  final String pdfUrl;

  const PdfViewerScreen({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfPdfViewer.network(
        pdfUrl,
        // Use any additional configurations as needed
      ),
    );
  }
}
