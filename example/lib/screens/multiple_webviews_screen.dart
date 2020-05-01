import 'package:flutter/material.dart';
import 'package:native_webview/native_webview.dart';

class MultipleWebViewsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MultipleWebViewsScreenState();
  }
}

class _MultipleWebViewsScreenState extends State<MultipleWebViewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Initial URL"),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 200,
            child: WebView(
              initialUrl: "https://flutter.dev",
            ),
          ),
          SizedBox(
            height: 200,
            child: WebView(
              initialUrl: "https://flutter.dev",
            ),
          ),
        ],
      ),
    );
  }
}
