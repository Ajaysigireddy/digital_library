import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class InternetConnectionCheck extends StatefulWidget {
  final ValueNotifier<bool> connectionStatusNotifier;

  InternetConnectionCheck({required this.connectionStatusNotifier});

  @override
  InternetConnectionCheckState createState() => InternetConnectionCheckState();
}

class InternetConnectionCheckState extends State<InternetConnectionCheck> {
  @override
  void initState() {
    super.initState();
    initConnectivity();
    Connectivity().onConnectivityChanged.listen((result) {
      widget.connectionStatusNotifier.value = result != ConnectivityResult.none;
      if (result == ConnectivityResult.none) {
        showSnackBar();
      }
    });
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await Connectivity().checkConnectivity();
    } catch (e) {
      print('Error: $e');
      result = ConnectivityResult.none;
    }

    if (!mounted) return;

    widget.connectionStatusNotifier.value = result != ConnectivityResult.none;
    if (result == ConnectivityResult.none) {
      showSnackBar();
    }
  }

  Future<void> retryConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    widget.connectionStatusNotifier.value = result != ConnectivityResult.none;
    if (result == ConnectivityResult.none) {
      showSnackBar();
    }
  }

  void showSnackBar() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No Internet Connection'),
          duration: Duration(days: 365), // Persistent snackbar
          action: SnackBarAction(
            label: 'Retry',
            onPressed: retryConnectivity,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // This widget doesn't need to build anything
  }
}
