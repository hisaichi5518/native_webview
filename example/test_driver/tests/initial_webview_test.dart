import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_webview/native_webview.dart';

void initialWebViewTest() {
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

    testWidgets('with headers', (WidgetTester tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final finishedCompleter = Completer<String>();
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
              finishedCompleter.complete(url);
            },
          ),
        ),
      );
      final controller = await controllerCompleter.future;
      final currentUrl = await controller.currentUrl();
      expect(currentUrl, 'https://flutter-header-echo.herokuapp.com/');

      await finishedCompleter.future;

      final content = await controller.evaluateJavascript(
        '(() => document.documentElement.innerText)()',
      );
      expect(content.contains('flutter_test_header'), isTrue);
    });
  });

  group("initalData", () {
    testWidgets('with baseUrl', (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final finishedCompleter = Completer<String>();

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
              finishedCompleter.complete(url);
            },
          ),
        ),
      );
      final controller = await controllerCompleter.future;
      final url = await finishedCompleter.future;
      expect(url, baseUrl);

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
    });
    testWidgets('without baseUrl', (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final finishedCompleter = Completer<String>();

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
              finishedCompleter.complete(url);
            },
          ),
        ),
      );
      final controller = await controllerCompleter.future;

      await finishedCompleter.future;

      final content = await controller.evaluateJavascript(
        '(() => document.documentElement.innerText)()',
      );
      expect(content, "yoshitaka-yuriko");

      final currentUrl = await controller.currentUrl();
      expect(currentUrl, "about:blank");
    }, skip: Platform.isAndroid);
  });

  group("initalFile", () {
    testWidgets('from assets', (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final finishedCompleter = Completer<String>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialFile: "test_assets/initial_file.html",
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
            onPageFinished: (controller, url) {
              finishedCompleter.complete(url);
            },
          ),
        ),
      );
      final controller = await controllerCompleter.future;

      final url = await finishedCompleter.future;
      final currentUrl = await controller.currentUrl();
      expect(currentUrl, url);

      final content = await controller.evaluateJavascript(
        '(() => document.documentElement.innerText)()',
      );
      expect(content, "yoshitaka-yuriko");
    });
  });
}
