import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:native_webview/native_webview.dart';
import 'package:native_webview_example/integration_test/webview_event.dart';

import '../utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("The URL loaded by initialUrl", () {
    testWebView('initialUrl is about:blank', (tester, context) async {
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

      expect(context.loadingRequestEvents.length, 0);
    });

    testWebView('initialUrl is https://www.google.com/',
        (tester, context) async {
      await tester.pumpFrames(
        WebView(
          initialUrl: 'https://www.google.com/',
          onWebViewCreated: context.onWebViewCreated,
          shouldOverrideUrlLoading: context.shouldOverrideUrlLoading,
          onPageStarted: context.onPageStarted,
          onWebResourceError: context.onWebResourceError,
          onProgressChanged: context.onProgressChanged,
          onPageFinished: context.onPageFinished,
        ),
      );

      expect(
        context.loadingRequestEvents.length,
        Platform.isAndroid
            ? 0
            : anyOf(
                greaterThanOrEqualTo(0),
                greaterThanOrEqualTo(1),
              ),
      );

      expect(context.pageStartedEvents, [
        WebViewEvent.pageStarted(
          "https://www.google.com/",
          "https://www.google.com/",
          false,
          false,
        ),
      ]);
      expect(
        context.pageFinishedEvents,
        anyOf(
          equals([
            WebViewEvent.pageFinished(
              "https://www.google.com/",
              "https://www.google.com/",
              false,
              false,
            ),
          ]),
          equals([
            // PageFinished of www.google.com may come twice on Android.
            WebViewEvent.pageFinished(
              "https://www.google.com/",
              "https://www.google.com/",
              false,
              false,
            ),
            WebViewEvent.pageFinished(
              "https://www.google.com/",
              "https://www.google.com/",
              false,
              false,
            ),
          ]),
        ),
      );
    });

    testWebView('initialUrl is https://google.com (with redirect)',
        (tester, context) async {
      await tester.pumpFrames(
        WebView(
          initialUrl: 'https://google.com/',
          onWebViewCreated: context.onWebViewCreated,
          shouldOverrideUrlLoading: context.shouldOverrideUrlLoading,
          onPageStarted: context.onPageStarted,
          onWebResourceError: context.onWebResourceError,
          onProgressChanged: context.onProgressChanged,
          onPageFinished: context.onPageFinished,
        ),
      );

      expect(context.loadingRequestEvents.map((e) => e.request.url), [
        'https://www.google.com/',
      ]);

      expect(
        context.pageStartedEvents,
        anyOf(
          equals([
            // iOS?
            WebViewEvent.pageStarted(
              "https://google.com/",
              "https://google.com/",
              false,
              false,
            ),
          ]),
          equals([
            // on CI(iOS)
            WebViewEvent.pageStarted(
              "https://google.com/",
              "https://www.google.com/",
              false,
              false,
            ),
          ]),
          equals([
            // Android
            WebViewEvent.pageStarted(
              "https://www.google.com/",
              "https://www.google.com/",
              false,
              false,
            ),
          ]),
        ),
      );

      expect(
        context.pageFinishedEvents,
        anyOf(
          equals([
            WebViewEvent.pageFinished(
              "https://www.google.com/",
              "https://www.google.com/",
              false,
              false,
            ),
          ]),
          equals([
            // PageFinished of www.google.com may come twice on Android.
            WebViewEvent.pageFinished(
              "https://www.google.com/",
              "https://www.google.com/",
              false,
              false,
            ),
            WebViewEvent.pageFinished(
              "https://www.google.com/",
              "https://www.google.com/",
              false,
              false,
            ),
          ]),
          equals([
            // for Android
            WebViewEvent.pageFinished(
              "https://www.google.com/",
              "https://www.google.com/",
              false,
              false,
            ),
            WebViewEvent.pageFinished(
              "https://www.google.com/",
              "https://www.google.com/",
              false,
              false,
            ),
            WebViewEvent.pageFinished(
              "https://www.google.com/",
              "https://www.google.com/",
              false,
              false,
            ),
          ]),
        ),
      );
    });

    testWebView('ShouldOverrideLoadingUrl is not used.',
        (tester, context) async {
      await tester.pumpFrames(
        WebView(
          initialUrl: 'about:blank',
          onWebViewCreated: context.onWebViewCreated,
          // shouldOverrideUrlLoading: context.shouldOverrideUrlLoading,
          onPageStarted: context.onPageStarted,
          onWebResourceError: context.onWebResourceError,
          onProgressChanged: context.onProgressChanged,
          onPageFinished: context.onPageFinished,
        ),
      );

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

      expect(context.loadingRequestEvents.length, 0);
    });
  });

  group("The URL loaded by initialData", () {
    testWebView('baseUrl is null', (tester, context) async {
      await tester.pumpFrames(
        WebView(
          initialData: WebViewData("""
<!doctype html><html lang="en"><head></head><body>native_webview</body></html>
        """),
          onWebViewCreated: context.onWebViewCreated,
          shouldOverrideUrlLoading: context.shouldOverrideUrlLoading,
          onPageStarted: context.onPageStarted,
          onWebResourceError: context.onWebResourceError,
          onProgressChanged: context.onProgressChanged,
          onPageFinished: context.onPageFinished,
        ),
      );

      expect(context.loadingRequestEvents.map((e) => e.request.url), []);

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

    testWebView('baseUrl is https://example.com/', (tester, context) async {
      await tester.pumpFrames(
        WebView(
          initialData: WebViewData(
            """
<!doctype html><html lang="en"><head></head><body>native_webview</body></html>
        """,
            baseUrl: "https://example.com/",
          ),
          onWebViewCreated: context.onWebViewCreated,
          shouldOverrideUrlLoading: context.shouldOverrideUrlLoading,
          onPageStarted: context.onPageStarted,
          onWebResourceError: context.onWebResourceError,
          onProgressChanged: context.onProgressChanged,
          onPageFinished: context.onPageFinished,
        ),
      );

      expect(context.loadingRequestEvents.map((e) => e.request.url), []);

      expect(context.pageStartedEvents, [
        Platform.isAndroid
            ? WebViewEvent.pageStarted(
                "https://example.com/",
                "about:blank",
                false,
                false,
              )
            : WebViewEvent.pageStarted(
                "https://example.com/",
                "https://example.com/",
                false,
                false,
              ),
      ]);
      expect(context.pageFinishedEvents, [
        Platform.isAndroid
            ? WebViewEvent.pageFinished(
                "https://example.com/",
                "about:blank",
                false,
                false,
              )
            : WebViewEvent.pageFinished(
                "https://example.com/",
                "https://example.com/",
                false,
                false,
              ),
      ]);
    });
  });

  testWebView('The URL loaded by initialFile', (tester, context) async {
    await tester.pumpFrames(
      WebView(
        initialFile: "test_assets/initial_file.html",
        onWebViewCreated: context.onWebViewCreated,
        shouldOverrideUrlLoading: context.shouldOverrideUrlLoading,
        onPageStarted: context.onPageStarted,
        onWebResourceError: context.onWebResourceError,
        onProgressChanged: context.onProgressChanged,
        onPageFinished: context.onPageFinished,
      ),
    );

    expect(context.loadingRequestEvents.map((e) => e.request.url), []);

    expect(context.pageStartedEvents.map((e) => e.url), [
      contains("/flutter_assets/test_assets/initial_file.html"),
    ]);

    expect(context.pageFinishedEvents.map((e) => e.url), [
      contains("/flutter_assets/test_assets/initial_file.html"),
    ]);
  });

  testWebView('Load the URL of page not found', (tester, context) async {
    await tester.pumpFrames(
      WebView(
        initialUrl: "https://flutter.dev/404",
        onWebViewCreated: context.onWebViewCreated,
        shouldOverrideUrlLoading: context.shouldOverrideUrlLoading,
        onPageStarted: context.onPageStarted,
        onWebResourceError: context.onWebResourceError,
        onProgressChanged: context.onProgressChanged,
        onPageFinished: context.onPageFinished,
      ),
    );

    expect(context.loadingRequestEvents.map((e) => e.request.url), []);

    expect(context.webResourceErrorEvents, []);

    expect(context.pageStartedEvents, [
      WebViewEvent.pageStarted(
        "https://flutter.dev/404",
        "https://flutter.dev/404",
        false,
        false,
      ),
    ]);
    expect(context.pageFinishedEvents, [
      WebViewEvent.pageFinished(
        "https://flutter.dev/404",
        "https://flutter.dev/404",
        false,
        false,
      ),
    ]);
  });

  testWebView('The URL loaded by loadUrl', (tester, context) async {
    await tester.pumpFrames(
      WebView(
        initialUrl: "about:blank",
        onWebViewCreated: context.onWebViewCreated,
        shouldOverrideUrlLoading: context.shouldOverrideUrlLoading,
        onPageStarted: context.onPageStarted,
        onWebResourceError: context.onWebResourceError,
        onProgressChanged: context.onProgressChanged,
        onPageFinished: context.onPageFinished,
      ),
    );

    final controller = await context.webviewController.future;
    await controller.loadUrl("https://www.google.com/");

    await sleep();

    expect(context.loadingRequestEvents.map((e) => e.request.url), [
      if (Platform.isIOS) "https://www.google.com/",
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
        Platform.isAndroid ? true : false,
        false,
      ),
    ]);
    expect(
      context.pageFinishedEvents,
      anyOf(
        equals([
          WebViewEvent.pageFinished(
            "about:blank",
            "about:blank",
            false,
            false,
          ),
          WebViewEvent.pageFinished(
            "https://www.google.com/",
            "https://www.google.com/",
            true,
            false,
          ),
        ]),
        equals([
          // PageFinished of www.google.com may come twice on Android.
          WebViewEvent.pageFinished(
            "about:blank",
            "about:blank",
            false,
            false,
          ),
          WebViewEvent.pageFinished(
            "https://www.google.com/",
            "https://www.google.com/",
            true,
            false,
          ),
          WebViewEvent.pageFinished(
            "https://www.google.com/",
            "https://www.google.com/",
            true,
            false,
          ),
        ]),
      ),
    );
  });

  testWebView('Loading URLs with loadUrl in succession',
      (tester, context) async {
    await tester.pumpFrames(
      WebView(
        initialUrl: "about:blank",
        onWebViewCreated: context.onWebViewCreated,
        shouldOverrideUrlLoading: context.shouldOverrideUrlLoading,
        onPageStarted: context.onPageStarted,
        onWebResourceError: context.onWebResourceError,
        onProgressChanged: context.onProgressChanged,
        onPageFinished: context.onPageFinished,
      ),
    );

    final controller = await context.webviewController.future;
    await controller.loadUrl("https://www.google.com/");
    await controller.loadUrl("https://www.google.com/");

    await sleep();

    expect(
      context.loadingRequestEvents.length,
      greaterThanOrEqualTo(Platform.isAndroid ? 0 : 1),
    );

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
        Platform.isAndroid ? true : false,
        false,
      ),
    ]);
    expect(
      context.pageFinishedEvents,
      anyOf(
        equals([
          WebViewEvent.pageFinished(
            "about:blank",
            "about:blank",
            false,
            false,
          ),
          WebViewEvent.pageFinished(
            "https://www.google.com/",
            "https://www.google.com/",
            true,
            false,
          ),
        ]),
        equals([
          // PageFinished of www.google.com may come twice on Android.
          WebViewEvent.pageFinished(
            "about:blank",
            "about:blank",
            false,
            false,
          ),
          WebViewEvent.pageFinished(
            "https://www.google.com/",
            "https://www.google.com/",
            true,
            false,
          ),
          WebViewEvent.pageFinished(
            "https://www.google.com/",
            "https://www.google.com/",
            true,
            false,
          ),
        ]),
        equals([
          // PageFinished of www.google.com may come twice on Android.
          WebViewEvent.pageFinished(
            "about:blank",
            "about:blank",
            false,
            false,
          ),
          WebViewEvent.pageFinished(
            "https://www.google.com/",
            "https://www.google.com/",
            false,
            false,
          ),
          WebViewEvent.pageFinished(
            "https://www.google.com/",
            "https://www.google.com/",
            true,
            false,
          ),
          WebViewEvent.pageFinished(
            "https://www.google.com/",
            "https://www.google.com/",
            true,
            false,
          ),
        ]),
      ),
    );
  });

  testWebView('Use location.href to transition', (tester, context) async {
    await tester.pumpFrames(
      WebView(
        initialUrl: "about:blank",
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
        Platform.isAndroid ? true : false,
        false,
      ),
    ]);
    expect(
      context.pageFinishedEvents,
      anyOf(
        equals([
          WebViewEvent.pageFinished(
            "about:blank",
            "about:blank",
            false,
            false,
          ),
          WebViewEvent.pageFinished(
            "https://www.google.com/",
            "https://www.google.com/",
            Platform.isAndroid ? true : false,
            false,
          ),
        ]),
        equals([
          WebViewEvent.pageFinished(
            "about:blank",
            "about:blank",
            false,
            false,
          ),
          WebViewEvent.pageFinished(
            "https://www.google.com/",
            "https://www.google.com/",
            true,
            false,
          ),
          WebViewEvent.pageFinished(
            "https://www.google.com/",
            "https://www.google.com/",
            true,
            false,
          ),
        ]),
      ),
    );
  });

  testWebView('Use window.open()', (tester, context) async {
    await tester.pumpFrames(
      WebView(
        initialUrl: "about:blank",
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
      "window.open('https://www.google.com/', '_blank');",
    );

    await sleep();

    expect(context.loadingRequestEvents.length, greaterThanOrEqualTo(1));

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
        Platform.isAndroid ? true : false,
        false,
      ),
    ]);
    expect(
      context.pageFinishedEvents,
      anyOf(
        equals([
          WebViewEvent.pageFinished(
            "about:blank",
            "about:blank",
            false,
            false,
          ),
          WebViewEvent.pageFinished(
            "https://www.google.com/",
            "https://www.google.com/",
            true,
            false,
          ),
        ]),
        equals([
          WebViewEvent.pageFinished(
            "about:blank",
            "about:blank",
            false,
            false,
          ),
          WebViewEvent.pageFinished(
            "https://www.google.com/",
            "https://www.google.com/",
            true,
            false,
          ),
          WebViewEvent.pageFinished(
            "https://www.google.com/",
            "https://www.google.com/",
            true,
            false,
          ),
        ]),
      ),
    );
  });
}
