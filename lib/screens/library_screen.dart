import 'package:flutter/material.dart';
import 'package:fllutter/widgets/navbar.dart';
import 'package:fllutter/widgets/searchBar.dart';

class LibraryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Library @rcts'),
        centerTitle: false, // Align title to the left
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          NavBar(), // Navigation bar
          SearchBar(), // Search bar
          // Add more widgets for library content below
          // Example: Library content widgets (books, videos, etc.)
        ],
      ),
    );
  }
}
