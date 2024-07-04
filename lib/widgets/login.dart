import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          focusNode: _usernameFocus,
          decoration: InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) {
            FocusScope.of(context).requestFocus(_passwordFocus);
          },
        ),
        SizedBox(height: 20.0),
        TextField(
          focusNode: _passwordFocus,
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
          onSubmitted: (_) {
            _submitForm(context);
          },
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () {
            _submitForm(context);
          },
          child: Text('Login'),
        ),
      ],
    );
  }

  void _submitForm(BuildContext context) {
    // Implement your login functionality here
    // For example:
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Logging in...')),
    // );
  }
}
