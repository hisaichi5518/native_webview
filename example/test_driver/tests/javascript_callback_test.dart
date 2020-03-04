import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_webview/native_webview.dart';

void javascriptCallbackTest() {
  group("onJsConfirm", () {
    testWidgets("handled", (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final finishedCompleter = Completer<String>();
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
              finishedCompleter.complete(url);
            },
          ),
        ),
      );
      await controllerCompleter.future;
      await finishedCompleter.future;
    });
  });

  group("onJsAlert", () {
    testWidgets("handled", (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final finishedCompleter = Completer<String>();
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
              finishedCompleter.complete(url);
            },
          ),
        ),
      );
      await controllerCompleter.future;
      await finishedCompleter.future;
    });
  });

  group("onJsPrompt", () {
    testWidgets("handled", (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final finishedCompleter = Completer<String>();
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
              finishedCompleter.complete(url);
            },
          ),
        ),
      );
      await controllerCompleter.future;
      await finishedCompleter.future;
    });
  });
}
