import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:native_webview/native_webview.dart';

import '../utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("initalUrl", () {
    testWebView('https://flutter.dev/', (tester, context) async {
      await tester.pumpFrames(
        WebView(
          initialUrl: 'https://flutter.dev/',
          onWebViewCreated: context.onWebViewCreated,
        ),
        const Duration(seconds: 1),
      );
      final controller = await context.webviewController.future;
      final currentUrl = await controller.currentUrl();
      expect(currentUrl, 'https://flutter.dev/');
    });

    testWebView('about:blank', (tester, context) async {
      await tester.pumpFrames(
        WebView(
          initialUrl: 'about:blank',
          onWebViewCreated: context.onWebViewCreated,
        ),
        const Duration(seconds: 1),
      );
      final controller = await context.webviewController.future;
      final currentUrl = await controller.currentUrl();
      expect(currentUrl, 'about:blank');
    });

    testWebView('with initialHeaders', (tester, context) async {
      final headers = <String, String>{'test_header': 'flutter_test_header'};

      await tester.pumpFrames(
        WebView(
          initialUrl: 'https://flutter-header-echo.herokuapp.com/',
          initialHeaders: headers,
          onWebViewCreated: context.onWebViewCreated,
          onPageFinished: context.onPageFinished,
        ),
      );
      final controller = await context.webviewController.future;
      final content = await controller.evaluateJavascript(
        '(() => document.documentElement.innerText)()',
      );
      expect(content.contains('flutter_test_header'), isTrue);
    });
  });

  group("initalData", () {
    testWebView('with baseUrl', (tester, context) async {
      final baseUrl = "https://flutter.dev/";
      await tester.pumpFrames(
        WebView(
          initialData: WebViewData(
            '<html><body>yoshitaka-yuriko</body></html>',
            baseUrl: baseUrl,
          ),
          onWebViewCreated: context.onWebViewCreated,
          shouldOverrideUrlLoading: context.shouldOverrideUrlLoading,
          onPageStarted: context.onPageStarted,
          onWebResourceError: context.onWebResourceError,
          onProgressChanged: context.onProgressChanged,
          onPageFinished: context.onPageFinished,
        ),
      );

      final controller = await context.webviewController.future;
      final content = await controller.evaluateJavascript(
        '(() => document.documentElement.innerText)()',
      );
      expect(content, "yoshitaka-yuriko");
    });

    testWebView('without baseUrl', (tester, context) async {
      await tester.pumpFrames(
        WebView(
          initialData: WebViewData(
            '<html><body>yoshitaka-yuriko</body></html>',
          ),
          onWebViewCreated: context.onWebViewCreated,
          shouldOverrideUrlLoading: context.shouldOverrideUrlLoading,
          onPageStarted: context.onPageStarted,
          onWebResourceError: context.onWebResourceError,
          onProgressChanged: context.onProgressChanged,
          onPageFinished: context.onPageFinished,
        ),
      );

      final controller = await context.webviewController.future;
      final content = await controller.evaluateJavascript(
        '(() => document.documentElement.innerText)()',
      );
      expect(content, "yoshitaka-yuriko");
    });
  });

  group("initalFile", () {
    testWebView('from assets', (tester, context) async {
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
      final controller = await context.webviewController.future;
      final content = await controller.evaluateJavascript(
        '(() => document.documentElement.innerText)()',
      );
      expect(content, "yoshitaka-yuriko");
    });
  });

  testWebView('onWebResourceError', (tester, context) async {
    await tester.pumpFrames(
      WebView(
        initialUrl: 'https://www.notawebsite..com',
        onWebViewCreated: context.onWebViewCreated,
        shouldOverrideUrlLoading: context.shouldOverrideUrlLoading,
        onPageStarted: context.onPageStarted,
        onWebResourceError: context.onWebResourceError,
        onProgressChanged: context.onProgressChanged,
        onPageFinished: context.onPageFinished,
      ),
    );

    expect(context.webResourceErrorEvents.map((e) => e.error.errorCode), [
      isNotNull,
    ]);
    expect(context.webResourceErrorEvents.map((e) => e.error.description), [
      isNotNull,
    ]);

    if (Platform.isAndroid) {
      expect(context.webResourceErrorEvents.map((e) => e.error.errorType), [
        WebResourceErrorType.hostLookup,
      ]);
      expect(context.webResourceErrorEvents.map((e) => e.error.domain), [
        isNull,
      ]);
    } else {
      expect(context.webResourceErrorEvents.map((e) => e.error.errorType), [
        isNull,
      ]);
      expect(context.webResourceErrorEvents.map((e) => e.error.domain), [
        "NSURLErrorDomain",
      ]);
    }
  });

  group("onJsConfirm", () {
    testWebView("handled", (tester, context) async {
      var count = 0;

      await tester.pumpFrames(
        WebView(
          initialData: WebViewData(
            '<html><body><script>window.confirm("confirm")</script></body></html>',
          ),
          onWebViewCreated: context.onWebViewCreated,
          shouldOverrideUrlLoading: context.shouldOverrideUrlLoading,
          onPageStarted: context.onPageStarted,
          onWebResourceError: context.onWebResourceError,
          onProgressChanged: context.onProgressChanged,
          onPageFinished: context.onPageFinished,
          onJsConfirm: (controller, message) {
            count++;
            return JsConfirmResponse.handled(JsConfirmResponseAction.cancel);
          },
        ),
      );

      expect(count, 1);
    });
  });

  group("onJsAlert", () {
    testWebView("handled", (tester, context) async {
      var count = 0;
      await tester.pumpFrames(
        WebView(
          initialData: WebViewData(
            '<html><body><script>window.alert("alert")</script></body></html>',
          ),
          onWebViewCreated: context.onWebViewCreated,
          shouldOverrideUrlLoading: context.shouldOverrideUrlLoading,
          onPageStarted: context.onPageStarted,
          onWebResourceError: context.onWebResourceError,
          onProgressChanged: context.onProgressChanged,
          onPageFinished: context.onPageFinished,
          onJsAlert: (controller, message) {
            count++;
            return JsAlertResponse.handled();
          },
        ),
      );
      expect(count, 1);
    });
  });

  group("onJsPrompt", () {
    testWebView("handled", (tester, context) async {
      var count = 0;
      await tester.pumpFrames(
        WebView(
          initialData: WebViewData(
            '<html><body><script>window.prompt("prompt", "text")</script></body></html>',
          ),
          onJsPrompt: (controller, message, defaultText) {
            count++;
            return JsPromptResponse.handled(
              JsPromptResponseAction.ok,
              "value",
            );
          },
          onWebViewCreated: context.onWebViewCreated,
          shouldOverrideUrlLoading: context.shouldOverrideUrlLoading,
          onPageStarted: context.onPageStarted,
          onWebResourceError: context.onWebResourceError,
          onProgressChanged: context.onProgressChanged,
          onPageFinished: context.onPageFinished,
        ),
      );
      expect(count, 1);
    });
  });

  group("onProgressChanged", () {
    testWebView('wait for page finished', (tester, context) async {
      var progressValues = <int>[];
      await tester.pumpFrames(
        WebView(
          initialUrl: 'about:blank',
          onWebViewCreated: context.onWebViewCreated,
          shouldOverrideUrlLoading: context.shouldOverrideUrlLoading,
          onPageStarted: context.onPageStarted,
          onWebResourceError: context.onWebResourceError,
          onProgressChanged: (controller, progress) {
            context.onProgressChanged(controller, progress);
            progressValues.add(progress);
          },
          onPageFinished: context.onPageFinished,
        ),
      );

      expect(progressValues.last, 100);
      expect(
        progressValues.length,
        greaterThanOrEqualTo(1),
      );
    });
  });

  group("onReceivedHttpAuthRequest", () {
    testWebView('wait for page finished', (tester, context) async {
      var challengeValues = <HttpAuthChallenge>[];

      await tester.pumpFrames(
        WebView(
          initialUrl: 'https://native-webview-basic-auth.herokuapp.com/',
          onReceivedHttpAuthRequest: (controller, challenge) async {
            challengeValues.add(challenge);

            return ReceivedHttpAuthResponse.useCredential(
              "username",
              "password",
            );
          },
          onWebViewCreated: context.onWebViewCreated,
          shouldOverrideUrlLoading: context.shouldOverrideUrlLoading,
          onPageStarted: context.onPageStarted,
          onWebResourceError: context.onWebResourceError,
          onProgressChanged: context.onProgressChanged,
          onPageFinished: context.onPageFinished,
        ),
        const Duration(seconds: 15),
      );

      final controller = await context.webviewController.future;
      final text = await controller.evaluateJavascript(
        "document.body.textContent",
      );
      expect(challengeValues.length, greaterThanOrEqualTo(1));

      expect(
          challengeValues
              .where((element) =>
                  element.realm?.contains("Authorization Required") ?? false)
              .length,
          greaterThanOrEqualTo(1));

      expect(
          challengeValues
              .where((element) =>
                  element.host == "native-webview-basic-auth.herokuapp.com")
              .length,
          greaterThanOrEqualTo(1));

      expect(text.toString().contains("Hello world"), true);
    });
  });

  group("gestureNavigationEnabled", () {
    testWebView('is true', (tester, context) async {
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
          gestureNavigationEnabled: true,
        ),
      );

      expect(context.pageFinishedEvents.length, 1);
    });
  });

  group("debuggingEnabled", () {
    testWebView('is true', (tester, context) async {
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
          debuggingEnabled: true,
        ),
      );

      expect(context.pageFinishedEvents.length, 1);
    });
  });

  group("userAgent", () {
    testWebView('is null', (tester, context) async {
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
          debuggingEnabled: true,
        ),
      );
      final controller = await context.webviewController.future;

      final userAgent = await controller.evaluateJavascript(
        "navigator.userAgent",
      );
      expect(userAgent, isNotNull);
    });

    testWebView('is not null', (tester, context) async {
      final customUserAgent = "custom-user-agent";
      await tester.pumpFrames(
        WebView(
          initialUrl: "about:blank",
          onWebViewCreated: context.onWebViewCreated,
          shouldOverrideUrlLoading: context.shouldOverrideUrlLoading,
          onPageStarted: context.onPageStarted,
          onWebResourceError: context.onWebResourceError,
          onProgressChanged: context.onProgressChanged,
          onPageFinished: context.onPageFinished,
          userAgent: customUserAgent,
        ),
      );

      final controller = await context.webviewController.future;
      final userAgent = await controller.evaluateJavascript(
        "navigator.userAgent",
      );
      expect(userAgent, customUserAgent);
    });
  });
}
