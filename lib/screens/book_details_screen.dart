import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fllutter/colors.dart'; // Custom colors
import 'package:fllutter/pdf.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart'; // Assuming you're using this for PDF viewing
import '../book.dart'; // Assuming you have a Book class defined elsewhere
import 'pdf_viewer_screen.dart'; // Assuming PdfViewerPage is defined here

class BookDetailsScreen extends StatefulWidget {
  final Book book;
  final String pdfUrl; // Full URL for the PDF to display

  const BookDetailsScreen({Key? key, required this.book, required this.pdfUrl}) : super(key: key);

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
    String pdfPath = _extractPdfPath(widget.pdfUrl); // Extract path from full URL
    if (pdfPath.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewerPage(
            s3BucketName: dotenv.env['S3_BUCKET_NAME']!,
            s3Region: dotenv.env['S3_REGION']!,
            s3AccessKey: dotenv.env['S3_ACCESS_KEY']!,
            s3SecretKey: dotenv.env['S3_SECRET_KEY']!,
            fileName: pdfPath,
          ),
        ),
      );
    } else {
      // Handle case where pdfPath is empty or invalid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid PDF URL'),
        ),
      );
    }
  }

  String _extractPdfPath(String url) {
    // Assuming the URL structure is consistent and the PDF path starts after the bucket URL
    const String baseUrl = 'https://etl-pe-003.s3.ap-south-1.amazonaws.com/';
    if (url.startsWith(baseUrl)) {
      return url.substring(baseUrl.length);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          widget.book.title,
          style: TextStyle(color: Color.fromARGB(255, 122, 164, 212)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Card(
          color: AppColors.backgroundColor,
          elevation: 8.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: double.infinity,
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
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Authors: ${widget.book.authors.join(', ')}',
                        style: TextStyle(fontSize: 18.0, color: AppColors.textColor),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Publisher: ${widget.book.publisher}',
                        style: TextStyle(fontSize: 18.0, color: AppColors.textColor),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Subject: ${widget.book.subject}',
                        style: TextStyle(fontSize: 18.0, color: AppColors.textColor),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Reads: ${widget.book.reads}',
                        style: TextStyle(fontSize: 18.0, color: AppColors.textColor),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Focus(
                            focusNode: _readButtonFocusNode,
                            onFocusChange: (hasFocus) {
                              setState(() {});
                            },
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonColor,
                                side: BorderSide(
                                  color: _readButtonFocusNode.hasFocus ? Colors.white : Colors.transparent,
                                  width: 2.0,
                                ),
                                elevation: _readButtonFocusNode.hasFocus ? 10.0 : 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                shadowColor: _readButtonFocusNode.hasFocus ? Colors.red : Colors.transparent,
                              ),
                              onPressed: () {
                                openPdfViewer(context);
                              },
                              child: Text(
                                'Read',
                                style: TextStyle(
                                  color: _readButtonFocusNode.hasFocus
                                      ? const Color.fromARGB(255, 255, 255, 255)
                                      : Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Focus(
                            focusNode: _continueReadingButtonFocusNode,
                            onFocusChange: (hasFocus) {
                              setState(() {});
                            },
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonColor,
                                side: BorderSide(
                                  color: _continueReadingButtonFocusNode.hasFocus ? Colors.white : Colors.transparent,
                                  width: 2.0,
                                ),
                                elevation: _continueReadingButtonFocusNode.hasFocus ? 10.0 : 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                shadowColor: _continueReadingButtonFocusNode.hasFocus ? Colors.red : Colors.transparent,
                              ),
                              onPressed: () {
                                // Implement "Continue Reading" button functionality
                              },
                              child: Text(
                                'Continue Reading',
                                style: TextStyle(
                                  color: _continueReadingButtonFocusNode.hasFocus
                                      ? const Color.fromARGB(255, 255, 255, 255)
                                      : Color.fromARGB(255, 255, 255, 255),
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
