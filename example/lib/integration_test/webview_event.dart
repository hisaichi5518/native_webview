import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:native_webview/native_webview.dart';

part 'webview_event.freezed.dart';

/// for integration tests
@freezed
abstract class WebViewEvent with _$WebViewEvent {
  const factory WebViewEvent.shouldOverrideUrlLoading(
    ShouldOverrideUrlLoadingRequest request,
  ) = ShouldOverrideUrlLoadingEvent;

  const factory WebViewEvent.progressChanged(
    int progress,
  ) = ProgressChangedEvent;

  const factory WebViewEvent.pageStarted(
    String url,
    String currentUrl,
    bool canGoBack,
    bool canGoForward,
  ) = PageStartedEvent;

  const factory WebViewEvent.pageFinished(
    String url,
    String currentUrl,
    bool canGoBack,
    bool canGoForward,
  ) = PageFinishedEvent;

  const factory WebViewEvent.webResourceError(
    WebResourceError error,
  ) = WebResourceErrorEvent;
}
