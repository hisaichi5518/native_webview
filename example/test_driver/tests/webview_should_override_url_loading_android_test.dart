import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:native_webview/native_webview.dart';

import '../utils.dart';

void main() {
  if (!Platform.isAndroid) {
    return;
  }

  testWebView('Return allow', (tester, context) async {
    await tester.pumpWidget(
      WebView(
        initialUrl: 'about:blank',
        onWebViewCreated: context.onWebViewCreated,
        onPageStarted: context.onPageStarted,
        onPageFinished: context.onPageFinished,
        shouldOverrideUrlLoading: (controller, request) async {
          context.shouldOverrideUrlLoading(request);
          return ShouldOverrideUrlLoadingAction.allow;
        },
      ),
    );

    final controller = await context.webviewController.future;

    context.loadingRequests.stream.listen(onData([
      (event) {
        expect(event.url, "https://www.google.com/");
        expect(event.method, "GET");
        expect(event.isForMainFrame, true);
        expect(event.headers, null);
      },
    ]));
    context.pageStarted.stream.listen(onData([
      (event) {
        expect(event, "about:blank");
      },
      (event) {
        expect(event, "https://www.google.com/");
      },
    ]));
    context.pageFinished.stream.listen(onData([
      (event) {
        expect(event, "about:blank");
        controller.evaluateJavascript(
          "location.href = 'https://www.google.com/'",
        );
      },
      (event) {
        expect(event, "https://www.google.com/");
        expect(context.loadingRequestEvents.length, 1);
        expect(context.pageStartedEvents.length, 2);
        context.complete();
      },
    ]));
  });

  testWebView('Return cancel', (tester, context) async {
    var count = 0;
    await tester.pumpWidget(
      WebView(
        initialUrl: 'about:blank',
        onWebViewCreated: context.onWebViewCreated,
        onPageStarted: (controller, url) {
          count++;
          context.onPageStarted(controller, url);
        },
        onPageFinished: (controller, url) {
          count++;
          context.onPageFinished(controller, url);
        },
        shouldOverrideUrlLoading: (controller, request) async {
          count++;
          context.shouldOverrideUrlLoading(request);
          return ShouldOverrideUrlLoadingAction.cancel;
        },
      ),
    );

    final controller = await context.webviewController.future;

    context.pageFinished.stream.listen(onData([
      (event) {
        expect(event, "about:blank");
        controller.evaluateJavascript(
          "location.href = 'https://www.google.com/'",
        );

        Future.delayed(Duration(seconds: 5), () {
          expect(count, 3);
          context.complete();
        });
      },
    ]));
  });

  testWebView('loadUrl does not execute shouldOverrideUrlLoading',
      (tester, context) async {
    await tester.pumpWidget(
      WebView(
        initialUrl: 'about:blank',
        onWebViewCreated: context.onWebViewCreated,
        onPageStarted: context.onPageStarted,
        onPageFinished: context.onPageFinished,
        shouldOverrideUrlLoading: (controller, request) async {
          context.shouldOverrideUrlLoading(request);
          return ShouldOverrideUrlLoadingAction.allow;
        },
      ),
    );

    final controller = await context.webviewController.future;

    context.pageStarted.stream.listen(onData([
      (event) {
        expect(event, "about:blank");
      },
      (event) {
        expect(event, "https://www.google.com/");
      },
    ]));
    context.pageFinished.stream.listen(onData([
      (event) {
        expect(event, "about:blank");
        controller.loadUrl("https://www.google.com/");
      },
      (event) {
        expect(event, "https://www.google.com/");
        expect(context.loadingRequestEvents.length, 0);
        expect(context.pageStartedEvents.length, 2);
        context.complete();
      },
    ]));
  });
}
