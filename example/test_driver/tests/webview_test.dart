import 'dart:io';

import 'package:flutter/widgets.dart';
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

  testWebView('onWebResourceError', (tester, context) async {
    await tester.pumpWidget(
      WebView(
        key: GlobalKey(),
        initialUrl: 'https://www.notawebsite..com',
        onWebResourceError: context.onWebResourceError,
        shouldOverrideUrlLoading: (_, request) async {
          context.shouldOverrideUrlLoading(request);
          return ShouldOverrideUrlLoadingAction.allow;
        },
        onPageStarted: context.onPageStarted,
        onPageFinished: context.onPageFinished,
      ),
    );

    context.webResourceError.stream.listen(onData([
      (event) {
        expect(event, isNotNull);
        expect(event.description, isNotNull);
        expect(event.errorCode, isNotNull);

        if (Platform.isAndroid) {
          expect(event.domain, isNull);
          expect(event.errorType, WebResourceErrorType.hostLookup);
        } else {
          expect(event.domain, "NSURLErrorDomain");
          expect(event.errorType, isNull);
        }

        context.complete();
      },
    ]));
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

  group("onReceivedHttpAuthRequest", () {
    testWebView('wait for page finished', (tester, context) async {
      List<HttpAuthChallenge> challengeValues = [];

      await tester.pumpWidget(
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
          onPageFinished: context.onPageFinished,
        ),
      );

      final controller = await context.webviewController.future;
      context.pageFinished.stream.listen(onData([
        (event) async {
          final text = await controller.evaluateJavascript(
            "document.body.textContent",
          );
          expect(challengeValues.length, 2);

          expect(
              challengeValues.map((e) => {"host": e.host, "realm": e.realm}), [
            {"host": "native-webview-basic-auth.herokuapp.com", "realm": null},
            {
              "host": "native-webview-basic-auth.herokuapp.com",
              "realm": "Authorization Required"
            },
            {'host': 'native-webview-basic-auth.herokuapp.com', 'realm': null}
          ]);

          expect(text.toString().contains("Hello world"), true);
          context.complete();
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

  group("debuggingEnabled", () {
    testWebView('is true', (tester, context) async {
      await tester.pumpWidget(
        WebView(
          initialData: WebViewData("""
<!doctype html><html lang="en"><head></head><body>native_webview</body></html>
        """),
          onWebViewCreated: context.onWebViewCreated,
          onPageFinished: context.onPageFinished,
          debuggingEnabled: true,
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

  group("userAgent", () {
    testWebView('is null', (tester, context) async {
      await tester.pumpWidget(
        WebView(
          onWebViewCreated: context.onWebViewCreated,
          onPageFinished: context.onPageFinished,
          debuggingEnabled: true,
        ),
      );

      await context.webviewController.future;
      context.complete();
    });

    testWebView('is not null', (tester, context) async {
      final customUserAgent = "custom-user-agent";
      await tester.pumpWidget(
        WebView(
          onWebViewCreated: context.onWebViewCreated,
          onPageFinished: context.onPageFinished,
          debuggingEnabled: true,
          userAgent: customUserAgent,
        ),
      );

      final controller = await context.webviewController.future;

      context.pageFinished.stream.listen(onData([
        (event) async {
          final userAgent =
              await controller.evaluateJavascript("navigator.userAgent");
          expect(userAgent, customUserAgent);
          context.complete();
        },
      ]));
    });
  });
}
