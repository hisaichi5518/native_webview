import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_webview/native_webview.dart';

void webViewControllerTests() {
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
      final finishedStreamController = StreamController<String>();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'https://flutter.dev/',
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
            onPageFinished: (controller, url) {
              finishedStreamController.add(url);
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

      await finishedStreamController.stream.firstWhere(
        (element) => element == "https://flutter-header-echo.herokuapp.com/",
      );

      final content = await controller.evaluateJavascript(
        '(() => document.documentElement.innerText)()',
      );
      expect(content.contains('flutter_test_header'), isTrue);
      finishedStreamController.close();
    });
  });

  group("JavascriptHandler", () {
    testWidgets("messages received", (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final finishedCompleter = Completer<String>();
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
              finishedCompleter.complete(url);
            },
          ),
        ),
      );
      final controller = await controllerCompleter.future;

      await finishedCompleter.future;

      await controller.evaluateJavascript("""
      window.nativeWebView.callHandler("hoge", "value", 1, true);
      """);
      expect(argumentsReceived, [
        ["value", 1, true],
      ]);
    });

    testWidgets("nothing handler", (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final finishedCompleter = Completer<String>();
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
              finishedCompleter.complete(url);
            },
          ),
        ),
      );
      final controller = await controllerCompleter.future;

      await finishedCompleter.future;

      // no error
      await controller.evaluateJavascript("""
      window.nativeWebView.callHandler("hoge", "value", 1, true);
      """);
      expect(argumentsReceived, []);
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

    testWidgets('unsupported type', (tester) async {
      if (!Platform.isIOS) {
        return;
      }

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
        await controller.evaluateJavascript('(() => function test() {})()');
      } catch (error) {
        expect(error, isA<PlatformException>());
        expect(
            error.toString(),
            contains(
                "JavaScript execution returned a result of an unsupported type"));
      }
    });
  });
}
