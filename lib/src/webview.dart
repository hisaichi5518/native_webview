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
  static const String viewType = "com.hisaichi5518/native_webview";

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
