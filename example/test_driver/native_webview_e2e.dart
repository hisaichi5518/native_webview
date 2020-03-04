import 'dart:async';
import 'dart:io';

import 'package:e2e/e2e.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_webview/native_webview.dart';

void main() {
  E2EWidgetsFlutterBinding.ensureInitialized();

  group("initalUrl", () {
    testWidgets('https://flutter.dev/', (tester) async {
      final controllerCompleter = Completer<WebViewController>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'https://flutter.dev/',
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
          ),
        ),
      );
      final controller = await controllerCompleter.future;
      final currentUrl = await controller.currentUrl();
      expect(currentUrl, 'https://flutter.dev/');
    });

    testWidgets('about:blank', (tester) async {
      final controllerCompleter = Completer<WebViewController>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'about:blank',
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
          ),
        ),
      );
      final controller = await controllerCompleter.future;
      final currentUrl = await controller.currentUrl();
      expect(currentUrl, 'about:blank');
    });

    testWidgets('invalid url', (tester) async {
      final controllerCompleter = Completer<WebViewController>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'https',
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
          ),
        ),
      );
      final controller = await controllerCompleter.future;
      final currentUrl = await controller.currentUrl();
      expect(currentUrl, 'https');
    });

    testWidgets('with headers', (WidgetTester tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final finishedStream = StreamController<String>();
      final headers = <String, String>{'test_header': 'flutter_test_header'};
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'https://flutter-header-echo.herokuapp.com/',
            initialHeaders: headers,
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
            onPageFinished: (controller, url) {
              finishedStream.add(url);
            },
          ),
        ),
      );
      final controller = await controllerCompleter.future;
      final currentUrl = await controller.currentUrl();
      expect(currentUrl, 'https://flutter-header-echo.herokuapp.com/');

      await finishedStream.stream.firstWhere(
        (element) => element == "https://flutter-header-echo.herokuapp.com/",
      );

      final content = await controller.evaluateJavascript(
        '(() => document.documentElement.innerText)()',
      );
      expect(content.contains('flutter_test_header'), isTrue);
      finishedStream.close();
    });
  });

  group("initalData", () {
    testWidgets('with baseUrl', (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final finishedStream = StreamController<String>();

      final baseUrl = "https://flutter.dev/";

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialData: WebViewData(
              '<html><body>yoshitaka-yuriko</body></html>',
              baseUrl: baseUrl,
            ),
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
            onPageFinished: (controller, url) {
              finishedStream.add(url);
            },
          ),
        ),
      );
      final controller = await controllerCompleter.future;

      await finishedStream.stream.firstWhere((element) => element == baseUrl);

      final content = await controller.evaluateJavascript(
        '(() => document.documentElement.innerText)()',
      );
      expect(content, "yoshitaka-yuriko");

      final currentUrl = await controller.currentUrl();
      expect(currentUrl, baseUrl);
      finishedStream.close();
    });
    testWidgets('without baseUrl', (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final finishedStream = StreamController<String>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialData: WebViewData(
              '<html><body>yoshitaka-yuriko</body></html>',
            ),
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
            onPageFinished: (controller, url) {
              finishedStream.add(url);
            },
          ),
        ),
      );
      final controller = await controllerCompleter.future;

      await finishedStream.stream
          .firstWhere((element) => element == "about:blank");

      final content = await controller.evaluateJavascript(
        '(() => document.documentElement.innerText)()',
      );
      expect(content, "yoshitaka-yuriko");

      final currentUrl = await controller.currentUrl();
      expect(currentUrl, "about:blank");
      finishedStream.close();
    });
  });

  group("initalFile", () {
    testWidgets('from assets', (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final finishedStream = StreamController<String>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialFile: "test_assets/initial_file.html",
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
            onPageFinished: (controller, url) {
              finishedStream.add(url);
            },
          ),
        ),
      );
      final controller = await controllerCompleter.future;

      final url = await finishedStream.stream.first;

      final content = await controller.evaluateJavascript(
        '(() => document.documentElement.innerText)()',
      );
      expect(content, "yoshitaka-yuriko");

      final currentUrl = await controller.currentUrl();
      expect(currentUrl, url);
      finishedStream.close();
    });
  });

  group("evaluateJavascript", () {
    testWidgets('success', (tester) async {
      final controllerCompleter = Completer<WebViewController>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'about:blank',
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
          ),
        ),
      );
      final controller = await controllerCompleter.future;
      final result = await controller.evaluateJavascript('(() => "test ok")()');
      expect(result, 'test ok');
    });

    testWidgets('return object', (tester) async {
      final controllerCompleter = Completer<WebViewController>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'about:blank',
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
          ),
        ),
      );
      final controller = await controllerCompleter.future;
      final result = await controller.evaluateJavascript('(() => {test: 1})()');
      if (Platform.isIOS) {
        expect(result, isNull);
      } else if (Platform.isAndroid) {
        expect(result, isNotNull);
      } else {
        fail("Not support platform");
      }
    });

    testWidgets('invalid javascript', (tester) async {
      final controllerCompleter = Completer<WebViewController>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'about:blank',
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
          ),
        ),
      );
      final controller = await controllerCompleter.future;
      try {
        await controller.evaluateJavascript('() => ');
      } catch (error) {
        expect(error, isA<PlatformException>());
        expect(error.toString(),
            contains("SyntaxError: Unexpected end of script"));
      }
    });
  });

  group("onPageStarted", () {
    testWidgets('wait for page started', (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final streamController = StreamController<String>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'https://flutter.dev/',
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
            onPageStarted: (controller, url) {
              streamController.add(url);
            },
          ),
        ),
      );

      final url = await streamController.stream
          .firstWhere((element) => element == "https://flutter.dev/");
      expect(url, "https://flutter.dev/");
      streamController.close();
    });
  });

  group("onPageFinished", () {
    testWidgets('wait for page finished', (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final streamController = StreamController<String>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'https://flutter.dev/',
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
            onPageFinished: (controller, url) {
              streamController.add(url);
            },
          ),
        ),
      );

      final url = await streamController.stream
          .firstWhere((element) => element == "https://flutter.dev/");
      expect(url, "https://flutter.dev/");
      streamController.close();
    });
  });

  group("onPageFinished", () {
    testWidgets('wait for page finished', (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final streamController = StreamController<String>();

      List<int> progressValues = [];
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'https://flutter.dev/',
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
            onProgressChanged: (controller, progress) {
              progressValues.add(progress);
            },
            onPageFinished: (controller, url) {
              streamController.add(url);
            },
          ),
        ),
      );

      final url = await streamController.stream
          .firstWhere((element) => element == "https://flutter.dev/");
      expect(url, "https://flutter.dev/");
      expect(progressValues.last, 100);
      streamController.close();
    });
  });

  group("loadUrl", () {
    testWidgets('loadUrl', (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'https://flutter.dev/',
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
          ),
        ),
      );
      final controller = await controllerCompleter.future;
      await controller.loadUrl('https://www.google.com/');
      final currentUrl = await controller.currentUrl();
      expect(currentUrl, 'https://www.google.com/');
    });

    testWidgets('with headers', (WidgetTester tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final finishedStream = StreamController<String>();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'https://flutter.dev/',
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
            onPageFinished: (controller, url) {
              finishedStream.add(url);
            },
          ),
        ),
      );
      final controller = await controllerCompleter.future;
      final headers = <String, String>{'test_header': 'flutter_test_header'};
      await controller.loadUrl(
        'https://flutter-header-echo.herokuapp.com/',
        headers: headers,
      );
      final currentUrl = await controller.currentUrl();
      expect(currentUrl, 'https://flutter-header-echo.herokuapp.com/');

      await finishedStream.stream.firstWhere(
        (element) => element == "https://flutter-header-echo.herokuapp.com/",
      );

      final content = await controller.evaluateJavascript(
        '(() => document.documentElement.innerText)()',
      );
      expect(content.contains('flutter_test_header'), isTrue);
      finishedStream.close();
    });
  });

  group("JavascriptHandler", () {
    testWidgets("messages received", (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final streamController = StreamController<String>();
      final List<List<dynamic>> argumentsReceived = [];

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'https://flutter.dev/',
            onWebViewCreated: (controller) {
              controller.addJavascriptHandler("hoge", (arguments) async {
                argumentsReceived.add(arguments);
              });
              controllerCompleter.complete(controller);
            },
            onPageFinished: (controller, url) {
              streamController.add(url);
            },
          ),
        ),
      );
      final controller = await controllerCompleter.future;

      await streamController.stream
          .firstWhere((element) => element == "https://flutter.dev/");

      await controller.evaluateJavascript("""
      window.nativeWebView.callHandler("hoge", "value", 1, true);
      """);
      expect(argumentsReceived, [
        ["value", 1, true],
      ]);
      streamController.close();
    });

    testWidgets("nothing handler", (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final streamController = StreamController<String>();
      final List<List<dynamic>> argumentsReceived = [];

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'https://flutter.dev/',
            onWebViewCreated: (controller) {
              controllerCompleter.complete(controller);
            },
            onPageFinished: (controller, url) {
              streamController.add(url);
            },
          ),
        ),
      );
      final controller = await controllerCompleter.future;

      await streamController.stream
          .firstWhere((element) => element == "https://flutter.dev/");

      // no error
      await controller.evaluateJavascript("""
      window.nativeWebView.callHandler("hoge", "value", 1, true);
      """);
      expect(argumentsReceived, []);
      streamController.close();
    });
  });

  group("onJsConfirm", () {
    testWidgets("handled", (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final streamController = StreamController<String>();
      final List<List<dynamic>> argumentsReceived = [];

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialData: WebViewData(
              '<html><body><script>window.confirm("confirm")</script></body></html>',
            ),
            onWebViewCreated: (controller) {
              controllerCompleter.complete(controller);
            },
            onJsConfirm: (controller, message) {
              return JsConfirmResponse.handled(JsConfirmResponseAction.cancel);
            },
            onPageFinished: (controller, url) {
              streamController.add(url);
            },
          ),
        ),
      );
      await controllerCompleter.future;
      await streamController.stream.first;
      streamController.close();
    });
  });

  group("onJsAlert", () {
    testWidgets("handled", (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final streamController = StreamController<String>();
      final List<List<dynamic>> argumentsReceived = [];

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialData: WebViewData(
              '<html><body><script>window.alert("alert")</script></body></html>',
            ),
            onWebViewCreated: (controller) {
              controllerCompleter.complete(controller);
            },
            onJsAlert: (controller, message) {
              return JsAlertResponse.handled();
            },
            onPageFinished: (controller, url) {
              streamController.add(url);
            },
          ),
        ),
      );
      await controllerCompleter.future;
      await streamController.stream.first;
      streamController.close();
    });
  });

  group("onJsPrompt", () {
    testWidgets("handled", (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final streamController = StreamController<String>();
      final List<List<dynamic>> argumentsReceived = [];

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialData: WebViewData(
              '<html><body><script>window.prompt("prompt", "text")</script></body></html>',
            ),
            onWebViewCreated: (controller) {
              controllerCompleter.complete(controller);
            },
            onJsPrompt: (controller, message, defaultText) {
              return JsPromptResponse.handled(
                JsPromptResponseAction.ok,
                "value",
              );
            },
            onPageFinished: (controller, url) {
              streamController.add(url);
            },
          ),
        ),
      );
      await controllerCompleter.future;
      await streamController.stream.first;
      streamController.close();
    });
  });
}
