import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class WebView extends StatefulWidget {
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
      creationParams: {},
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
