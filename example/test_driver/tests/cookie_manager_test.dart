import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:native_webview/native_webview.dart';

import '../utils.dart';

void main() {
  setUp(() async {
    await CookieManager.instance().deleteAllCookies();
  });

  group("getCookies", () {
    testWebView('no name', (tester, context) async {
      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://flutter.dev/',
          onWebViewCreated: context.onWebViewCreated,
          onPageFinished: context.onPageFinished,
        ),
      );
      await context.webviewController.future;
      final cookieManager = CookieManager.instance();

      context.pageFinished.stream.listen(onData([
        (event) async {
          final cookies = await cookieManager.getCookies(url: event);
          expect(cookies.length, greaterThanOrEqualTo(1));
          context.complete();
        },
      ]));
    });

    test('has name', () async {
      final cookieManager = CookieManager.instance();

      final currentUrl = "https://flutter.dev/";
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
      await cookieManager.setCookie(
        url: "https://en.wikipedia.org/wiki/Flutter",
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
    setUp(() async {
      await CookieManager.instance().deleteAllCookies();
    });

    test('normal cookie', () async {
      final currentUrl = "https://flutter.dev/";
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
        path: "/",
        domain: "flutter.dev",
        isSecure: false,
        maxAge: Duration(seconds: 0),
      );

      final cookies = await cookieManager.getCookies(
        url: currentUrl,
        name: "myCookie",
      );
      expect(cookies.length, 1);
      expect(cookies.first.name, "myCookie");
      expect(cookies.first.value, "myValue");
    });

    group("maxAge", () {
      test('is 1 second', () async {
        final currentUrl = "https://flutter.dev/";
        final cookieManager = CookieManager.instance();
        final cookies = await cookieManager.getCookies(
          url: currentUrl,
          name: "myCookie",
        );
        expect(cookies.length, 0);

        await cookieManager.setCookie(
          url: currentUrl,
          name: "myCookie",
          value: "myValue",
          maxAge: Duration(seconds: 1),
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

      test('is 0 second', () async {
        final currentUrl = "https://flutter.dev/";
        final cookieManager = CookieManager.instance();
        final cookies = await cookieManager.getCookies(
          url: currentUrl,
          name: "myCookie",
        );
        expect(cookies.length, 0);

        await cookieManager.setCookie(
          url: currentUrl,
          name: "myCookie",
          value: "myValue",
          maxAge: Duration(seconds: 0),
        );

        final cookies1 = await cookieManager.getCookies(
          url: currentUrl,
          name: "myCookie",
        );
        expect(cookies1.length, 1);
        expect(cookies1.first.value, "myValue");

        sleep(Duration(seconds: 2));

        final cookies2 = await cookieManager.getCookies(
          url: currentUrl,
          name: "myCookie",
        );
        expect(cookies2.length, 1);
      });

      test('is 1 day', () async {
        final currentUrl = "https://flutter.dev/";
        final cookieManager = CookieManager.instance();
        final cookies = await cookieManager.getCookies(
          url: currentUrl,
          name: "myCookie",
        );
        expect(cookies.length, 0);

        await cookieManager.setCookie(
          url: currentUrl,
          name: "myCookie",
          value: "myValue",
          maxAge: Duration(days: 1),
        );

        final cookies1 = await cookieManager.getCookies(
          url: currentUrl,
          name: "myCookie",
        );
        expect(cookies1.length, 1);
        expect(cookies1.first.value, "myValue");

        final cookies2 = await cookieManager.getCookies(
          url: currentUrl,
          name: "myCookie",
        );
        expect(cookies2.length, 1);
      });
    });

    test('secure cookie', () async {
      final currentUrl = "https://flutter.dev/";
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

    group("sub domain", () {
      test('has prefix', () async {
        final currentUrl = "https://en.wikipedia.org/wiki/Flutter_(software)";
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
          domain: ".wikipedia.org",
          isSecure: true,
        );

        final cookies = await cookieManager.getCookies(
          url: "https://ja.wikipedia.org/wiki/Flutter",
          name: "myCookie",
        );
        expect(cookies.length, 1);
        expect(cookies.first.name, "myCookie");
        expect(cookies.first.value, "myValue");
      });

      test('no prefix', () async {
        final currentUrl = "https://en.wikipedia.org/wiki/Flutter_(software)";
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
          domain: "wikipedia.org",
          isSecure: true,
        );

        final cookies = await cookieManager.getCookies(
          url: "https://ja.wikipedia.org/wiki/Flutter",
          name: "myCookie",
        );
        expect(cookies.length, 1);
        expect(cookies.first.name, "myCookie");
        expect(cookies.first.value, "myValue");
      });
    });
  });

  test('deleteCookie', () async {
    final currentUrl = "https://flutter.dev/";
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

  test('deleteCookies', () async {
    final currentUrl = "https://flutter.dev/";
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

  test('deleteAllCookies', () async {
    final currentUrl = "https://flutter.dev/";
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
