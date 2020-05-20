import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart' as test;
import 'package:native_webview/native_webview.dart';

T Function(A) onData<T, A>(List<T Function(A)> events) {
  var index = 0;
  return test.expectAsync1<T, A>((event) {
    return events[index++](event);
  }, count: events.length, max: events.length);
}

class WebViewTestContext {
  final List<ShouldOverrideUrlLoadingRequest> loadingRequestEvents = [];
  final List<String> pageStartedEvents = [];
  final List<String> pageFinishedEvents = [];
  final List<WebResourceError> webResourceErrorEvents = [];

  final loadingRequests = StreamController<ShouldOverrideUrlLoadingRequest>();
  final pageStarted = StreamController<String>();
  final webResourceError = StreamController<WebResourceError>();
  final pageFinished = StreamController<String>();

  final webviewController = Completer<WebViewController>();
  final completed = Completer<void>();

  void onWebViewCreated(WebViewController controller) {
    webviewController.complete(controller);
  }

  void shouldOverrideUrlLoading(ShouldOverrideUrlLoadingRequest request) {
    loadingRequestEvents.add(request);
    loadingRequests.add(request);
  }

  void onPageStarted(WebViewController controller, String url) {
    pageStartedEvents.add(url);
    pageStarted.add(url);
  }

  void onPageFinished(WebViewController controller, String url) {
    pageFinishedEvents.add(url);
    pageFinished.add(url);
  }

  void onWebResourceError(WebResourceError error) {
    webResourceErrorEvents.add(error);
    webResourceError.add(error);
  }

  void complete() {
    completed.complete();
  }

  void dispose() {
    loadingRequestEvents.clear();
    pageStartedEvents.clear();
    pageFinishedEvents.clear();

    loadingRequests.close();
    pageStarted.close();
    pageFinished.close();
  }
}

class WebViewTester {
  test.WidgetTester tester;
  WebViewTester(this.tester);

  Future<void> pumpWidget(
    Widget widget, [
    Duration duration,
    test.EnginePhase phase = test.EnginePhase.sendSemanticsUpdate,
  ]) async {
    return tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: widget,
      ),
      duration,
      phase,
    );
  }
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
}) {
  test.testWidgets(
    description,
    (tester) async {
      final context = WebViewTestContext();
      await callback(WebViewTester(tester), context);

      await context.completed.future;
      context.dispose();
    },
    skip: skip,
    timeout: test.Timeout(timeout),
  );
}

void unawaited(Future close) {}
