import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:native_webview/native_webview.dart';
import 'package:native_webview/platform_interface.dart';

class AndroidWebView extends PlatformWebView {
  @override
  Widget build({
    BuildContext context,
    CreationParams creationParams,
    viewType,
    onPlatformViewCreated,
    Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers,
    bool useHybridComposition = true,
  }) {
    if (useHybridComposition) {
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
            creationParams: creationParams.toMap(),
            creationParamsCodec: const StandardMessageCodec(),
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..addOnPlatformViewCreatedListener(
                (id) => onPlatformViewCreated(id))
            ..create();
        },
      );
    }

    return AndroidView(
      viewType: viewType,
      onPlatformViewCreated: onPlatformViewCreated,
      gestureRecognizers: Set.from([]),
      creationParams: creationParams.toMap(),
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
