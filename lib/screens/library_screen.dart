import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fire_tv_listener/fire_tv_listener.dart'; // Import the package

import '../book.dart'; // Import your Book class
import './book_details_screen.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late List<Book> books = [];
  int selectedBookIndex = -1; // Track the index of the selected book
  final FocusNode _focusNode = FocusNode(); // Create a FocusNode instance
  final ScrollController _scrollController = ScrollController(); // Create a ScrollController instance

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Dispose the FocusNode
    _scrollController.dispose(); // Dispose the ScrollController
    super.dispose();
  }

  Future<void> fetchBooks() async {
    try {
      final response = await http.get(Uri.parse('https://pl-api.iiit.ac.in/rcts/ETL-PE-003/info/allBooks'));
      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        List<Book> fetchedBooks = responseData.map((e) => Book.fromJson(e)).toList();
        setState(() {
          books = fetchedBooks;
        });
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      print('Error fetching books: $e');
      // Handle error as needed
    }
  }

  void selectBook(int index) {
    setState(() {
      selectedBookIndex = index;
      // Scroll to the selected item
      if (selectedBookIndex != -1) {
        _scrollToItem(selectedBookIndex);
      }
    });
  }

  void _openBookDetails() {
    if (selectedBookIndex != -1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookDetailsScreen(
            book: books[selectedBookIndex],
            pdfUrl: books[selectedBookIndex].bookUrl,
          ),
        ),
      );
    }
  }

  Widget buildBookCard(int index) {
    Book book = books[index];
    bool isSelected = selectedBookIndex == index;

    return MouseRegion(
      onEnter: (_) => selectBook(index),
      onExit: (_) => selectBook(-1),
      child: GestureDetector(
        onTap: _openBookDetails,
        child: Card(
          elevation: isSelected ? 8.0 : 2.0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black, width: isSelected ? 4.0 : 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Half-sized image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  book.coverImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              // Transparent black background with book name
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.5), // Transparent black color
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    book.title,
                    style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FireTVRemoteListener(
      focusNode: _focusNode,
      onUp: () => _navigate(Direction.up),
      onDown: () => _navigate(Direction.down),
      onLeft: () => _navigate(Direction.left),
      onRight: () => _navigate(Direction.right),
      onSelect: _openBookDetails,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Digital Library @rcts'),
          centerTitle: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: books.length,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(), // Enable scrolling
                  controller: _scrollController, // Assign the ScrollController
                  itemBuilder: (context, index) => buildBookCard(index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigate(Direction direction) {
    int newIndex = selectedBookIndex;

    if (direction == Direction.up && newIndex >= 4) {
      newIndex -= 4;
    } else if (direction == Direction.down && newIndex < books.length - 4) {
      newIndex += 4;
    } else if (direction == Direction.left && newIndex > 0) {
      newIndex--;
    } else if (direction == Direction.right && newIndex < books.length - 1) {
      newIndex++;
    }

    setState(() {
      selectedBookIndex = newIndex;
      // Scroll to the newly selected item
      if (selectedBookIndex != -1) {
        _scrollToItem(selectedBookIndex);
      }
    });
  }

  void _scrollToItem(int index) {
    // Calculate scroll offset based on the selected index
    double scrollOffset = index * (_scrollController.position.maxScrollExtent / books.length);
    _scrollController.animateTo(
      scrollOffset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

enum Direction { up, down, left, right }
