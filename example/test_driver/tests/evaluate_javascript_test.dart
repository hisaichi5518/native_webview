import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_webview/native_webview.dart';

void evaluateJavascriptTest() {
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
