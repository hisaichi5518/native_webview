import 'package:flutter/services.dart';
import 'package:native_webview/native_webview.dart';

class WebViewController {
  final WebView _widget;
  final MethodChannel _channel;

  WebViewController(this._widget, int id)
      : _channel = MethodChannel("packages.jp/native_webview_$id") {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  Future<bool> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onPageStarted':
        _widget.onPageStarted(this, call.arguments['url'] as String);
        return null;
      case 'onPageFinished':
        _widget.onPageFinished(this, call.arguments['url'] as String);
        return null;
      case 'onProgressChanged':
        _widget.onProgressChanged(this, call.arguments['progress'] as int);
        return null;
    }
    throw MissingPluginException(
      '${call.method} was invoked but has no handler',
    );
  }

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

  Future<void> loadUrl(String url, {Map<String, String> headers}) async {
    return _channel.invokeMethod<void>(
      'loadUrl',
      <String, dynamic>{
        'url': url,
        'headers': headers,
      },
    );
  }
}
