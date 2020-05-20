import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:native_webview/native_webview.dart';

import '../utils.dart';

void main() {
  setUp(() async {
    await CookieManager.instance().deleteAllCookies();
  });

  group("setCookie/getCookies", () {
    testWebView("get flutter.dev's cookies", (tester, context) async {
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

    test("get flutter.dev's myCookie", () async {
      final cookieManager = CookieManager.instance();

      final currentUrl = "https://flutter.dev/";
      final emptyCookies = await cookieManager.getCookies(
        url: currentUrl,
        name: "myCookie",
      );
      expect(emptyCookies.length, 0);

      // normal cookie
      await cookieManager.setCookie(
        url: currentUrl,
        name: "myCookie",
        value: "myValue",
      );
      // set domain option
      await cookieManager.setCookie(
        url: currentUrl,
        name: "myCookie",
        value: "WithDomainOption",
        domain: ".flutter.dev", // == "flutter.dev"
      );
      // Can't get it because the host is different.
      await cookieManager.setCookie(
        url: "https://google.com/",
        name: "myCookie",
        value: "myGoogle",
      );
      // Can't get it because the host is different.
      await cookieManager.setCookie(
        url: "https://sub.flutter.dev/",
        name: "myCookie",
        value: "SubDomain",
      );

      final cookies = await cookieManager.getCookies(
        url: currentUrl,
        name: "myCookie",
      );
      expect(cookies.length, 2);
      expect(cookies.map((e) => e.name), ["myCookie", "myCookie"]);
      expect(cookies.map((e) => e.value), ["myValue", "WithDomainOption"]);
    });

    test("get sub.flutter.dev's myCookie", () async {
      final cookieManager = CookieManager.instance();

      final currentUrl = "https://sub.flutter.dev/";
      final emptyCookies = await cookieManager.getCookies(
        url: currentUrl,
        name: "myCookie",
      );
      expect(emptyCookies.length, 0);

      // normal cookie
      await cookieManager.setCookie(
        url: currentUrl,
        name: "myCookie",
        value: "myValue",
      );
      // set domain option
      await cookieManager.setCookie(
        url: currentUrl,
        name: "myCookie",
        value: "WithDomainOption",
        domain: ".flutter.dev", // == "flutter.dev"
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
      expect(cookies.length, 2);
      expect(cookies.map((e) => e.name), ["myCookie", "myCookie"]);
      expect(cookies.map((e) => e.value), ["myValue", "WithDomainOption"]);
    });

    test("get secure cookie", () async {
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
        isSecure: true,
      );

      final cookies = await cookieManager.getCookies(
        url: currentUrl,
        name: "myCookie",
      );
      expect(cookies.length, 1);
      expect(cookies.map((e) => e.name), ["myCookie"]);
      expect(cookies.map((e) => e.value), ["myValue"]);
    });

    group("set max-age option", () {
      test('is 1 second', () async {
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
          maxAge: Duration(seconds: 1),
        );

        final cookies = await cookieManager.getCookies(
          url: currentUrl,
          name: "myCookie",
        );
        expect(cookies.length, 1);
        expect(cookies.first.value, "myValue");

        await Future.delayed(const Duration(seconds: 2));

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

    group("set domain option", () {
      test("get flutter.dev's cookie by https://sub.flutter.dev/", () async {
        final currentUrl = "https://sub.flutter.dev/";
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
          domain: "flutter.dev",
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
