import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_webview/native_webview.dart';

import '../utils.dart';

void main() {
  if (!Platform.isIOS) {
    return;
  }

  group("The URL loaded by initialUrl", () {
    testWebView('about:blank', (tester, context) async {
      await tester.pumpWidget(
        WebView(
          initialUrl: 'about:blank',
          onWebViewCreated: context.onWebViewCreated,
          shouldOverrideUrlLoading: (_, request) async {
            context.shouldOverrideUrlLoading(request);
            return ShouldOverrideUrlLoadingAction.allow;
          },
          onPageStarted: context.onPageStarted,
          onPageFinished: context.onPageFinished,
        ),
      );

      context.pageStarted.stream.listen(onData([
        (event) {
          expect(event, "about:blank");
        },
      ]));
      context.pageFinished.stream.listen(onData([
        (event) {
          expect(event, "about:blank");
          expect(context.loadingRequestEvents.length, 0);
          expect(context.pageStartedEvents.length, 1);
          context.complete();
        },
      ]));
    });

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
        ),
      );

      context.loadingRequests.stream.listen(onData([
        (event) {
          expect(event.url, "https://www.youtube.com/embed/W1pNjxmNHNQ");
          expect(event.method, "GET");
          expect(event.headers, {
            'User-Agent': isNotEmpty,
            'Accept': isNotEmpty,
            'Referer': "https://flutter.dev/",
          });
          expect(event.isForMainFrame, false);
        },
        (event) {
          expect(event.url,
              "https://www.youtube.com/embed/fq4N0hgOWzU?cc_lang_pref=en&cc_load_policy=1&enablejsapi=1");
          expect(event.method, "GET");
          expect(event.headers, {
            'User-Agent': isNotEmpty,
            'Accept': isNotEmpty,
            'Referer': "https://flutter.dev/",
          });
          expect(event.isForMainFrame, false);
        },
      ]));
      context.pageStarted.stream.listen(onData([
        (event) {
          expect(event, "https://flutter.dev/");
        },
      ]));
      context.pageFinished.stream.listen(onData([
        (event) {
          expect(event, "https://flutter.dev/");
          expect(context.loadingRequestEvents.length, 2);
          expect(context.pageStartedEvents.length, 1);
          context.complete();
        },
      ]));
    });

    testWebView('https://google.com', (tester, context) async {
      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://google.com',
          onWebViewCreated: context.onWebViewCreated,
          shouldOverrideUrlLoading: (_, request) async {
            context.shouldOverrideUrlLoading(request);
            return ShouldOverrideUrlLoadingAction.allow;
          },
          onPageStarted: context.onPageStarted,
          onPageFinished: context.onPageFinished,
        ),
      );

      context.loadingRequests.stream.listen(onData([
        (event) {
          expect(event.url, "https://www.google.com/");
          expect(event.method, "GET");
          expect(event.headers, {
            'User-Agent': isNotEmpty,
            'Accept': isNotEmpty,
            'Accept-Encoding': isNotEmpty,
            'Accept-Language': isNotEmpty,
          });
          expect(event.isForMainFrame, true);
        },
      ]));
      context.pageStarted.stream.listen(onData([
        (event) {
          expect(event, "https://google.com/");
        },
      ]));
      context.pageFinished.stream.listen(onData([
        (event) {
          expect(event, "https://www.google.com/");
          expect(context.pageStartedEvents.length, 1);
          expect(context.loadingRequestEvents.length, 1);
          context.complete();
        },
      ]));
    });
  });

  group("The URL loaded by initialData", () {
    testWebView('baseUrl is null', (tester, context) async {
      await tester.pumpWidget(
        WebView(
          key: GlobalKey(),
          initialData: WebViewData("""
<!doctype html><html lang="en"><head></head><body>native_webview</body></html>
        """),
          onWebViewCreated: context.onWebViewCreated,
          shouldOverrideUrlLoading: (_, request) async {
            context.shouldOverrideUrlLoading(request);
            return ShouldOverrideUrlLoadingAction.allow;
          },
          onPageStarted: context.onPageStarted,
          onPageFinished: context.onPageFinished,
        ),
      );

      context.pageStarted.stream.listen(onData([
        (event) {
          expect(event, "about:blank");
        },
      ]));
      context.pageFinished.stream.listen(onData([
        (event) {
          expect(event, "about:blank");
          expect(context.loadingRequestEvents.length, 0);
          expect(context.pageStartedEvents.length, 1);

          context.complete();
        },
      ]));
    });

    testWebView('baseUrl is https://example.com/', (tester, context) async {
      await tester.pumpWidget(
        WebView(
          key: GlobalKey(),
          initialData: WebViewData("""
<!doctype html><html lang="en"><head></head><body>native_webview</body></html>
        """, baseUrl: "https://example.com/"),
          onWebViewCreated: context.onWebViewCreated,
          shouldOverrideUrlLoading: (_, request) async {
            context.shouldOverrideUrlLoading(request);
            return ShouldOverrideUrlLoadingAction.allow;
          },
          onPageStarted: context.onPageStarted,
          onPageFinished: context.onPageFinished,
        ),
      );

      await context.webviewController.future;

      context.pageStarted.stream.listen(onData([
        (event) {
          expect(event, "https://example.com/");
        },
      ]));
      context.pageFinished.stream.listen(onData([
        (event) {
          expect(event, "https://example.com/");
          expect(context.loadingRequestEvents.length, 0);
          expect(context.pageStartedEvents.length, 1);
          context.complete();
        },
      ]));
    });
  });

  testWebView('The URL loaded by initialFile', (tester, context) async {
    await tester.pumpWidget(
      WebView(
        key: GlobalKey(),
        initialFile: "test_assets/initial_file.html",
        onWebViewCreated: context.onWebViewCreated,
        shouldOverrideUrlLoading: (_, request) async {
          context.shouldOverrideUrlLoading(request);
          return ShouldOverrideUrlLoadingAction.allow;
        },
        onPageStarted: context.onPageStarted,
        onPageFinished: context.onPageFinished,
      ),
    );

    context.pageStarted.stream.listen(onData([
      (event) {
        expect(
            event, contains("/flutter_assets/test_assets/initial_file.html"));
      },
    ]));
    context.pageFinished.stream.listen(onData([
      (event) {
        expect(
            event, contains("/flutter_assets/test_assets/initial_file.html"));
        expect(context.loadingRequestEvents.length, 0);
        expect(context.pageStartedEvents.length, 1);

        context.complete();
      },
    ]));
  });

  testWebView('Load the URL of page not found', (tester, context) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: WebView(
          key: GlobalKey(),
          initialUrl: "https://flutter.dev/404",
          onWebViewCreated: context.onWebViewCreated,
          shouldOverrideUrlLoading: (_, request) async {
            context.shouldOverrideUrlLoading(request);
            return ShouldOverrideUrlLoadingAction.allow;
          },
          onPageStarted: context.onPageStarted,
          onPageFinished: context.onPageFinished,
        ),
      ),
    );

    context.pageStarted.stream.listen(onData([
      (event) {
        expect(event, "https://flutter.dev/404");
      },
    ]));
    context.pageFinished.stream.listen(onData([
      (event) {
        expect(event, "https://flutter.dev/404");
        expect(context.loadingRequestEvents.length, 0);
        expect(context.pageStartedEvents.length, 1);
        context.complete();
      },
    ]));
  });

  testWebView('The URL loaded by loadUrl', (tester, context) async {
    await tester.pumpWidget(
      WebView(
        key: GlobalKey(),
        initialUrl: "about:blank",
        onWebViewCreated: context.onWebViewCreated,
        shouldOverrideUrlLoading: (_, request) async {
          context.shouldOverrideUrlLoading(request);
          return ShouldOverrideUrlLoadingAction.allow;
        },
        onPageStarted: context.onPageStarted,
        onPageFinished: context.onPageFinished,
      ),
    );

    final controller = await context.webviewController.future;

    context.loadingRequests.stream.listen(onData([
      (event) {
        expect(event.url, "https://www.google.com/");
        expect(event.method, "GET");
        expect(event.isForMainFrame, true);
        expect(event.headers, {
          "User-Agent": isNotEmpty,
          "Accept": isNotEmpty,
        });
      },
    ]));

    context.pageStarted.stream.listen(onData([
      (event) {
        expect(event, "about:blank");
      },
      (event) {
        expect(event, "https://www.google.com/");
      },
    ]));

    context.pageFinished.stream.listen(onData([
      (event) {
        expect(event, "about:blank");
        controller.loadUrl("https://www.google.com/");
      },
      (event) {
        expect(event, "https://www.google.com/");
        expect(context.loadingRequestEvents.length, 1);
        expect(context.pageStartedEvents.length, 2);
        context.complete();
      },
    ]));
  });

  testWebView('Loading URLs with loadUrl in succession',
      (tester, context) async {
    await tester.pumpWidget(
      WebView(
        key: GlobalKey(),
        initialUrl: "about:blank",
        onWebViewCreated: context.onWebViewCreated,
        shouldOverrideUrlLoading: (_, request) async {
          context.shouldOverrideUrlLoading(request);
          return ShouldOverrideUrlLoadingAction.allow;
        },
        onPageStarted: context.onPageStarted,
        onPageFinished: context.onPageFinished,
      ),
    );

    final controller = await context.webviewController.future;

    context.loadingRequests.stream.listen(onData([
      (event) {
        expect(event.url, "https://www.google.com/");
        expect(event.method, "GET");
        expect(event.isForMainFrame, true);
        expect(event.headers, {
          "User-Agent": isNotEmpty,
          "Accept": isNotEmpty,
        });
      },
      (event) {
        expect(event.url, "https://www.google.com/");
        expect(event.method, "GET");
        expect(event.isForMainFrame, true);
        expect(event.headers, {
          "User-Agent": isNotEmpty,
          "Accept": isNotEmpty,
        });
      },
    ]));

    context.pageStarted.stream.listen(onData([
      (event) {
        expect(event, "about:blank");
      },
      (event) {
        expect(event, "https://www.google.com/");
      },
    ]));
    context.pageFinished.stream.listen(onData([
      (event) {
        expect(event, "about:blank");

        controller.loadUrl("https://www.google.com/");
        controller.loadUrl("https://www.google.com/");
      },
      (event) {
        expect(event, "https://www.google.com/");

        expect(context.loadingRequestEvents.length, 2);
        expect(context.pageStartedEvents.length, 2);

        context.complete();
      },
    ]));
  });

  testWebView('Use location.href to transition', (tester, context) async {
    await tester.pumpWidget(
      WebView(
        key: GlobalKey(),
        initialUrl: "about:blank",
        onWebViewCreated: context.onWebViewCreated,
        shouldOverrideUrlLoading: (_, request) async {
          context.shouldOverrideUrlLoading(request);
          return ShouldOverrideUrlLoadingAction.allow;
        },
        onPageStarted: context.onPageStarted,
        onPageFinished: context.onPageFinished,
      ),
    );

    final controller = await context.webviewController.future;

    context.loadingRequests.stream.listen(onData([
      (event) {
        expect(event.url, "https://www.google.com/");
        expect(event.method, "GET");
        expect(event.isForMainFrame, true);
        expect(event.headers, {
          "User-Agent": isNotEmpty,
          "Accept": isNotEmpty,
        });
      },
    ]));
    context.pageStarted.stream.listen(onData([
      (event) {
        expect(event, "about:blank");
      },
      (event) {
        expect(event, "https://www.google.com/");
      },
    ]));
    context.pageFinished.stream.listen(onData([
      (event) {
        expect(event, "about:blank");

        controller.evaluateJavascript(
          "location.href = 'https://www.google.com/'",
        );
      },
      (event) {
        expect(event, "https://www.google.com/");
        expect(context.loadingRequestEvents.length, 1);
        expect(context.pageStartedEvents.length, 2);
        context.complete();
      },
    ]));
  });

  testWebView('Use window.open()', (tester, context) async {
    await tester.pumpWidget(
      WebView(
        key: GlobalKey(),
        initialUrl: "about:blank",
        onWebViewCreated: context.onWebViewCreated,
        shouldOverrideUrlLoading: (_, request) async {
          context.shouldOverrideUrlLoading(request);
          return ShouldOverrideUrlLoadingAction.allow;
        },
        onPageStarted: context.onPageStarted,
        onPageFinished: context.onPageFinished,
      ),
    );

    final controller = await context.webviewController.future;

    context.loadingRequests.stream.listen(onData([
      (event) {
        expect(event.url, "https://www.google.com/");
        expect(event.method, "GET");
        expect(event.isForMainFrame, true);
        expect(event.headers, {
          "User-Agent": isNotEmpty,
          "Accept": isNotEmpty,
          'Referer': '',
        });
      },
    ]));
    context.pageStarted.stream.listen(onData([
      (event) {
        expect(event, "about:blank");
      },
      (event) {
        expect(event, "https://www.google.com/");
      },
    ]));
    context.pageFinished.stream.listen(onData([
      (event) {
        expect(event, "about:blank");
        controller.evaluateJavascript(
          "window.open('https://www.google.com/', '_blank');",
        );
      },
      (event) {
        expect(event, "https://www.google.com/");
        expect(context.loadingRequestEvents.length, 1);
        expect(context.pageStartedEvents.length, 2);

        context.complete();
      },
    ]));
  });
}
