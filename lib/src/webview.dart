import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:native_webview/src/webview_controller.dart';

class WebView extends StatefulWidget {
  final String initialUrl;
  final void Function(WebViewController) onWebViewCreated;
  final void Function(WebViewController, String) onPageStarted;
  final void Function(WebViewController, String) onPageFinished;
  final void Function(WebViewController, int) onProgressChanged;

  const WebView({
    Key key,
    this.initialUrl,
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
    };
  }
}
