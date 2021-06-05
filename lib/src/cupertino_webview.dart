import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:native_webview/native_webview.dart';
import 'package:native_webview/platform_interface.dart';

class CupertinoWebView extends PlatformWebView {
  @override
  Widget build({
    BuildContext? context,
    required CreationParams creationParams,
    required String viewType,
    required onPlatformViewCreated,
    Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
    bool useHybridComposition = true,
  }) {
    return UiKitView(
      viewType: viewType,
      onPlatformViewCreated: onPlatformViewCreated,
      gestureRecognizers: {},
      creationParams: creationParams.toMap(),
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
