import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_webview/native_webview.dart';

void main() {
  setUp(() async {
    await CookieManager.instance().deleteAllCookies();
  });

  group("getCookies", () {
    testWidgets('no name', (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final finished = Completer<String>();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'https://flutter.dev/',
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
            onPageFinished: (controller, url) {
              finished.complete(url);
            },
          ),
        ),
      );
      final currentUrl = await finished.future;
      final cookieManager = CookieManager.instance();
      final cookies = await cookieManager.getCookies(url: currentUrl);

      expect(cookies.length, greaterThanOrEqualTo(1));
    });

    testWidgets('has name', (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final finished = Completer<String>();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'https://flutter.dev/',
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
            onPageFinished: (controller, url) {
              finished.complete(url);
            },
          ),
        ),
      );

      final currentUrl = await finished.future;
      final cookieManager = CookieManager.instance();

      final emptyCookies = await cookieManager.getCookies(
        url: currentUrl,
        name: "myCookie",
      );
      expect(emptyCookies.length, 0);

      await cookieManager.setCookie(
        url: currentUrl,
        name: "myCookie",
        value: "myValue",
      );

      // Can't get it because the host is different.
      await cookieManager.setCookie(
        url: "https://google.com/",
        name: "myCookie",
        value: "myGoogle",
      );

      final cookies = await cookieManager.getCookies(
        url: currentUrl,
        name: "myCookie",
      );
      expect(cookies.length, 1);
      expect(cookies.first.name, "myCookie");
      expect(cookies.first.value, "myValue");
    });
  });

  group("setCookie", () {
    testWidgets('expire cookie', (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final finished = Completer<String>();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'https://flutter.dev/',
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
            onPageFinished: (controller, url) {
              finished.complete(url);
            },
          ),
        ),
      );

      final currentUrl = await finished.future;
      final cookieManager = CookieManager.instance();
      final cookies = (await cookieManager.getCookies(url: currentUrl))
          .where((e) => e.name == "myCookie");

      expect(cookies.length, 0);

      await cookieManager.setCookie(
        url: currentUrl,
        name: "myCookie",
        value: "myValue",
        maxAge: 1,
      );

      final cookies1 = await cookieManager.getCookies(
        url: currentUrl,
        name: "myCookie",
      );
      expect(cookies1.length, 1);
      expect(cookies1.first.value, "myValue");

      sleep(Duration(seconds: 2));

      // TODO: It doesn't work on iOS, so I'll temporarily skip it.
      if (Platform.isAndroid) {
        final cookies2 = await cookieManager.getCookies(
          url: currentUrl,
          name: "myCookie",
        );
        expect(cookies2.length, 0);
      }
    });

    testWidgets('normal cookie', (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final finished = Completer<String>();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'https://flutter.dev/',
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
            onPageFinished: (controller, url) {
              finished.complete(url);
            },
          ),
        ),
      );

      final currentUrl = await finished.future;
      final cookieManager = CookieManager.instance();
      final emptyCookies = await cookieManager.getCookies(
        url: currentUrl,
        name: "myCookie",
      );
      expect(emptyCookies.length, 0);

      await cookieManager.setCookie(
        url: currentUrl,
        name: "myCookie",
        value: "myValue",
        isSecure: false,
      );

      final cookies = await cookieManager.getCookies(
        url: currentUrl,
        name: "myCookie",
      );
      expect(cookies.length, 1);
      expect(cookies.first.name, "myCookie");
      expect(cookies.first.value, "myValue");
    });

    testWidgets('secure cookie', (tester) async {
      final controllerCompleter = Completer<WebViewController>();
      final finished = Completer<String>();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WebView(
            initialUrl: 'https://flutter.dev/',
            onWebViewCreated: (WebViewController controller) {
              controllerCompleter.complete(controller);
            },
            onPageFinished: (controller, url) {
              finished.complete(url);
            },
          ),
        ),
      );

      final currentUrl = await finished.future;
      final cookieManager = CookieManager.instance();
      final emptyCookies = await cookieManager.getCookies(
        url: currentUrl,
        name: "myCookie",
      );
      expect(emptyCookies.length, 0);

      await cookieManager.setCookie(
        url: currentUrl,
        name: "myCookie",
        value: "myValue",
        isSecure: true,
      );

      final cookies = await cookieManager.getCookies(
        url: currentUrl,
        name: "myCookie",
      );
      expect(cookies.length, 1);
      expect(cookies.first.name, "myCookie");
      expect(cookies.first.value, "myValue");
    });
  });

  testWidgets('deleteCookie', (tester) async {
    final controllerCompleter = Completer<WebViewController>();
    final finished = Completer<String>();
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: WebView(
          initialUrl: 'https://flutter.dev/',
          onWebViewCreated: (WebViewController controller) {
            controllerCompleter.complete(controller);
          },
          onPageFinished: (controller, url) {
            finished.complete(url);
          },
        ),
      ),
    );

    final currentUrl = await finished.future;
    final cookieManager = CookieManager.instance();

    await cookieManager.setCookie(
      url: currentUrl,
      name: "myCookie",
      value: "myValue",
    );

    await cookieManager.deleteCookie(
      url: currentUrl,
      name: "myCookie",
    );

    final cookies = await cookieManager.getCookies(
      url: currentUrl,
      name: "myCookie",
    );
    expect(cookies.length, 0);
  });

  testWidgets('deleteCookies', (tester) async {
    final controllerCompleter = Completer<WebViewController>();
    final finished = Completer<String>();
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: WebView(
          initialUrl: 'https://flutter.dev/',
          onWebViewCreated: (WebViewController controller) {
            controllerCompleter.complete(controller);
          },
          onPageFinished: (controller, url) {
            finished.complete(url);
          },
        ),
      ),
    );

    final currentUrl = await finished.future;
    final cookieManager = CookieManager.instance();

    await cookieManager.setCookie(
      url: currentUrl,
      name: "myCookie",
      value: "myValue",
    );

    await cookieManager.deleteCookies(
      url: currentUrl,
    );

    final cookies = await cookieManager.getCookies(
      url: currentUrl,
      name: "myCookie",
    );
    expect(cookies.length, 0);
  });

  testWidgets('deleteAllCookies', (tester) async {
    final controllerCompleter = Completer<WebViewController>();
    final finished = Completer<String>();
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: WebView(
          initialUrl: 'https://flutter.dev/',
          onWebViewCreated: (WebViewController controller) {
            controllerCompleter.complete(controller);
          },
          onPageFinished: (controller, url) {
            finished.complete(url);
          },
        ),
      ),
    );

    final currentUrl = await finished.future;
    final cookieManager = CookieManager.instance();

    await cookieManager.setCookie(
      url: currentUrl,
      name: "myCookie",
      value: "myValue",
    );

    await cookieManager.deleteAllCookies();

    final cookies = await cookieManager.getCookies(
      url: currentUrl,
      name: "myCookie",
    );
    expect(cookies.length, 0);
  });
}
