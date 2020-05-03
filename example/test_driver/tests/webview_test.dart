import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:native_webview/native_webview.dart';

import '../utils.dart';

void main() {
  group("initalUrl", () {
    testWebView('https://flutter.dev/', (tester, context) async {
      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://flutter.dev/',
          onWebViewCreated: context.onWebViewCreated,
        ),
      );
      final controller = await context.webviewController.future;
      final currentUrl = await controller.currentUrl();
      expect(currentUrl, 'https://flutter.dev/');
      context.complete();
    });

    testWebView('about:blank', (tester, context) async {
      await tester.pumpWidget(
        WebView(
          initialUrl: 'about:blank',
          onWebViewCreated: context.onWebViewCreated,
        ),
      );
      final controller = await context.webviewController.future;
      final currentUrl = await controller.currentUrl();
      expect(currentUrl, 'about:blank');
      context.complete();
    });

    testWebView('with headers', (tester, context) async {
      final headers = <String, String>{'test_header': 'flutter_test_header'};
      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://flutter-header-echo.herokuapp.com/',
          initialHeaders: headers,
          onWebViewCreated: context.onWebViewCreated,
          onPageFinished: context.onPageFinished,
        ),
      );
      final controller = await context.webviewController.future;
      final currentUrl = await controller.currentUrl();
      expect(currentUrl, 'https://flutter-header-echo.herokuapp.com/');

      context.pageFinished.stream.listen(onData([
        (event) async {
          final content = await controller.evaluateJavascript(
            '(() => document.documentElement.innerText)()',
          );
          expect(content.contains('flutter_test_header'), isTrue);
          context.complete();
        },
      ]));
    });
  });

  group("initalData", () {
    testWebView('with baseUrl', (tester, context) async {
      final baseUrl = "https://flutter.dev/";

      await tester.pumpWidget(
        WebView(
          initialData: WebViewData(
            '<html><body>yoshitaka-yuriko</body></html>',
            baseUrl: baseUrl,
          ),
          onWebViewCreated: context.onWebViewCreated,
          onPageFinished: context.onPageFinished,
        ),
      );
      final controller = await context.webviewController.future;

      context.pageFinished.stream.listen(onData([
        (event) async {
          expect(event, baseUrl);

          final content = await controller.evaluateJavascript(
            '(() => document.documentElement.innerText)()',
          );
          expect(content, "yoshitaka-yuriko");

          final currentUrl = await controller.currentUrl();
          if (Platform.isIOS) {
            expect(currentUrl, baseUrl);
          } else if (Platform.isAndroid) {
            expect(currentUrl, "about:blank");
          }
          context.complete();
        }
      ]));
    });

    testWebView('without baseUrl', (tester, context) async {
      await tester.pumpWidget(
        WebView(
          initialData: WebViewData(
            '<html><body>yoshitaka-yuriko</body></html>',
          ),
          onWebViewCreated: context.onWebViewCreated,
          onPageFinished: context.onPageFinished,
        ),
      );
      final controller = await context.webviewController.future;

      context.pageFinished.stream.listen(onData([
        (event) async {
          final content = await controller.evaluateJavascript(
            '(() => document.documentElement.innerText)()',
          );
          expect(content, "yoshitaka-yuriko");
          final currentUrl = await controller.currentUrl();
          expect(currentUrl, "about:blank");

          context.complete();
        },
      ]));
    });
  });

  group("initalFile", () {
    testWebView('from assets', (tester, context) async {
      await tester.pumpWidget(
        WebView(
          initialFile: "test_assets/initial_file.html",
          onWebViewCreated: context.onWebViewCreated,
          onPageFinished: context.onPageFinished,
        ),
      );
      final controller = await context.webviewController.future;

      context.pageFinished.stream.listen(onData([
        (event) async {
          final currentUrl = await controller.currentUrl();
          expect(event, currentUrl);

          final content = await controller.evaluateJavascript(
            '(() => document.documentElement.innerText)()',
          );
          expect(content, "yoshitaka-yuriko");

          context.complete();
        },
      ]));
    });
  });

  group("onJsConfirm", () {
    testWebView("handled", (tester, context) async {
      var count = 0;
      await tester.pumpWidget(
        WebView(
          initialData: WebViewData(
            '<html><body><script>window.confirm("confirm")</script></body></html>',
          ),
          onJsConfirm: (controller, message) {
            count++;
            return JsConfirmResponse.handled(JsConfirmResponseAction.cancel);
          },
          onWebViewCreated: context.onWebViewCreated,
          onPageFinished: context.onPageFinished,
        ),
      );
      context.pageFinished.stream.listen(onData([
        (event) async {
          Future.delayed(Duration(seconds: 5), () {
            expect(count, 1);
            context.complete();
          });
        },
      ]));
    });
  });

  group("onJsAlert", () {
    testWebView("handled", (tester, context) async {
      var count = 0;

      await tester.pumpWidget(
        WebView(
          initialData: WebViewData(
            '<html><body><script>window.alert("alert")</script></body></html>',
          ),
          onJsAlert: (controller, message) {
            count++;
            return JsAlertResponse.handled();
          },
          onWebViewCreated: context.onWebViewCreated,
          onPageFinished: context.onPageFinished,
        ),
      );
      context.pageFinished.stream.listen(onData([
        (event) async {
          Future.delayed(Duration(seconds: 5), () {
            expect(count, 1);
            context.complete();
          });
        },
      ]));
    });
  });

  group("onJsPrompt", () {
    testWebView("handled", (tester, context) async {
      var count = 0;

      await tester.pumpWidget(
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
          onPageFinished: context.onPageFinished,
        ),
      );
      context.pageFinished.stream.listen(onData([
        (event) async {
          Future.delayed(Duration(seconds: 5), () {
            expect(count, 1);
            context.complete();
          });
        },
      ]));
    });
  });

  group("onProgressChanged", () {
    testWebView('wait for page finished', (tester, context) async {
      List<int> progressValues = [];
      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://flutter.dev/',
          onProgressChanged: (controller, progress) {
            progressValues.add(progress);
          },
          onWebViewCreated: context.onWebViewCreated,
          onPageFinished: context.onPageFinished,
        ),
      );

      context.pageFinished.stream.listen(onData([
        (event) async {
          Future.delayed(Duration(seconds: 5), () {
            expect(progressValues.last, 100);
            context.complete();
          });
        },
      ]));
    });
  });

  group("gestureNavigationEnabled", () {
    testWebView('is true', (tester, context) async {
      List<int> progressValues = [];
      await tester.pumpWidget(
        WebView(
          initialData: WebViewData("""
<!doctype html><html lang="en"><head></head><body>native_webview</body></html>
        """),
          onProgressChanged: (controller, progress) {
            progressValues.add(progress);
          },
          onWebViewCreated: context.onWebViewCreated,
          onPageFinished: context.onPageFinished,
          gestureNavigationEnabled: true,
        ),
      );

      context.pageFinished.stream.listen(onData([
        (event) async {
          expect(event, "about:blank");
          context.complete();
        },
      ]));
    });
  });
}
