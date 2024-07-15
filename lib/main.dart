import 'package:fllutter/screens/library_screen.dart';
import 'package:fllutter/screens/login_Screen.dart';
import 'package:flutter/material.dart';
import './screens/login_Screen.dart';
import './screens/library_screen.dart'; // Adjust the import according to your project structure

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
      
        '/': (context) => LibraryScreen(), // Adjust the route name and widget according to your project
      },
    );
  }
}
