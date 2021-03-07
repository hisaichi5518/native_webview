import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:native_webview/native_webview.dart';
import 'package:native_webview_example/integration_test/webview_event.dart';

import '../utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("loadUrl", () {
    testWebView('loadUrl(www.google.com)', (tester, context) async {
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
      await controller.loadUrl("https://www.google.com/");

      await sleep();

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

      expect(context.pageFinishedEvents.length, greaterThanOrEqualTo(2));
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
          ));
    });

    testWebView('with headers', (tester, context) async {
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
      final headers = <String, String>{'test_header': 'flutter_test_header'};
      await controller.loadUrl(
        'https://flutter-header-echo.herokuapp.com/',
        headers: headers,
      );
      await sleep();

      final content = await controller.evaluateJavascript(
        '(() => document.documentElement.innerText)()',
      );
      expect(content.contains('flutter_test_header'), isTrue);
    });
  });

  group("JavascriptHandler", () {
    testWebView("messages received", (tester, context) async {
      final argumentsReceived = <List<dynamic>>[];

      await tester.pumpFrames(
        WebView(
          initialUrl: 'about:blank',
          onWebViewCreated: (controller) {
            controller.addJavascriptHandler("hoge", (arguments) async {
              argumentsReceived.add(arguments);
            });
            context.onWebViewCreated(controller);
          },
          shouldOverrideUrlLoading: context.shouldOverrideUrlLoading,
          onPageStarted: context.onPageStarted,
          onWebResourceError: context.onWebResourceError,
          onProgressChanged: context.onProgressChanged,
          onPageFinished: context.onPageFinished,
        ),
      );
      final controller = await context.webviewController.future;
      await controller.evaluateJavascript("""
          window.nativeWebView.callHandler("hoge", "value", 1, true);
          """);
      expect(argumentsReceived, [
        ["value", 1, true],
      ]);
    });

    testWebView("readyState is interactive", (tester, context) async {
      final argumentsReceived = <List<dynamic>>[];

      var beforeReadyState = "loading";
      await tester.pumpFrames(
        WebView(
          initialUrl: 'https://flutter.dev/',
          onWebViewCreated: (controller) {
            controller.addJavascriptHandler("hoge", (arguments) async {
              argumentsReceived.add(arguments);
            });
            context.onWebViewCreated(controller);
          },
          shouldOverrideUrlLoading: context.shouldOverrideUrlLoading,
          onPageStarted: context.onPageStarted,
          onWebResourceError: context.onWebResourceError,
          onProgressChanged: (controller, progress) async {
            final readyState = await controller.evaluateJavascript(
              "document.readyState",
            ) as String;
            print(readyState);

            if (beforeReadyState == "loading" && readyState == "interactive") {
              beforeReadyState = readyState;
              await controller.evaluateJavascript("""
          window.nativeWebView.callHandler("hoge", "value", 1, true);
          """);
              return;
            }
            beforeReadyState = readyState;
            context.onProgressChanged(controller, progress);
          },
          onPageFinished: context.onPageFinished,
        ),
      );

      expect(argumentsReceived, [
        ["value", 1, true],
      ]);
    });

    testWebView("nothing handler", (tester, context) async {
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
      // no error
      await controller.evaluateJavascript("""
      window.nativeWebView.callHandler("hoge", "value", 1, true);
      """);
    });
  });

  group("evaluateJavascript", () {
    testWebView('success', (tester, context) async {
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
      expect(
        await controller.evaluateJavascript('(() => "りんご")()'),
        "りんご",
      );
      expect(
        await controller.evaluateJavascript('(() => 1000)()'),
        1000,
      );
      expect(
        await controller.evaluateJavascript('(() => ["りんご"])()'),
        ["りんご"],
      );
      expect(
        await controller
            .evaluateJavascript('(function() { return {"りんご": "Apple"} })()'),
        {"りんご": "Apple"},
      );

      expect(
        await controller.evaluateJavascript("""
class Rectangle {
  constructor(height, width) {
    this.height = height;
    this.width = width;
  }
}
(() => new Rectangle(100, 200))()
            """),
        {'height': 100, 'width': 200},
      );
    });

    testWebView('invalid javascript', (tester, context) async {
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

      try {
        await controller.evaluateJavascript('() => ');
        fail("syntax error did not occur.");
      } catch (error) {
        // For Android, it's not an error.
        expect(error, isA<PlatformException>());
        expect(error.toString(),
            contains("SyntaxError: Unexpected end of script"));
      }
    }, skip: Platform.isAndroid);

    testWebView('unsupported type', (tester, context) async {
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

      try {
        await controller.evaluateJavascript('(() => function test() {})()');
        fail("syntax error did not occur.");
      } catch (error) {
        // For Android, it's not an error.
        expect(error, isA<PlatformException>());
        expect(error.toString(), contains("unsupported type"));
      }
    }, skip: Platform.isAndroid);
  });

  group("goBack/goForward", () {
    testWebView("can go back/forward", (tester, context) async {
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

      expect(await controller.canGoBack(), false);
      expect(await controller.canGoForward(), false);
      await controller.loadUrl("https://www.google.com/");

      await sleep();

      expect(await controller.canGoBack(), true);
      expect(await controller.canGoForward(), false);
      await controller.goBack();

      await sleep();

      expect(await controller.canGoBack(), false);
      expect(await controller.canGoForward(), true);
      await controller.goForward();
    }, timeout: Duration(seconds: 300));
  });
}
