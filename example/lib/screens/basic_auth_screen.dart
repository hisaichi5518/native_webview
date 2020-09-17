import 'package:flutter/material.dart';
import 'package:native_webview/native_webview.dart';

class BasicAuthScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BasicAuthScreenState();
  }
}

class _BasicAuthScreenState extends State<BasicAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Basic Auth"),
      ),
      body: WebView(
        initialUrl: 'https://native-webview-basic-auth.herokuapp.com/',
        onReceivedHttpAuthRequest: (controller, challenge) async {
          return ReceivedHttpAuthResponse.useCredential(
            "username",
            "password",
          );
        },
      ),
    );
  }
}
