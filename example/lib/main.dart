import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:native_webview/native_webview.dart';

void main() {
  // Enable integration testing with the Flutter Driver extension.
  // See https://flutter.dev/testing/ for more info.
  enableFlutterDriverExtension();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: WebView(
          initialUrl: "https://flutter.dev/",
        ),
      ),
    );
  }
}
