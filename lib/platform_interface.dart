import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'native_webview.dart';

abstract class PlatformWebView {
  Widget build({
    required BuildContext context,
    required CreationParams creationParams,
    required String viewType,
    required PlatformViewCreatedCallback onPlatformViewCreated,
    required Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers,
    bool useHybridComposition = true,
  });
}
