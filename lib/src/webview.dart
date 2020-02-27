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

class WebView extends StatefulWidget {
  final String initialUrl;
  final WebViewData initialData;
  final void Function(WebViewController) onWebViewCreated;
  final void Function(WebViewController, String) onPageStarted;
  final void Function(WebViewController, String) onPageFinished;
  final void Function(WebViewController, int) onProgressChanged;

  const WebView({
    Key key,
    this.initialUrl,
    this.initialData,
    this.onWebViewCreated,
    this.onPageStarted,
    this.onPageFinished,
    this.onProgressChanged,
  });

  @override
  State<StatefulWidget> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  @override
  Widget build(BuildContext context) {
    return UiKitView(
      viewType: "packages.jp/native_webview",
      onPlatformViewCreated: (int id) {
        if (widget.onWebViewCreated == null) {
          return;
        }
        widget.onWebViewCreated(
          WebViewController(widget, id),
        );
      },
      gestureRecognizers: Set.from([]),
      creationParams: _CreationParams.from(widget).toMap(),
      creationParamsCodec: const StandardMessageCodec(),
    );
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
      "initialData": widget.initialData?.toMap(),
    };
  }
}
