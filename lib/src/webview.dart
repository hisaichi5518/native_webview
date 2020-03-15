import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
  String message;

  ///Title of the confirm button.
  String okLabel;

  ///Title of the cancel button.
  String cancelLabel;

  ///Whether the client will handle the confirm dialog.
  bool handledByClient;

  ///Action used to confirm that the user hit confirm or cancel button.
  JsConfirmResponseAction action;

  JsConfirmResponse._();

  JsConfirmResponse.handled(this.action) {
    handledByClient = true;
  }

  JsConfirmResponse.confirm(
    this.message,
    this.okLabel,
    this.cancelLabel,
  );

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
  String message;

  ///Title of the alert button.
  String okLabel;

  ///Whether the client will handle the alert dialog.
  bool handledByClient;

  JsAlertResponse._();

  JsAlertResponse.handled() {
    handledByClient = true;
  }

  JsAlertResponse.alert(
    this.message,
    this.okLabel,
  );

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
  String message;

  ///The default value displayed in the prompt dialog.
  String defaultValue;

  ///Title of the confirm button.
  String okLabel;

  ///Title of the cancel button.
  String cancelLabel;

  ///Whether the client will handle the prompt dialog.
  bool handledByClient;

  ///Value of the prompt dialog.
  String value;

  ///Action used to confirm that the user hit confirm or cancel button.
  JsPromptResponseAction action;

  JsPromptResponse.handled(this.action, this.value) {
    handledByClient = true;
  }

  JsPromptResponse.prompt(
    this.message,
    this.defaultValue,
    this.okLabel,
    this.cancelLabel,
  );

  JsPromptResponse._();

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

  const WebView({
    Key key,
    this.initialUrl,
    this.initialFile,
    this.initialHeaders,
    this.initialData,
    this.onWebViewCreated,
    this.onPageStarted,
    this.onPageFinished,
    this.onProgressChanged,
    this.onJsConfirm,
    this.onJsAlert,
    this.onJsPrompt,
  });

  @override
  State<StatefulWidget> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  static const String viewType = "packages.jp/native_webview";

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
      return AndroidView(
        viewType: viewType,
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: Set.from([]),
        creationParams: _CreationParams.from(widget).toMap(),
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    throw UnsupportedError("${Platform.operatingSystem} is not supported.");
  }

  void _onPlatformViewCreated(int id) {
    final controller = WebViewController(widget, id);
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
    };
  }
}
