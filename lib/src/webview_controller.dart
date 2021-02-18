import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:native_webview/native_webview.dart';

typedef JavascriptHandlerCallback = Future<void> Function(
    List<dynamic>? arguments);

class WebViewController {
  final WebView _widget;
  final MethodChannel _channel;
  final Map<String, JavascriptHandlerCallback> _javascriptChannelMap = {};
  final void Function() updateFirstLoading;

  WebViewController(this._widget, int id, this.updateFirstLoading)
      : _channel = MethodChannel("com.hisaichi5518/native_webview_$id") {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  Future<dynamic> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onPageStarted':
        updateFirstLoading();

        final onPageStarted = _widget.onPageStarted;
        if (onPageStarted != null) {
          onPageStarted(this, call.arguments['url'] as String?);
        }
        return true;
      case 'onPageFinished':
        updateFirstLoading();
        final onPageFinished = _widget.onPageFinished;
        if (onPageFinished != null) {
          onPageFinished(this, call.arguments['url'] as String?);
        }
        return true;
      case 'onWebResourceError':
        final onWebResourceError = _widget.onWebResourceError;
        if (onWebResourceError == null) {
          return true;
        }
        onWebResourceError(
          WebResourceError(
            errorCode: call.arguments['errorCode'],
            description: call.arguments['description'],
            domain: call.arguments['domain'],
            errorType: call.arguments['errorType'] == null
                ? null
                : WebResourceErrorType.values.firstWhere(
                    (WebResourceErrorType type) {
                      return type.toString() ==
                          '$WebResourceErrorType.${call.arguments['errorType']}';
                    },
                  ),
          ),
        );
        return true;
      case 'onProgressChanged':
        final onProgressChanged = _widget.onProgressChanged;
        if (onProgressChanged != null) {
          onProgressChanged(this, call.arguments['progress'] as int?);
        }
        return true;
      case 'onJavascriptHandler':
        final name = call.arguments['handlerName'] as String?;
        final args = call.arguments['args'] as String?;
        if (name != null && args != null) {
          final value = _javascriptChannelMap[name];
          if (value != null) {
            await value(jsonDecode(args));
          }
        }
        return true;
      case 'onJsConfirm':
        final message = call.arguments['message'] as String?;
        final onJsConfirm = _widget.onJsConfirm;
        if (onJsConfirm == null) {
          return {};
        }
        return onJsConfirm(this, message).toMap();
      case 'onJsAlert':
        final message = call.arguments['message'] as String?;
        final onJsAlert = _widget.onJsAlert;
        if (onJsAlert == null) {
          return {};
        }
        return onJsAlert(this, message).toMap();
      case 'onJsPrompt':
        final message = call.arguments['message'] as String?;
        final defaultText = call.arguments['defaultText'] as String?;

        final onJsPrompt = _widget.onJsPrompt;
        if (onJsPrompt == null) {
          return {};
        }
        return onJsPrompt(this, message, defaultText).toMap();
      case 'shouldOverrideUrlLoading':
        final shouldOverrideUrlLoading = _widget.shouldOverrideUrlLoading;
        if (shouldOverrideUrlLoading == null) {
          return {};
        }

        final url = call.arguments['url'] as String?;
        final method = call.arguments['method'] as String?;
        final headers = call.arguments['headers']?.cast<String, String>();
        final isForMainFrame = call.arguments['isForMainFrame'] as bool?;
        final request = ShouldOverrideUrlLoadingRequest(
          url: url,
          method: method,
          headers: headers,
          isForMainFrame: isForMainFrame,
        );
        return (await shouldOverrideUrlLoading(this, request)).toMap();
      case 'onReceivedHttpAuthRequest':
        final onReceivedHttpAuthRequest = _widget.onReceivedHttpAuthRequest;
        if (onReceivedHttpAuthRequest == null) {
          return {};
        }

        final host = call.arguments['host'] as String?;
        final realm = call.arguments['realm'] as String?;
        final request = HttpAuthChallenge(
          host: host,
          realm: realm,
        );
        return (await onReceivedHttpAuthRequest(this, request)).toMap();
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

  Future<String?> currentUrl() async {
    return _channel.invokeMethod<String>(
      'currentUrl',
    );
  }

  Future<void> loadUrl(String url, {Map<String, String>? headers}) async {
    return _channel.invokeMethod<void>(
      'loadUrl',
      <String, dynamic>{
        'url': url,
        'headers': headers,
      },
    );
  }

  Future<bool?> canGoBack() async {
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

  Future<bool?> canGoForward() async {
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

  JavascriptHandlerCallback? removeJavascriptHandler(String name) {
    return _javascriptChannelMap.remove(name);
  }
}
