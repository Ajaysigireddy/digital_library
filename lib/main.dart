import 'package:fllutter/screens/login_Screen.dart';
import 'package:flutter/material.dart';
import 'package:fllutter/screens/library_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Library @rcts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200], // Adjust background color
      ),
      home: LoginPage(),
    );
  }
}
