import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_webview/native_webview.dart';

void messageHandlerTest() {
  group("MessageHandler", () {
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
}
