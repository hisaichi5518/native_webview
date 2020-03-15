import 'package:flutter/material.dart';
import 'package:native_webview/native_webview.dart';

class OpenDropdownScreen extends StatelessWidget {
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
  <select>
    <option value="option-1">Option 1</option>
    <option value="option-2">Option 2</option>
    <option value="option-3">Option 3</option>
    <option value="option-4">Option 4</option>
  </select>
  
  <select multiple="multiple">
    <option value="option-1">Option 1</option>
    <option value="option-2">Option 2</option>
    <option value="option-3">Option 3</option>
    <option value="option-4">Option 4</option>
  </select>
</body>
</html>
          """),
      ),
    );
  }
}
