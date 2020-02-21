import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class WebView extends StatefulWidget {
  final String initialUrl;

  const WebView({
    Key key,
    this.initialUrl,
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
        print(id);
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
