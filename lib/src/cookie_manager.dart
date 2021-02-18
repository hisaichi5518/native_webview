import 'dart:async';

import 'package:flutter/services.dart';

class Cookie {
  String? name;

  dynamic value;

  Cookie(this.name, this.value);
}

class CookieManager {
  static CookieManager? _instance;
  static const MethodChannel _channel =
      MethodChannel('com.hisaichi5518/native_webview_cookie_manager');

  static CookieManager instance() {
    final instance = _instance;
    return (instance != null) ? instance : _init();
  }

  static CookieManager _init() {
    _channel.setMethodCallHandler(_handleMethod);
    final instance = CookieManager();
    _instance = instance;
    return instance;
  }

  static Future<dynamic> _handleMethod(MethodCall call) async {}

  Future<void> setCookie({
    required String url,
    required String name,
    required String value,
    String? domain,
    String path = "/",
    Duration? maxAge,
    bool? isSecure,
  }) async {
    assert(url.isNotEmpty);
    assert(name.isNotEmpty);
    assert(value.isNotEmpty);
    assert(path.isNotEmpty);

    final args = <String, dynamic>{
      "url": url,
      "name": name,
      "value": value,
      "domain": domain,
      "path": path,
      "maxAge": maxAge != null && maxAge.inSeconds > 0
          ? maxAge.inSeconds.toString()
          : null,
      "isSecure": isSecure,
    };
    await _channel.invokeMethod('setCookie', args);
  }

  Future<List<Cookie>> getCookies({
    required String url,
    String? name,
  }) async {
    assert(url.isNotEmpty);

    final args = <String, dynamic>{
      "url": url,
    };
    var cookieListMap = await (_channel.invokeMethod('getCookies', args)
        as FutureOr<List<dynamic>>);
    cookieListMap = cookieListMap.cast<Map<dynamic, dynamic>>();
    final cookies = <Cookie>[];

    for (final cookie in cookieListMap) {
      if (name != null && name.isNotEmpty) {
        if (cookie["name"] == name) {
          cookies.add(Cookie(cookie["name"], cookie["value"]));
        }
      } else {
        cookies.add(Cookie(cookie["name"], cookie["value"]));
      }
    }

    return cookies;
  }

  Future<void> deleteAllCookies() async {
    final args = <String, dynamic>{};
    await _channel.invokeMethod('deleteAllCookies', args);
  }
}
