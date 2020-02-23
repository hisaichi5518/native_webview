import 'package:flutter/services.dart';
import 'package:native_webview/native_webview.dart';

class WebViewController {
  final WebView _widget;
  final MethodChannel _channel;

  WebViewController(this._widget, int id)
      : _channel = MethodChannel("packages.jp/native_webview_$id");

  Future<String> evaluateJavascript(String javascriptString) async {
    return _channel.invokeMethod<String>(
      'evaluateJavascript',
      javascriptString,
    );
  }

  Future<String> currentUrl() async {
    return _channel.invokeMethod<String>(
      'currentUrl',
    );
  }
}
