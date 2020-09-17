import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:native_webview/src/content_blocker.dart';
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

class HttpAuthChallenge {
  final String host;
  final String realm;

  HttpAuthChallenge({this.host, this.realm});
}

enum ReceivedHttpAuthResponseAction {
  useCredential,
  cancel,
}

class ReceivedHttpAuthResponse {
  final ReceivedHttpAuthResponseAction action;
  final String username;
  final String password;

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
      "action": action?.index ?? ReceivedHttpAuthResponseAction.cancel.index,
      "username": username,
      "password": password,
    };
  }
}

class WebView extends StatefulWidget {
  final String initialUrl;
  final String initialFile;
  final Map<String, String> initialHeaders;
  final WebViewData initialData;

  final void Function(WebViewController) onWebViewCreated;
  final void Function(WebViewController, String) onPageStarted;
  final void Function(WebViewController, String) onPageFinished;
  final void Function(WebResourceError error) onWebResourceError;
  final void Function(WebViewController, int) onProgressChanged;

  final JsConfirmCallback onJsConfirm;
  final JsAlertCallback onJsAlert;
  final JsPromptCallback onJsPrompt;

  final Future<ShouldOverrideUrlLoadingAction> Function(
    WebViewController,
    ShouldOverrideUrlLoadingRequest,
  ) shouldOverrideUrlLoading;

  final Future<ReceivedHttpAuthResponse> Function(
    WebViewController,
    HttpAuthChallenge,
  ) onReceivedHttpAuthRequest;

  final List<ContentBlocker> contentBlockers;

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

  ///On Android, if you use multiple WebViews, the WebView may turn black the page is loaded.
  ///If you specify androidBackgroundColor, it won't happen.
  final Color androidBackgroundColor;

  final String userAgent;

  final bool androidUseHybridComposition;

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
    this.onReceivedHttpAuthRequest,
    this.onJsConfirm,
    this.onJsAlert,
    this.onJsPrompt,
    this.shouldOverrideUrlLoading,
    this.contentBlockers,
    this.androidBackgroundColor = Colors.white,
    this.androidUseHybridComposition = true,
    this.gestureNavigationEnabled = false,
    this.debuggingEnabled = false,
    this.userAgent,
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
          _buildAndroidView(),
          if (isFirstLoading)
            Container(
              color: this.widget.androidBackgroundColor,
            )
        ],
      );
    }
    throw UnsupportedError("${Platform.operatingSystem} is not supported.");
  }

  Widget _buildAndroidView() {
    if (widget.androidUseHybridComposition) {
      return PlatformViewLink(
        viewType: viewType,
        surfaceFactory: (
          BuildContext context,
          PlatformViewController controller,
        ) {
          return AndroidViewSurface(
            controller: controller,
            gestureRecognizers: Set.from([]),
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (PlatformViewCreationParams params) {
          return PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: viewType,
            layoutDirection: TextDirection.rtl,
            creationParams: _CreationParams.from(widget).toMap(),
            creationParamsCodec: const StandardMessageCodec(),
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..addOnPlatformViewCreatedListener(
                (id) => _onPlatformViewCreated(id))
            ..create();
        },
      );
    }

    return AndroidView(
      viewType: viewType,
      onPlatformViewCreated: _onPlatformViewCreated,
      gestureRecognizers: Set.from([]),
      creationParams: _CreationParams.from(widget).toMap(),
      creationParamsCodec: const StandardMessageCodec(),
    );
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
      "gestureNavigationEnabled": widget.gestureNavigationEnabled ?? false,
      "debuggingEnabled": widget.debuggingEnabled ?? false,
      "userAgent": widget.userAgent,
    };
  }
}
