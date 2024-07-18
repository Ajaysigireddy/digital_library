import 'package:flutter/material.dart';
import 'package:fllutter/connectionCheck.dart'; 
import '../widgets/login.dart'; 


class LoginPage extends StatelessWidget {
  final ValueNotifier<bool> connectionStatusNotifier = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<bool>(
        valueListenable: connectionStatusNotifier,
        builder: (context, hasConnection, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                InternetConnectionCheck(
                    connectionStatusNotifier: connectionStatusNotifier),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    width: 400.0, // Adjust width based on TV screen size
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/images/logo.png'),
                        Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 36.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20.0),
                        LoginForm(), // Use the LoginForm widget here
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
