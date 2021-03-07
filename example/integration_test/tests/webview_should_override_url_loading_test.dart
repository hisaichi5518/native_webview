import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:native_webview/native_webview.dart';
import 'package:native_webview_example/integration_test/webview_event.dart';

import '../utils.dart';

void main() {
  if (!Platform.isIOS) {
    return;
  }

  testWebView('Return allow', (tester, context) async {
    // Which: at location [1] is
    // _$PageFinishedEvent:<WebViewEvent.pageFinished(url:
    // https://www.google.com/, currentUrl: https://www.google.com/,
    // canGoBack: false, canGoForward: false)>
    // _$PageFinishedEvent:<WebViewEvent.pageFinished(url:
    // https://www.google.com/, currentUrl: https://www.google.com/,
    // canGoBack: true, canGoForward: false)>

    await tester.pumpFrames(
      WebView(
        initialUrl: 'about:blank',
        onWebViewCreated: context.onWebViewCreated,
        shouldOverrideUrlLoading: context.shouldOverrideUrlLoading,
        onPageStarted: context.onPageStarted,
        onWebResourceError: context.onWebResourceError,
        onProgressChanged: context.onProgressChanged,
        onPageFinished: context.onPageFinished,
      ),
    );

    final controller = await context.webviewController.future;
    await controller.evaluateJavascript(
      "location.href = 'https://www.google.com/'",
    );

    await sleep();

    expect(context.loadingRequestEvents.map((e) => e.request.url), [
      "https://www.google.com/",
    ]);

    expect(context.webResourceErrorEvents.length, 0);

    expect(context.pageStartedEvents, [
      WebViewEvent.pageStarted(
        "about:blank",
        "about:blank",
        false,
        false,
      ),
      WebViewEvent.pageStarted(
        "https://www.google.com/",
        "https://www.google.com/",
        false,
        false,
      ),
    ]);
    expect(context.pageFinishedEvents, [
      WebViewEvent.pageFinished(
        "about:blank",
        "about:blank",
        false,
        false,
      ),
      WebViewEvent.pageFinished(
        "https://www.google.com/",
        "https://www.google.com/",
        false, // false!
        false,
      ),
    ]);
  });

  testWebView('Return cancel', (tester, context) async {
    await tester.pumpFrames(
      WebView(
        initialUrl: 'about:blank',
        onWebViewCreated: context.onWebViewCreated,
        onWebResourceError: context.onWebResourceError,
        onProgressChanged: context.onProgressChanged,
        onPageStarted: context.onPageStarted,
        onPageFinished: context.onPageFinished,
        shouldOverrideUrlLoading: (controller, request) async {
          await context.shouldOverrideUrlLoading(controller, request);
          return ShouldOverrideUrlLoadingAction.cancel;
        },
      ),
    );

    final controller = await context.webviewController.future;
    await controller.evaluateJavascript(
      "location.href = 'https://www.google.com/'",
    );

    await sleep();

    expect(context.loadingRequestEvents.map((e) => e.request.url), [
      "https://www.google.com/",
    ]);

    expect(context.webResourceErrorEvents.length, 0);

    expect(context.pageStartedEvents, [
      WebViewEvent.pageStarted(
        "about:blank",
        "about:blank",
        false,
        false,
      ),
    ]);
    expect(context.pageFinishedEvents, [
      WebViewEvent.pageFinished(
        "about:blank",
        "about:blank",
        false,
        false,
      ),
    ]);
  });

  testWebView('loadUrl execute shouldOverrideUrlLoading',
      (tester, context) async {
    await tester.pumpFrames(
      WebView(
        initialUrl: 'about:blank',
        onWebViewCreated: context.onWebViewCreated,
        onWebResourceError: context.onWebResourceError,
        onProgressChanged: context.onProgressChanged,
        onPageStarted: context.onPageStarted,
        onPageFinished: context.onPageFinished,
        shouldOverrideUrlLoading: (controller, request) async {
          await context.shouldOverrideUrlLoading(controller, request);
          return ShouldOverrideUrlLoadingAction.cancel;
        },
      ),
    );

    final controller = await context.webviewController.future;
    await controller.loadUrl("https://www.google.com/");

    await sleep();

    expect(context.loadingRequestEvents.map((e) => e.request.url), [
      "https://www.google.com/",
    ]);

    expect(context.webResourceErrorEvents.length, 0);
  });
}
