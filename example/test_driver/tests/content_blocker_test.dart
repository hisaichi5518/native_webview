import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:native_webview/native_webview.dart';

import '../utils.dart';

void main() {
  group("ContentBlockerAction.block()", () {
    testWebView('https://flutter.dev/', (tester, context) async {
      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://flutter.dev/',
          onWebViewCreated: context.onWebViewCreated,
          shouldOverrideUrlLoading: (_, request) async {
            context.shouldOverrideUrlLoading(request);
            return ShouldOverrideUrlLoadingAction.allow;
          },
          onPageStarted: context.onPageStarted,
          onPageFinished: context.onPageFinished,
          contentBlockers: [
            ContentBlocker(
              action: ContentBlockerAction.block(),
              trigger: ContentBlockerTrigger(urlFilter: ".*"),
            )
          ],
        ),
      );
      context.pageStarted.stream.listen(onData([
        (event) async {
          expect(event, "https://flutter.dev/");

          await Future.delayed(Duration(seconds: 10), () {
            expect(context.loadingRequestEvents.length, 0);
            expect(context.pageStartedEvents.length, 1);
            if (Platform.isAndroid) {
              // Android's shouldInterceptRequest does not target the URL of the MainFrame, so onPageFinished will be executed.
              expect(context.pageFinishedEvents.length, 1);
            } else {
              // On iOS, onPageFinished is not executed because it is the target of the URL ContentBlocker in the MainFrame.
              expect(context.pageFinishedEvents.length, 0);
            }
            context.complete();
          });
        },
      ]));
    });
  });
}
