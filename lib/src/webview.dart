import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:native_webview/src/content_blocker.dart';
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
  }) : assert(data != null &&
            mimeType != null &&
            encoding != null &&
            baseUrl != null &&
            historyUrl != null);

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

///JsConfirmResponseAction class used by [JsConfirmResponse] class.
enum JsConfirmResponseAction {
  ok,
  cancel,
}

///JsConfirmResponse class represents the response used by the [onJsConfirm] event to control a JavaScript confirm dialog.
class JsConfirmResponse {
  ///Message to be displayed in the window.
  final String message;

  ///Title of the confirm button.
  final String okLabel;

  ///Title of the cancel button.
  final String cancelLabel;

  ///Whether the client will handle the confirm dialog.
  final bool handledByClient;

  ///Action used to confirm that the user hit confirm or cancel button.
  final JsConfirmResponseAction action;

  JsConfirmResponse._(
    this.message,
    this.okLabel,
    this.cancelLabel,
    this.handledByClient,
    this.action,
  );

  factory JsConfirmResponse.handled(JsConfirmResponseAction action) {
    return JsConfirmResponse._(null, null, null, true, action);
  }

  factory JsConfirmResponse.confirm(
    String message,
    String okLabel,
    String cancelLabel,
  ) {
    return JsConfirmResponse._(
      message,
      okLabel,
      cancelLabel,
      false,
      null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "okLabel": okLabel,
      "cancelLabel": cancelLabel,
      "handledByClient": handledByClient,
      "action": action?.index,
    };
  }
}

///JsAlertResponse class represents the response used by the [onJsAlert] event to control a JavaScript confirm dialog.
class JsAlertResponse {
  ///Message to be displayed in the window.
  final String message;

  ///Title of the alert button.
  final String okLabel;

  ///Whether the client will handle the alert dialog.
  final bool handledByClient;

  JsAlertResponse._(this.message, this.okLabel, this.handledByClient);

  factory JsAlertResponse.handled() {
    return JsAlertResponse._(null, null, true);
  }

  factory JsAlertResponse.alert(
    String message,
    String okLabel,
  ) {
    return JsAlertResponse._(
      message,
      okLabel,
      false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "okLabel": okLabel,
      "handledByClient": handledByClient,
    };
  }
}

enum JsPromptResponseAction {
  ok,
  cancel,
}

///JsPromptResponse class represents the response used by the [onJsPrompt] event to control a JavaScript prompt dialog.
class JsPromptResponse {
  ///Message to be displayed in the window.
  final String message;

  ///The default value displayed in the prompt dialog.
  final String defaultValue;

  ///Title of the confirm button.
  final String okLabel;

  ///Title of the cancel button.
  final String cancelLabel;

  ///Whether the client will handle the prompt dialog.
  final bool handledByClient;

  ///Action used to confirm that the user hit confirm or cancel button.
  final JsPromptResponseAction action;

  ///Value of the prompt dialog.
  final String value;

  factory JsPromptResponse.handled(
    JsPromptResponseAction action,
    String value,
  ) {
    return JsPromptResponse._(
      null,
      null,
      null,
      null,
      true,
      action,
      value,
    );
  }

  factory JsPromptResponse.prompt(
    String message,
    String defaultValue,
    String okLabel,
    String cancelLabel,
  ) {
    return JsPromptResponse._(
      message,
      defaultValue,
      okLabel,
      cancelLabel,
      false,
      null,
      null,
    );
  }

  JsPromptResponse._(
    this.message,
    this.defaultValue,
    this.okLabel,
    this.cancelLabel,
    this.handledByClient,
    this.action,
    this.value,
  );

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "defaultText": defaultValue,
      "okLabel": okLabel,
      "cancelLabel": cancelLabel,
      "handledByClient": handledByClient,
      "value": value,
      "action": action?.index
    };
  }
}

class ShouldOverrideUrlLoadingRequest {
  final String url;

  final String method;

  final Map<String, String> headers;

  final bool isForMainFrame;

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
      "action": this.index,
    };
  }
}

// Copied from https://github.com/flutter/plugins/blob/a0b692d8e4040ac42c754a75b11e2acb4bc2617f/packages/webview_flutter/lib/platform_interface.dart#L37
/// Possible error type categorizations used by [WebResourceError].
enum WebResourceErrorType {
  /// User authentication failed on server.
  authentication,

  /// Malformed URL.
  badUrl,

  /// Failed to connect to the server.
  connect,

  /// Failed to perform SSL handshake.
  failedSslHandshake,

  /// Generic file error.
  file,

  /// File not found.
  fileNotFound,

  /// Server or proxy hostname lookup failed.
  hostLookup,

  /// Failed to read or write to the server.
  io,

  /// User authentication failed on proxy.
  proxyAuthentication,

  /// Too many redirects.
  redirectLoop,

  /// Connection timed out.
  timeout,

  /// Too many requests during this load.
  tooManyRequests,

  /// Generic error.
  unknown,

  /// Resource load was canceled by Safe Browsing.
  unsafeResource,

  /// Unsupported authentication scheme (not basic or digest).
  unsupportedAuthScheme,

  /// Unsupported URI scheme.
  unsupportedScheme,

  /// The web content process was terminated.
  webContentProcessTerminated,

  /// The web view was invalidated.
  webViewInvalidated,

  /// A JavaScript exception occurred.
  javaScriptExceptionOccurred,

