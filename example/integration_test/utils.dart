import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart' as test;
import 'package:native_webview/native_webview.dart';
import 'package:native_webview_example/integration_test/webview_event.dart';

T Function(A) onData<T, A>(List<T Function(A)> events) {
  var index = 0;
  return test.expectAsync1<T, A>((event) {
    return events[index++](event);
  }, count: events.length, max: events.length);
}

class WebViewTestContext {
  final List<ShouldOverrideUrlLoadingEvent> loadingRequestEvents = [];
  final List<ProgressChangedEvent> progressChangedEvents = [];
  final List<PageStartedEvent> pageStartedEvents = [];
  final List<PageFinishedEvent> pageFinishedEvents = [];
  final List<WebResourceErrorEvent> webResourceErrorEvents = [];

  final webviewController = Completer<WebViewController>();

  void onWebViewCreated(WebViewController controller) {
    webviewController.complete(controller);
  }

  Future<ShouldOverrideUrlLoadingAction> shouldOverrideUrlLoading(
    WebViewController controller,
    ShouldOverrideUrlLoadingRequest request,
  ) async {
    final event = WebViewEvent.shouldOverrideUrlLoading(request);
    print(event);
    loadingRequestEvents.add(event);

    return ShouldOverrideUrlLoadingAction.allow;
  }

  void onPageStarted(WebViewController controller, String url) async {
    final event = WebViewEvent.pageStarted(
      url,
      await controller.currentUrl(),
      await controller.canGoBack(),
      await controller.canGoForward(),
    );
    print(event);
    pageStartedEvents.add(event);
  }

  void onPageFinished(WebViewController controller, String url) async {
    final event = WebViewEvent.pageFinished(
      url,
      await controller.currentUrl(),
      await controller.canGoBack(),
      await controller.canGoForward(),
    );
    print(event);
    pageFinishedEvents.add(event);
  }

  void onWebResourceError(WebResourceError error) {
    final event = WebViewEvent.webResourceError(error);
    print(event);
    webResourceErrorEvents.add(event);
  }

  void onProgressChanged(WebViewController controller, int progress) {
    final event = WebViewEvent.progressChanged(progress);
    print(event);
    progressChangedEvents.add(event);
  }

  void dispose() {
    loadingRequestEvents.clear();
    pageStartedEvents.clear();
    pageFinishedEvents.clear();
    progressChangedEvents.clear();
    webResourceErrorEvents.clear();
  }

  @override
  String toString() {
    return """
loadingRequestEvents: $loadingRequestEvents,
pageStartedEvents: $pageStartedEvents,
pageFinishedEvents: $pageFinishedEvents,
progressChangedEvents: $progressChangedEvents,
webResourceErrorEvents: $webResourceErrorEvents,
""";
  }
}

class WebViewTester {
  test.WidgetTester tester;
  WebViewTester(this.tester);

  Future<void> pumpFrames(
    Widget widget, [
    Duration duration,
  ]) async {
    final isCI = String.fromEnvironment("CI") == "true";
    duration ?? (isCI ? Duration(seconds: 15) : Duration(seconds: 3));

    return tester.pumpFrames(
      Directionality(
        textDirection: TextDirection.ltr,
        child: widget,
      ),
      duration,
    );
  }
}

test.Future<void> sleep([
  Duration duration,
]) async {
  final isCI = String.fromEnvironment("CI") == "true";
  duration ?? (isCI ? Duration(seconds: 15) : Duration(seconds: 3));
  await test.Future.delayed(duration);
}

typedef WidgetTesterCallback = Future<void> Function(
  WebViewTester tester,
  WebViewTestContext context,
);

void testWebView(
  String description,
  WidgetTesterCallback callback, {
  bool skip = false,
  Duration timeout = const Duration(seconds: 120),
}) async {
  test.testWidgets(
    description,
    (tester) async {
      final context = WebViewTestContext();
      await callback(WebViewTester(tester), context);
    },
    skip: skip,
    timeout: test.Timeout(timeout),
  );
}

void unawaited(Future close) {}
