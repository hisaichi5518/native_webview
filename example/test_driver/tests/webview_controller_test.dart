import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_webview/native_webview.dart';

import '../utils.dart';

void main() {
  group("loadUrl", () {
    testWebView('loadUrl', (tester, context) async {
      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://flutter.dev/',
          onWebViewCreated: context.onWebViewCreated,
          onPageStarted: context.onPageStarted,
          onPageFinished: context.onPageFinished,
        ),
      );
      final controller = await context.webviewController.future;
      context.pageStarted.stream.listen(onData([
        (event) async {
          expect(event, "https://flutter.dev/");
          final currentUrl = await controller.currentUrl();
          expect(currentUrl, 'https://flutter.dev/');
        },
        (event) async {
          expect(event, "https://www.google.com/");
          final currentUrl = await controller.currentUrl();
          expect(currentUrl, 'https://www.google.com/');
        },
      ]));

      context.pageFinished.stream.listen(onData([
        (event) async {
          expect(event, "https://flutter.dev/");
          final currentUrl = await controller.currentUrl();
          expect(currentUrl, 'https://flutter.dev/');

          await controller.loadUrl('https://www.google.com/');
        },
        (event) async {
          expect(event, "https://www.google.com/");
          final currentUrl = await controller.currentUrl();
          expect(currentUrl, 'https://www.google.com/');

          context.complete();
        },
      ]));
    });

    testWebView('with headers', (tester, context) async {
      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://flutter.dev/',
          onWebViewCreated: context.onWebViewCreated,
          onPageFinished: context.onPageFinished,
        ),
      );
      final controller = await context.webviewController.future;

      context.pageFinished.stream.listen(onData([
        (event) async {
          expect(event, "https://flutter.dev/");

          final headers = <String, String>{
            'test_header': 'flutter_test_header'
          };
          await controller.loadUrl(
            'https://flutter-header-echo.herokuapp.com/',
            headers: headers,
          );
        },
        (event) async {
          expect(event, "https://flutter-header-echo.herokuapp.com/");
          final content = await controller.evaluateJavascript(
            '(() => document.documentElement.innerText)()',
          );
          expect(content.contains('flutter_test_header'), isTrue);
          context.complete();
        },
      ]));
    });
  });

  group("JavascriptHandler", () {
    testWebView("messages received", (tester, context) async {
      final List<List<dynamic>> argumentsReceived = [];

      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://flutter.dev/',
          onWebViewCreated: (controller) {
            controller.addJavascriptHandler("hoge", (arguments) async {
              argumentsReceived.add(arguments);
            });
            context.onWebViewCreated(controller);
          },
          onPageFinished: context.onPageFinished,
        ),
      );
      final controller = await context.webviewController.future;

      context.pageFinished.stream.listen(onData([
        (event) async {
          await controller.evaluateJavascript("""
          window.nativeWebView.callHandler("hoge", "value", 1, true);
          """);
          expect(argumentsReceived, [
            ["value", 1, true],
          ]);
          context.complete();
        },
      ]));
    });

    testWebView("nothing handler", (tester, context) async {
      final List<List<dynamic>> argumentsReceived = [];

      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://flutter.dev/',
          onWebViewCreated: context.onWebViewCreated,
          onPageFinished: context.onPageFinished,
        ),
      );
      final controller = await context.webviewController.future;
      context.pageFinished.stream.listen(onData([
        (event) async {
          // no error
          await controller.evaluateJavascript("""
          window.nativeWebView.callHandler("hoge", "value", 1, true);
          """);
          expect(argumentsReceived, []);
          context.complete();
        },
      ]));
    });
  });

  group("evaluateJavascript", () {
    testWebView('success', (tester, context) async {
      await tester.pumpWidget(
        WebView(
          initialUrl: 'about:blank',
          onWebViewCreated: context.onWebViewCreated,
          onPageFinished: context.onPageFinished,
        ),
      );
      final controller = await context.webviewController.future;

      context.pageFinished.stream.listen(onData([
        (event) async {
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
            await controller.evaluateJavascript(
                '(function() { return {"りんご": "Apple"} })()'),
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

          context.complete();
        },
      ]));
    });

    testWebView('invalid javascript', (tester, context) async {
      await tester.pumpWidget(
        WebView(
          initialUrl: 'about:blank',
          onWebViewCreated: context.onWebViewCreated,
          onPageFinished: context.onPageFinished,
        ),
      );
      final controller = await context.webviewController.future;

      context.pageFinished.stream.listen(onData([
        (event) async {
          try {
            await controller.evaluateJavascript('() => ');
            fail("syntax error did not occur.");
          } catch (error) {
            // For Android, it's not an error.
            expect(error, isA<PlatformException>());
            expect(error.toString(),
                contains("SyntaxError: Unexpected end of script"));
          } finally {
            context.complete();
          }
        },
      ]));
    }, skip: Platform.isAndroid);

    testWebView('unsupported type', (tester, context) async {
      await tester.pumpWidget(
        WebView(
          initialUrl: 'about:blank',
          onWebViewCreated: context.onWebViewCreated,
          onPageFinished: context.onPageFinished,
        ),
      );
      final controller = await context.webviewController.future;

      context.pageFinished.stream.listen(onData([
        (event) async {
          try {
            await controller.evaluateJavascript('(() => function test() {})()');
          } catch (error) {
            // For Android, it's not an error.
            expect(error, isA<PlatformException>());
            expect(
                error.toString(),
                contains(
                    "JavaScript execution returned a result of an unsupported type"));

            context.complete();
          }
        },
      ]));
    }, skip: Platform.isAndroid);
  });

  group("goBack/goForward", () {
    testWebView("can go back/forward(iOS)", (tester, context) async {
      await tester.pumpWidget(
        WebView(
          initialUrl: 'about:blank',
          onWebViewCreated: context.onWebViewCreated,
          onPageStarted: context.onPageStarted,
          onPageFinished: context.onPageFinished,
        ),
      );
      final controller = await context.webviewController.future;

      context.pageFinished.stream.listen(onData([
        (event) async {
          expect(await controller.canGoBack(), false);
          expect(await controller.canGoForward(), false);
          await controller.loadUrl("https://www.google.com/");
        },
        (event) async {
          expect(await controller.canGoBack(), true);
          expect(await controller.canGoForward(), false);
          await controller.goBack();
        },
        (event) async {
          expect(await controller.canGoBack(), false);
          expect(await controller.canGoForward(), true);
          await controller.goForward();
        },
        (event) async {
          expect(await controller.canGoBack(), true);
          expect(await controller.canGoForward(), false);
          context.complete();
        },
      ]));
    }, skip: !Platform.isIOS);

    testWebView("can go back/forward(Android)", (tester, context) async {
      await tester.pumpWidget(
        WebView(
          initialUrl: 'about:blank',
          onWebViewCreated: context.onWebViewCreated,
          onPageFinished: context.onPageFinished,
        ),
      );
      final controller = await context.webviewController.future;

      context.pageFinished.stream.listen(onData([
        (event) async {
          expect(await controller.canGoBack(), false);
          expect(await controller.canGoForward(), false);
          await controller.loadUrl("https://www.google.com/");
        },
        (event) async {
          expect(await controller.canGoBack(), true);
          expect(await controller.canGoForward(), false);
          expect(event, "https://www.google.com/");
          await controller.goBack();
        },
        (event) async {
          expect(await controller.canGoBack(), false);
          expect(await controller.canGoForward(), true);
          await controller.goForward();
        },
        (event) async {
          // skip
          // Android WebView sometimes returns false.
//          expect(await controller.canGoBack(), true);
          // Android WebView sometimes returns true.
//          expect(await controller.canGoForward(), false);
          context.complete();
        },
      ]));
    }, skip: !Platform.isAndroid);
  });

  group("getAndroidWebViewInfo", () {
    testWebView("return not null", (tester, context) async {
      await tester.pumpWidget(
        WebView(
          initialUrl: 'about:blank',
          onWebViewCreated: context.onWebViewCreated,
          onPageStarted: context.onPageStarted,
          onPageFinished: context.onPageFinished,
        ),
      );
      final controller = await context.webviewController.future;
      final webviewInfo = await controller.getAndroidWebViewInfo();

      expect(webviewInfo, isNotNull);
      expect(webviewInfo.versionName, isNotEmpty);
      expect(webviewInfo.packageName, isNotEmpty);

      context.complete();
    }, skip: !Platform.isAndroid);

    testWebView("return null", (tester, context) async {
      await tester.pumpWidget(
        WebView(
          initialUrl: 'about:blank',
          onWebViewCreated: context.onWebViewCreated,
          onPageStarted: context.onPageStarted,
          onPageFinished: context.onPageFinished,
        ),
      );
      final controller = await context.webviewController.future;
      final webviewInfo = await controller.getAndroidWebViewInfo();

      expect(webviewInfo, isNull);

      context.complete();
    }, skip: !Platform.isIOS);
  });
}