  /// The result of JavaScript execution could not be returned.
  javaScriptResultTypeIsUnsupported,
}

// Copied from https://github.com/flutter/plugins/blob/a0b692d8e4040ac42c754a75b11e2acb4bc2617f/packages/webview_flutter/lib/platform_interface.dart#L100
/// Error returned in `WebView.onWebResourceError` when a web resource loading error has occurred.
class WebResourceError {
  /// Creates a new [WebResourceError]
  ///
  /// A user should not need to instantiate this class, but will receive one in
  /// [WebResourceErrorCallback].
  WebResourceError({
    @required this.errorCode,
    @required this.description,
    this.domain,
    this.errorType,
  })  : assert(errorCode != null),
        assert(description != null);

  /// Raw code of the error from the respective platform.
  ///
  /// On Android, the error code will be a constant from a
  /// [WebViewClient](https://developer.android.com/reference/android/webkit/WebViewClient#summary) and
  /// will have a corresponding [errorType].
  ///
  /// On iOS, the error code will be a constant from `NSError.code` in
  /// Objective-C. See
  /// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ErrorHandlingCocoa/ErrorObjectsDomains/ErrorObjectsDomains.html
  /// for more information on error handling on iOS. Some possible error codes
  /// can be found at https://developer.apple.com/documentation/webkit/wkerrorcode?language=objc.
  final int errorCode;

  /// The domain of where to find the error code.
  ///
  /// This field is only available on iOS and represents a "domain" from where
  /// the [errorCode] is from. This value is taken directly from an `NSError`
  /// in Objective-C. See
  /// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ErrorHandlingCocoa/ErrorObjectsDomains/ErrorObjectsDomains.html
  /// for more information on error handling on iOS.
  final String domain;

  /// Description of the error that can be used to communicate the problem to the user.
  final String description;

  /// The type this error can be categorized as.
  ///
  /// This will never be `null` on Android, but can be `null` on iOS.
  final WebResourceErrorType errorType;
}

class WebView extends StatefulWidget {
  final String initialUrl;
  final String initialFile;
  final Map<String, String> initialHeaders;
  final WebViewData initialData;

  final void Function(WebViewController) onWebViewCreated;
  final void Function(WebViewController, String) onPageStarted;
  final void Function(WebViewController, String) onPageFinished;
  final void Function(WebViewController, int) onProgressChanged;
  final JsConfirmResponse Function(WebViewController, String) onJsConfirm;
  final JsAlertResponse Function(WebViewController, String) onJsAlert;
  final JsPromptResponse Function(WebViewController, String, String) onJsPrompt;
  final Future<ShouldOverrideUrlLoadingAction> Function(
    WebViewController,
    ShouldOverrideUrlLoadingRequest,
  ) shouldOverrideUrlLoading;
  final List<ContentBlocker> contentBlockers;
  final void Function(WebResourceError error) onWebResourceError;

  /// A Boolean value indicating whether horizontal swipe gestures will trigger back-forward list navigations.
  ///
  /// This only works on iOS.
  ///
  /// By default `gestureNavigationEnabled` is false.
  final bool gestureNavigationEnabled;

  ///On Android, if you use multiple WebViews, the WebView may turn black the page is loaded.
  ///If you specify androidBackgroundColor, it won't happen.
  final Color androidBackgroundColor;

  const WebView({
    Key key,
    this.initialUrl,
    this.initialFile,
    this.initialHeaders,
    this.initialData,
    this.onWebViewCreated,
    this.onPageStarted,
    this.onPageFinished,
    this.onWebResourceError,
    this.onProgressChanged,
    this.onJsConfirm,
    this.onJsAlert,
    this.onJsPrompt,
    this.shouldOverrideUrlLoading,
    this.contentBlockers,
    this.androidBackgroundColor = Colors.white,
    this.gestureNavigationEnabled = false,
  });

  @override
  State<StatefulWidget> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  static const String viewType = "com.hisaichi5518/native_webview";

  var isFirstLoading = true;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return UiKitView(
        viewType: viewType,
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: Set.from([]),
        creationParams: _CreationParams.from(widget).toMap(),
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (Platform.isAndroid) {
      return Stack(
        children: <Widget>[
          AndroidView(
            viewType: viewType,
            onPlatformViewCreated: _onPlatformViewCreated,
            gestureRecognizers: Set.from([]),
            creationParams: _CreationParams.from(widget).toMap(),
            creationParamsCodec: const StandardMessageCodec(),
          ),
          if (isFirstLoading)
            Container(
              color: this.widget.androidBackgroundColor,
            )
        ],
      );
    }
    throw UnsupportedError("${Platform.operatingSystem} is not supported.");
  }

  void _onPlatformViewCreated(int id) {
    final controller = WebViewController(widget, id, () {
      // https://github.com/hisaichi5518/native_webview/issues/22
      if (!isFirstLoading) {
        return;
      }
      setState(() {
        isFirstLoading = false;
      });
    });
    if (widget.onWebViewCreated == null) {
      return;
    }
    widget.onWebViewCreated(controller);
  }
}

class _CreationParams {
  final WebView widget;

  _CreationParams._(this.widget);

  static _CreationParams from(WebView widget) {
    return _CreationParams._(widget);
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
      "gestureNavigationEnabled": widget.gestureNavigationEnabled ?? false
    };
  }
}
