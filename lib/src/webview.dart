import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:native_webview/platform_interface.dart';
import 'package:native_webview/src/android_webview.dart';
import 'package:native_webview/src/content_blocker.dart';
import 'package:native_webview/src/cupertino_webview.dart';
import 'package:native_webview/src/javascript_callback.dart';
import 'package:native_webview/src/web_resource_error.dart';
import 'package:native_webview/src/webview_controller.dart';

///Initial [data] as a content for an [WebViewData] instance, using [baseUrl] as the base URL for it.
class WebViewData {
  ///A String of data in the given encoding.
  String data;

  ///The MIME type of the data, e.g. "text/html". The default value is `"text/html"`.
  String mimeType;

  ///The encoding of the data. The default value is `"utf8"`.
  String encoding;

  ///The URL to use as the page's base URL. The default value is `about:blank`.
  String baseUrl;

  ///The URL to use as the history entry. The default value is `about:blank`. If non-null, this must be a valid URL. This parameter is used only on Android.
  String historyUrl;

  WebViewData(
    this.data, {
    this.mimeType = "text/html",
    this.encoding = "utf8",
    this.baseUrl = "about:blank",
    this.historyUrl = "about:blank",
  });

  Map<String, String> toMap() {
    return {
      "data": data,
      "mimeType": mimeType,
      "encoding": encoding,
      "baseUrl": baseUrl,
      "historyUrl": historyUrl
    };
  }
}

class ShouldOverrideUrlLoadingRequest {
  final String? url;

  final String? method;

  final Map<String, String>? headers;

  final bool? isForMainFrame;

  ShouldOverrideUrlLoadingRequest({
    this.url,
    this.method,
    this.headers,
    this.isForMainFrame,
  });
}

enum ShouldOverrideUrlLoadingAction {
  allow,
  cancel,
}

extension ShouldOverrideUrlLoadingActionExtension
    on ShouldOverrideUrlLoadingAction {
  Map<String, dynamic> toMap() {
    return {
      "action": index,
    };
  }
}

class HttpAuthChallenge {
  final String? host;
  final String? realm;

  HttpAuthChallenge({this.host, this.realm});
}

enum ReceivedHttpAuthResponseAction {
  useCredential,
  cancel,
}

class ReceivedHttpAuthResponse {
  final ReceivedHttpAuthResponseAction action;
  final String? username;
  final String? password;

  factory ReceivedHttpAuthResponse.useCredential(
    String username,
    String password,
  ) {
    return ReceivedHttpAuthResponse._(
      ReceivedHttpAuthResponseAction.useCredential,
      username,
      password,
    );
  }

  factory ReceivedHttpAuthResponse.cancel() {
    return ReceivedHttpAuthResponse._(
      ReceivedHttpAuthResponseAction.cancel,
      null,
      null,
    );
  }

  ReceivedHttpAuthResponse._(
    this.action,
    this.username,
    this.password,
  );

  Map<String, dynamic> toMap() {
    return {
      "action": action.index,
      "username": username,
      "password": password,
    };
  }
}

class WebView extends StatelessWidget {
  static const String viewType = "com.hisaichi5518/native_webview";

  static PlatformWebView? _platform;

  static set platform(PlatformWebView? platform) {
    _platform = platform;
  }

  static PlatformWebView? get platform {
    if (_platform == null) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          _platform = AndroidWebView();
          break;
        case TargetPlatform.iOS:
          _platform = CupertinoWebView();
          break;
        default:
          throw UnsupportedError(
            "Trying to use the default webview implementation for $defaultTargetPlatform but there isn't a default one",
          );
      }
    }
    return _platform;
  }

  final String? initialUrl;
  final String? initialFile;
  final Map<String, String>? initialHeaders;
  final WebViewData? initialData;

  final void Function(WebViewController)? onWebViewCreated;
  final FutureOr<void> Function(WebViewController, String?)? onPageStarted;
  final FutureOr<void> Function(WebViewController, String?)? onPageFinished;
  final FutureOr<void> Function(WebResourceError error)? onWebResourceError;
  final FutureOr<void> Function(WebViewController, int)? onProgressChanged;

  final JsConfirmCallback? onJsConfirm;
  final JsAlertCallback? onJsAlert;
  final JsPromptCallback? onJsPrompt;

  final FutureOr<ShouldOverrideUrlLoadingAction> Function(
    WebViewController,
    ShouldOverrideUrlLoadingRequest,
  )? shouldOverrideUrlLoading;

  final FutureOr<ReceivedHttpAuthResponse> Function(
    WebViewController,
    HttpAuthChallenge,
  )? onReceivedHttpAuthRequest;

  final List<ContentBlocker>? contentBlockers;

  /// Controls whether WebView debugging is enabled.
  ///
  /// Setting this to true enables [WebView debugging on Android](https://developers.google.com/web/tools/chrome-devtools/remote-debugging/).
  ///
  /// WebView debugging is enabled by default in dev builds on iOS.
  ///
  /// To debug WebViews on iOS:
  /// - Enable developer options (Open Safari, go to Preferences -> Advanced and make sure "Show Develop Menu in Menubar" is on.)
  /// - From the Menu-bar (of Safari) select Develop -> iPhone Simulator -> <your webview page>
  ///
  /// By default `debuggingEnabled` is false.
  final bool debuggingEnabled;

  /// A Boolean value indicating whether horizontal swipe gestures will trigger back-forward list navigations.
  ///
  /// This only works on iOS.
  ///
  /// By default `gestureNavigationEnabled` is false.
  final bool gestureNavigationEnabled;

  final String? userAgent;

  final bool androidUseHybridComposition;

  const WebView({
    Key? key,
    this.initialUrl,
    this.initialFile,
    this.initialHeaders,
    this.initialData,
    this.onWebViewCreated,
    this.onPageStarted,
    this.onPageFinished,
    this.onWebResourceError,
    this.onProgressChanged,
    this.onReceivedHttpAuthRequest,
    this.onJsConfirm,
    this.onJsAlert,
    this.onJsPrompt,
    this.shouldOverrideUrlLoading,
    this.contentBlockers,
    this.androidUseHybridComposition = true,
    this.gestureNavigationEnabled = false,
    this.debuggingEnabled = false,
    this.userAgent,
  });

  @override
  Widget build(BuildContext context) {
    return platform!.build(
      context: context,
      creationParams: CreationParams.from(this),
      viewType: viewType,
      onPlatformViewCreated: _onPlatformViewCreated,
      gestureRecognizers: {},
      useHybridComposition: androidUseHybridComposition,
    );
  }

  void _onPlatformViewCreated(int id) {
    final controller = WebViewController(this, id, () {});
    if (onWebViewCreated == null) {
      return;
    }
    onWebViewCreated!(controller);
  }
}

class CreationParams {
  final WebView widget;

  CreationParams._(this.widget);

  static CreationParams from(WebView widget) {
    return CreationParams._(widget);
  }

  Map<String, dynamic> toMap() {
    return {
      "initialUrl": widget.initialUrl,
      "initialFile": widget.initialFile,
      "initialHeaders": widget.initialHeaders,
      "initialData": widget.initialData?.toMap(),
      "hasShouldOverrideUrlLoading": widget.shouldOverrideUrlLoading != null,
      "contentBlockers":
          (widget.contentBlockers ?? []).map((v) => v.toMap()).toList(),
      "gestureNavigationEnabled": widget.gestureNavigationEnabled,
      "debuggingEnabled": widget.debuggingEnabled,
      "userAgent": widget.userAgent,
    };
  }
}
