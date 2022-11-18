import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:native_webview/native_webview.dart';
import 'package:native_webview_example/integration_test/webview_event.dart';

import '../utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("ContentBlockerAction.block()", () {
    testWebView('about:blank', (tester, context) async {
      await tester.pumpFrames(
        WebView(
          initialUrl: 'about:blank',
          onWebViewCreated: context.onWebViewCreated,
          shouldOverrideUrlLoading: context.shouldOverrideUrlLoading,
          onPageStarted: context.onPageStarted,
          onPageFinished: context.onPageFinished,
          onWebResourceError: context.onWebResourceError,
          onProgressChanged: context.onProgressChanged,
          contentBlockers: [
            ContentBlocker(
              action: ContentBlockerAction.block(),
              trigger: ContentBlockerTrigger(urlFilter: ".*"),
            )
          ],
        ),
      );

      expect(context.pageStartedEvents, [
        WebViewEvent.pageStarted(
          "about:blank",
          "about:blank",
          false,
          false,
        ),
      ]);

      expect(context.pageFinishedEvents, [
        WebViewEvent.pageFinished(
          "about:blank",
          "about:blank",
          false,
          false,
        ),
      ]);

      // about:blank will not be blocked
      expect(context.webResourceErrorEvents, []);
    });

    testWebView('https://www.google.com/', (tester, context) async {
      await tester.pumpFrames(
        WebView(
          initialUrl: 'https://www.google.com/',
          onWebViewCreated: context.onWebViewCreated,
          shouldOverrideUrlLoading: context.shouldOverrideUrlLoading,
          onPageStarted: context.onPageStarted,
          onPageFinished: context.onPageFinished,
          onWebResourceError: context.onWebResourceError,
          onProgressChanged: context.onProgressChanged,
          contentBlockers: [
            ContentBlocker(
              action: ContentBlockerAction.block(),
              trigger: ContentBlockerTrigger(urlFilter: ".*"),
            )
          ],
        ),
      );

      expect(
        context.pageStartedEvents,
        anyOf(
          equals([
            WebViewEvent.pageStarted(
              "https://www.google.com/",
              "https://www.google.com/",
              false,
              false,
            ),
          ]),
          equals([]), // The pageStarted event does not come in CI.
        ),
      );

      if (Platform.isIOS) {
        // On iOS, onPageFinished is not executed
        // because it is the target of the URL ContentBlocker in the MainFrame.
        expect(context.pageFinishedEvents, []);
        expect(
          context.webResourceErrorEvents.map((e) => e.error.errorCode),
          [104],
        );
        expect(
          context.webResourceErrorEvents.map((e) => e.error.description),
          [contains("The URL was blocked by a content blocker")],
        );
      } else {
        // Depending on Android's OS, shouldInterceptRequest does not target the URL of the MainFrame,
        // so onPageFinished will be executed.
        expect(
          context.pageFinishedEvents,
          anyOf(isEmpty, [
            WebViewEvent.pageFinished(
              "https://www.google.com/",
              "https://www.google.com/",
              false,
              false,
            ),
          ]),
        );
        expect(
          context.webResourceErrorEvents.map((e) => e.error.errorType),
          [WebResourceErrorType.unknown],
        );
        expect(
          context.webResourceErrorEvents.map((e) => e.error.description),
          [contains("There was a network error.")],
        );
      }
    });
  });
}
