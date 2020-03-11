import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:native_webview/native_webview.dart';

typedef Future<void> JavascriptHandlerCallback(List<dynamic> arguments);

class WebViewController {
  final WebView _widget;
  final MethodChannel _channel;
  final Map<String, JavascriptHandlerCallback> _javascriptChannelMap = {};

  WebViewController(this._widget, int id)
      : _channel = MethodChannel("packages.jp/native_webview_$id") {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  Future<dynamic> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onPageStarted':
        if (_widget.onPageStarted != null) {
          _widget.onPageStarted(this, call.arguments['url'] as String);
        }
        return true;
      case 'onPageFinished':
        if (_widget.onPageFinished != null) {
          _widget.onPageFinished(this, call.arguments['url'] as String);
        }
        return true;
      case 'onProgressChanged':
        if (_widget.onProgressChanged != null) {
          _widget.onProgressChanged(this, call.arguments['progress'] as int);
        }
        return true;
      case 'onJavascriptHandler':
        final name = call.arguments['handlerName'] as String;
        final args = call.arguments['args'] as String;

        if (_javascriptChannelMap.containsKey(name)) {
          await _javascriptChannelMap[name](jsonDecode(args));
        }
        return true;
      case 'onJsConfirm':
        final message = call.arguments['message'] as String;
        if (_widget.onJsConfirm == null) {
          return {};
        }
        return _widget.onJsConfirm(this, message)?.toMap();
      case 'onJsAlert':
        final message = call.arguments['message'] as String;
        if (_widget.onJsAlert == null) {
          return {};
        }
        return _widget.onJsAlert(this, message)?.toMap();
      case 'onJsPrompt':
        final message = call.arguments['message'] as String;
        final defaultText = call.arguments['defaultText'] as String;
        if (_widget.onJsPrompt == null) {
          return {};
        }
        return _widget.onJsPrompt(this, message, defaultText)?.toMap();
    }
    throw MissingPluginException(
      '${call.method} was invoked but has no handler',
    );
  }

  Future<dynamic> evaluateJavascript(String javascriptString) async {
    final data = await _channel.invokeMethod<dynamic>(
      'evaluateJavascript',
      javascriptString,
    );
    if (data != null && Platform.isAndroid) {
      return jsonDecode(data);
    }
    return data;
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

  Future<bool> canGoBack() async {
    return _channel.invokeMethod<bool>(
      'canGoBack',
      <String, dynamic>{},
    );
  }

  Future<void> goBack() async {
    return _channel.invokeMethod<void>(
      'goBack',
      <String, dynamic>{},
    );
  }

  Future<bool> canGoForward() async {
    return _channel.invokeMethod<bool>(
      'canGoForward',
      <String, dynamic>{},
    );
  }

  Future<void> goForward() async {
    return _channel.invokeMethod<void>(
      'goForward',
      <String, dynamic>{},
    );
  }

  void addJavascriptHandler(String name, JavascriptHandlerCallback callback) {
    assert(!_javascriptChannelMap.containsKey(name));
    _javascriptChannelMap[name] = callback;
  }

  JavascriptHandlerCallback removeJavascriptHandler(String name) {
    return _javascriptChannelMap.remove(name);
  }
}
