import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dpad_container/dpad_container.dart'; // Import DpadContainer
import '../colors.dart';
import '../book.dart';
import './book_details_screen.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  Map<String, List<Book>> booksBySubject = {};
  int selectedBookIndex = -1;
  String? selectedSubject;
  final ScrollController _scrollController = ScrollController();

  // Pagination variables
  int currentPage = 1;
  bool isLoading = false;
  bool hasMoreBooks = true;

  @override
  void initState() {
    super.initState();
    fetchBooks();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchBooks() async {
    if (isLoading || !hasMoreBooks) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'https://pl-api.iiit.ac.in/rcts/ETL-PE-003/info/allBooks?page=$currentPage'));
      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        if (responseData.isEmpty) {
          setState(() {
            hasMoreBooks = false;
          });
        } else {
          Map<String, List<Book>> fetchedBooksBySubject = {};
          for (var item in responseData) {
            Book book = Book.fromJson(item);
            if (fetchedBooksBySubject.containsKey(book.subject)) {
              fetchedBooksBySubject[book.subject]!.add(book);
            } else {
              fetchedBooksBySubject[book.subject] = [book];
            }
          }
          setState(() {
            fetchedBooksBySubject.forEach((subject, books) {
              if (booksBySubject.containsKey(subject)) {
                booksBySubject[subject]!.addAll(books);
              } else {
                booksBySubject[subject] = books;
              }
            });
            currentPage++;
          });
        }
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      print('Error fetching books: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      fetchBooks();
    }
  }

  void selectBook(String subject, int index) {
    setState(() {
      selectedSubject = subject;
      selectedBookIndex = index;
    });

    // Navigate to BookDetailsScreen when a book is selected
    Book selectedBook = booksBySubject[subject]![index];
    _openBookDetails(selectedBook);
  }

  void _openBookDetails(Book book) {
    print(book.isbn);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsScreen(
          book: book,
           isbn:book.isbn,
        ),
      ),
      
    );
  }

  Widget buildBookCard(String subject, int index) {
    Book book = booksBySubject[subject]![index];
    bool isSelected = selectedSubject == subject && selectedBookIndex == index;

    return DpadContainer(
      onClick: () => selectBook(subject, index),
      onFocus: (bool isFocused) {
        if (isFocused) {
          setState(() {
            selectedSubject = subject;
            selectedBookIndex = index;
          });
        }
      },
      child: Container(
     
        decoration: BoxDecoration(
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Color.fromARGB(255, 250, 0, 0).withOpacity(1.0),
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Card(
          elevation: isSelected ? 8.0 : 2.0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: isSelected ? AppColors.focusColor : Colors.transparent,
              width: isSelected ? 4.0 : 0.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  book.coverImageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    }
                  },
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
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
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          'Digital Library @rcts',
          style: TextStyle(color: AppColors.textColor),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          controller: _scrollController,
          children: booksBySubject.entries.map((entry) {
            String subject = entry.key;
            List<Book> books = entry.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 8.0),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6, // Adjust based on your design
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    return buildBookCard(subject, index);
                  },
                ),
                SizedBox(height: 16.0),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}