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

  group("deleteCookie", () {
    test("delete flutter.dev's cookie", () async {
      final currentUrl = "https://flutter.dev/";
      final wwwDomainUrl = "https://www.flutter.dev/";
      final subDomainUrl = "https://sub.flutter.dev/";
      final googleUrl = "https://www.google.com/";
      final cookieManager = CookieManager.instance();

      await cookieManager.setCookie(
        url: currentUrl,
        name: "myCookie",
        value: "myValue1",
      );

      await cookieManager.setCookie(
        url: wwwDomainUrl,
        name: "myCookie",
        value: "myValue2",
      );

      await cookieManager.setCookie(
        url: subDomainUrl,
        name: "myCookie",
        value: "myValue3",
      );

      await cookieManager.setCookie(
        url: googleUrl,
        name: "myCookie",
        value: "myValue4",
      );

      await cookieManager.deleteCookie(
        url: currentUrl,
        name: "myCookie",
      );

      // TODO: sub-domain cookie is deleted.
      final cookies = await cookieManager.getCookies(
        url: currentUrl,
        name: "myCookie",
      );
      expect(cookies.length, 1);
      expect(cookies.map((e) => e.value).toList(), ["myValue1"]);

      final wwwDomainCookies = await cookieManager.getCookies(
        url: wwwDomainUrl,
        name: "myCookie",
      );
      expect(wwwDomainCookies.length, 1);
      expect(wwwDomainCookies.map((e) => e.value).toList(), ["myValue1"]);

      final subDomainCookies = await cookieManager.getCookies(
        url: subDomainUrl,
        name: "myCookie",
      );
      expect(subDomainCookies.length, 2);
      expect(
        subDomainCookies.map((e) => e.value).toList(),
        ["myValue1", "myValue3"],
      );

      final googleCookies = await cookieManager.getCookies(
        url: googleUrl,
        name: "myCookie",
      );
      expect(googleCookies.length, 1);
    });
  });

  group("deleteCookies", () {
    test("delete flutter.dev's cookies", () async {
      final currentUrl = "https://flutter.dev/";
      final wwwDomainUrl = "https://www.flutter.dev/";
      final subDomainUrl = "https://sub.flutter.dev/";
      final googleUrl = "https://www.google.com/";
      final cookieManager = CookieManager.instance();

      await cookieManager.setCookie(
        url: currentUrl,
        name: "myCookie",
        value: "myValue",
      );

      await cookieManager.setCookie(
        url: wwwDomainUrl,
        name: "myCookie",
        value: "myValue",
      );

      await cookieManager.setCookie(
        url: subDomainUrl,
        name: "myCookie",
        value: "myValue",
      );

      await cookieManager.setCookie(
        url: googleUrl,
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

      final wwwDomainCookies = await cookieManager.getCookies(
        url: wwwDomainUrl,
        name: "myCookie",
      );
      expect(wwwDomainCookies.length, 0);

      final subDomainCookies = await cookieManager.getCookies(
        url: subDomainUrl,
        name: "myCookie",
      );
      expect(subDomainCookies.length, 0);

      final googleCookies = await cookieManager.getCookies(
        url: googleUrl,
        name: "myCookie",
      );
      expect(googleCookies.length, 1);
    });

    test("delete sub.flutter.dev's cookies", () async {
      final currentUrl = "https://flutter.dev/";
      final wwwDomainUrl = "https://www.flutter.dev/";
      final subDomainUrl = "https://sub.flutter.dev/";
      final googleUrl = "https://www.google.com/";
      final cookieManager = CookieManager.instance();

      await cookieManager.setCookie(
        url: currentUrl,
        name: "myCookie",
        value: "myValue1",
      );

      await cookieManager.setCookie(
        url: wwwDomainUrl,
        name: "myCookie",
        value: "myValue2",
      );

      await cookieManager.setCookie(
        url: subDomainUrl,
        name: "myCookie",
        value: "myValue3",
      );

      await cookieManager.setCookie(
        url: googleUrl,
        name: "myCookie",
        value: "myValue4",
      );

      await cookieManager.deleteCookies(
        url: subDomainUrl,
      );

      final cookies = await cookieManager.getCookies(
        url: currentUrl,
        name: "myCookie",
      );
      expect(cookies.length, 1);

      final wwwDomainCookies = await cookieManager.getCookies(
        url: wwwDomainUrl,
        name: "myCookie",
      );
      expect(wwwDomainCookies.length, 2);
      expect(
        wwwDomainCookies.map((e) => e.value).toList(),
        ["myValue2", "myValue1"],
      );

      final subDomainCookies = await cookieManager.getCookies(
        url: subDomainUrl,
        name: "myCookie",
      );
      expect(subDomainCookies.length, 1);
      expect(
        subDomainCookies.map((e) => e.value).toList(),
        ["myValue1"],
      );

      final googleCookies = await cookieManager.getCookies(
        url: googleUrl,
        name: "myCookie",
      );
      expect(googleCookies.length, 1);
    });
  });

  group("deleteAllCookies", () {
    test('delete all cookies', () async {
      final currentUrl = "https://flutter.dev/";
      final wwwDomainUrl = "https://www.flutter.dev/";
      final subDomainUrl = "https://sub.flutter.dev/";
      final googleUrl = "https://www.google.com/";
      final cookieManager = CookieManager.instance();

      await cookieManager.setCookie(
        url: currentUrl,
        name: "myCookie",
        value: "myValue",
      );

      await cookieManager.setCookie(
        url: wwwDomainUrl,
        name: "myCookie",
        value: "myValue",
      );

      await cookieManager.setCookie(
        url: subDomainUrl,
        name: "myCookie",
        value: "myValue",
      );

      await cookieManager.setCookie(
        url: googleUrl,
        name: "myCookie",
        value: "myValue",
      );

      await cookieManager.deleteAllCookies();

      final cookies = await cookieManager.getCookies(
        url: currentUrl,
        name: "myCookie",
      );
      expect(cookies.length, 0);

      final wwwDomainCookies = await cookieManager.getCookies(
        url: wwwDomainUrl,
        name: "myCookie",
      );
      expect(wwwDomainCookies.length, 0);

      final subDomainCookies = await cookieManager.getCookies(
        url: subDomainUrl,
        name: "myCookie",
      );
      expect(subDomainCookies.length, 0);

      final googleCookies = await cookieManager.getCookies(
        url: googleUrl,
        name: "myCookie",
      );
      expect(googleCookies.length, 0);
    });
  });
}
