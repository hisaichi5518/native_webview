import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class AndroidWebViewInfo {
  ///The name of Android WebView package. From the <manifest> tag's "name" attribute.
  final String? packageName;

  ///The version name of Android WebView package, as specified by the <manifest> tag's versionName attribute.
  final String? versionName;

  AndroidWebViewInfo._(this.packageName, this.versionName);

  factory AndroidWebViewInfo.fromMap(Map<dynamic, dynamic>? mapping) {
    return AndroidWebViewInfo._(
      mapping!["packageName"],
      mapping["versionName"],
    );
  }
}

class WebViewManager {
  static WebViewManager? _instance;
  static const MethodChannel _channel =
      MethodChannel('com.hisaichi5518/native_webview_webview_manager');

  static WebViewManager instance() {
    return (_instance != null) ? _instance! : _init();
  }

  static WebViewManager _init() {
    _channel.setMethodCallHandler(_handleMethod);
    _instance = WebViewManager();
    return _instance!;
  }

  static Future<dynamic> _handleMethod(MethodCall call) async {}

  Future<AndroidWebViewInfo?> get androidWebViewInfo async {
    if (!Platform.isAndroid) {
      return null;
    }

    final mapping = await (_channel.invokeMethod<Map<dynamic, dynamic>>(
      'getAndroidWebViewInfo',
      <String, dynamic>{},
    ));
    return AndroidWebViewInfo.fromMap(mapping);
  }
}
