import 'package:flutter/material.dart';
import 'package:native_webview/native_webview.dart';

class OnJsPromptScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Open the dropdown"),
      ),
      body: WebView(
        initialData: WebViewData("""
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
</head>
<body>
  name is <div id="name"></div>
  <script>
  let name = window.prompt("your name", "aaaa");
  document.querySelector("div").textContent = name;
  </script>
</body>
</html>
          """),
      ),
    );
  }
}
