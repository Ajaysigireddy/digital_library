import 'package:fllutter/screens/library_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter PDF Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LibraryScreen(),
    );
  }
}
