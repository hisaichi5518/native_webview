import 'package:flutter/material.dart';
import 'package:native_webview/native_webview.dart';

class InitialUrlScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Initial URL"),
      ),
      body: WebView(
        initialUrl: "https://flutter.dev",
      ),
    );
  }
}
