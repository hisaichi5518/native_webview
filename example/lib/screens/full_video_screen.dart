import 'package:flutter/material.dart';
import 'package:native_webview/native_webview.dart';

class FullVideoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Full video URL"),
      ),
      body: WebView(
        initialUrl: "https://dplayer.js.org/",
      ),
    );
  }
}
