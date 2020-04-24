import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_webview/native_webview.dart';

void main() {
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

  group("onJsConfirm", () {
    testWidgets("handled", (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final finishedCompleter = Completer<String>();

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

  group("onPageStarted", () {
    testWidgets('wait for page started', (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final finishedCompleter = Completer<String>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'https://flutter.dev/',
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
            onPageStarted: (controller, url) {
              finishedCompleter.complete(url);
            },
          ),
        ),
      );

      final url = await finishedCompleter.future;
      expect(url, "https://flutter.dev/");
    });
  });

  group("onPageFinished", () {
    testWidgets('wait for page finished', (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final finishedCompleter = Completer<String>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'https://flutter.dev/',
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
            onPageFinished: (controller, url) {
              finishedCompleter.complete(url);
            },
          ),
        ),
      );

      final url = await finishedCompleter.future;
      expect(url, "https://flutter.dev/");
    });
  });

  group("onProgressChanged", () {
    testWidgets('wait for page finished', (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final finishedCompleter = Completer<String>();

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
              finishedCompleter.complete(url);
            },
          ),
        ),
      );

      final url = await finishedCompleter.future;
      expect(url, "https://flutter.dev/");
      expect(progressValues.last, 100);
    });
  });

  group("shouldOverrideUrlLoading", () {
    testWidgets('cancel iOS', (tester) async {
      if (!Platform.isIOS) {
        return;
      }
      final controllerCompleter = Completer<WebViewController>();
      final started = StreamController<String>();
      final finished = StreamController<String>();
      final List<ShouldOverrideUrlLoadingRequest> shouldOverrideUrlLoading = [];
      final completer = Completer<String>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'about:blank',
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
            onPageStarted: (controller, url) {
              print("onPageStarted: ${url}");
              started.add(url);
            },
            onPageFinished: (controller, url) async {
              print("onPageFinished: ${url}");
              finished.add(url);
              switch (url) {
                case "about:blank":
                  await controller.loadUrl("https://flutter.dev/");
                  break;
                case "https://flutter.dev/":
                  fail("not allow");
                  break;
              }
            },
            shouldOverrideUrlLoading: (controller, request) async {
              print("shouldOverrideUrlLoading: ${request.url}");
              shouldOverrideUrlLoading.add(request);
              completer.complete(request.url);
              return ShouldOverrideUrlLoadingAction.cancel;
            },
          ),
        ),
      );

      await completer.future;

      expect(shouldOverrideUrlLoading.map((v) => v.url).toList(), [
        "https://flutter.dev/",
      ]);

      expect(shouldOverrideUrlLoading.map((v) => v.method).toList(), [
        "GET",
      ]);

      expect(shouldOverrideUrlLoading.map((v) => v.isForMainFrame).toList(), [
        true,
      ]);

      if (Platform.isIOS) {
        expect(shouldOverrideUrlLoading.map((v) => v.headers).toList(), [
          {
            "Accept": isNotNull,
            "User-Agent": isNotNull,
          },
        ]);
      } else {
        expect(shouldOverrideUrlLoading.map((v) => v.headers).toList(), [
          null,
        ]);
      }
    });

    testWidgets('allow iOS', (tester) async {
      if (!Platform.isIOS) {
        return;
      }
      final controllerCompleter = Completer<WebViewController>();
      final started = StreamController<String>();
      final finished = StreamController<String>();
      final List<ShouldOverrideUrlLoadingRequest> shouldOverrideUrlLoading = [];
      final completer = Completer<String>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'about:blank',
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
            onPageStarted: (controller, url) {
              print("onPageStarted: ${url}");
              started.add(url);
            },
            onPageFinished: (controller, url) async {
              print("onPageFinished: ${url}");
              finished.add(url);
              switch (url) {
                case "about:blank":
                  await controller.loadUrl("https://flutter.dev/");
                  break;
                case "https://flutter.dev/":
                  completer.complete(url);
                  await finished.close();
                  break;
              }
            },
            shouldOverrideUrlLoading: (controller, request) async {
              print("shouldOverrideUrlLoading: ${request.url}");
              shouldOverrideUrlLoading.add(request);
              return ShouldOverrideUrlLoadingAction.allow;
            },
          ),
        ),
      );

      expect(
          started.stream,
          emitsInOrder([
            "about:blank",
            "https://flutter.dev/",
          ]));

      expect(
          finished.stream,
          emitsInOrder([
            "about:blank",
            "https://flutter.dev/",
          ]));

      await completer.future;

      expect(shouldOverrideUrlLoading.map((v) => v.url).toList(), [
        "https://flutter.dev/",
        "https://www.youtube.com/embed/W1pNjxmNHNQ",
        "https://www.youtube.com/embed/fq4N0hgOWzU?cc_lang_pref=en&cc_load_policy=1&enablejsapi=1",
      ]);

      expect(shouldOverrideUrlLoading.map((v) => v.method).toList(), [
        "GET",
        "GET",
        "GET",
      ]);

      expect(shouldOverrideUrlLoading.map((v) => v.isForMainFrame).toList(), [
        true,
        false,
        false,
      ]);

      expect(shouldOverrideUrlLoading.map((v) => v.headers).toList(), [
        {
          "Accept": isNotNull,
          "User-Agent": isNotNull,
        },
        {
          'Referer': 'https://flutter.dev/',
          "Accept": isNotNull,
          "User-Agent": isNotNull,
        },
        {
          'Referer': 'https://flutter.dev/',
          "Accept": isNotNull,
          "User-Agent": isNotNull,
        },
      ]);
    });

    testWidgets('cancel Android', (tester) async {
      if (!Platform.isAndroid) {
        return;
      }
      final controllerCompleter = Completer<WebViewController>();
      final started = StreamController<String>();
      final finished = StreamController<String>();
      final List<ShouldOverrideUrlLoadingRequest> shouldOverrideUrlLoading = [];
      final completer = Completer<String>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'about:blank',
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
            onPageStarted: (controller, url) {
              print("onPageStarted: ${url}");
              started.add(url);
            },
            onPageFinished: (controller, url) async {
              print("onPageFinished: ${url}");
              finished.add(url);
              switch (url) {
                case "about:blank":
                  await controller.loadUrl("https://google.com");
                  break;
              }
            },
            shouldOverrideUrlLoading: (controller, request) async {
              print("shouldOverrideUrlLoading: ${request.url}");
              shouldOverrideUrlLoading.add(request);
              completer.complete(request.url);
              return ShouldOverrideUrlLoadingAction.cancel;
            },
          ),
        ),
      );

      expect(
          started.stream,
          emitsInOrder([
            "https://google.com/",
          ]));

      expect(
          finished.stream,
          emitsInOrder([
            "about:blank",
            "https://www.google.com/",
          ]));
      await completer.future;

      expect(shouldOverrideUrlLoading.map((v) => v.url).toList(), [
        "https://www.google.com/",
      ]);

      expect(shouldOverrideUrlLoading.map((v) => v.method).toList(), [
        "GET",
      ]);

      expect(shouldOverrideUrlLoading.map((v) => v.isForMainFrame).toList(), [
        true,
      ]);

      if (Platform.isIOS) {
        expect(shouldOverrideUrlLoading.map((v) => v.headers).toList(), [
          {
            "Accept": isNotNull,
            "User-Agent": isNotNull,
          },
        ]);
      } else {
        expect(shouldOverrideUrlLoading.map((v) => v.headers).toList(), [
          null,
        ]);
      }
    });

    testWidgets('allow Android', (tester) async {
      if (!Platform.isAndroid) {
        return;
      }
      final controllerCompleter = Completer<WebViewController>();
      final started = StreamController<String>();
      final finished = StreamController<String>();
      final List<ShouldOverrideUrlLoadingRequest> shouldOverrideUrlLoading = [];
      final completer = Completer<String>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'about:blank',
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
            onPageStarted: (controller, url) {
              print("onPageStarted: ${url}");
              started.add(url);
            },
            onPageFinished: (controller, url) async {
              print("onPageFinished: ${url}");
              finished.add(url);
              switch (url) {
                case "about:blank":
                  await controller.loadUrl("https://google.com");
                  break;
                case "https://www.google.com/":
                  completer.complete(url);
                  await finished.close();
                  break;
              }
            },
            shouldOverrideUrlLoading: (controller, request) async {
              print("shouldOverrideUrlLoading: ${request.url}");
              shouldOverrideUrlLoading.add(request);
              return ShouldOverrideUrlLoadingAction.allow;
            },
          ),
        ),
      );

      expect(
          started.stream,
          emitsInOrder([
            "https://google.com/",
          ]));

      expect(
          finished.stream,
          emitsInOrder([
            "about:blank",
            "https://www.google.com/",
          ]));

      await completer.future;

      expect(shouldOverrideUrlLoading.map((v) => v.url).toList(), [
        "https://www.google.com/",
      ]);

      expect(shouldOverrideUrlLoading.map((v) => v.method).toList(), [
        "GET",
      ]);

      expect(shouldOverrideUrlLoading.map((v) => v.isForMainFrame).toList(), [
        true,
      ]);

      expect(shouldOverrideUrlLoading.map((v) => v.headers).toList(), [
        null,
      ]);
    });
  });
}
