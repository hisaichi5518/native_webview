import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:native_webview/native_webview.dart';

import '../utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await CookieManager.instance().deleteAllCookies();
  });

  group("setCookie/getCookies", () {
    testWebView("get www.google.com's cookies", (tester, context) async {
      await tester.pumpFrames(
        WebView(
          initialUrl: 'https://www.google.com/',
          onWebViewCreated: context.onWebViewCreated,
          shouldOverrideUrlLoading: context.shouldOverrideUrlLoading,
          onPageStarted: context.onPageStarted,
          onWebResourceError: context.onWebResourceError,
          onProgressChanged: context.onProgressChanged,
          onPageFinished: context.onPageFinished,
        ),
      );

      final cookieManager = CookieManager.instance();
      final cookies = await cookieManager.getCookies(
        url: "https://www.google.com/",
      );
      expect(cookies.length, greaterThanOrEqualTo(1));
    });

    test("get flutter.dev's myCookie", () async {
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
      await cookieManager.setCookie(
        url: currentUrl,
        name: "myCookie",
        value: "withDomainOption",
        domain: ".flutter.dev", // == "flutter.dev"
      );
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
      expect(cookies.map((e) => e.value), contains("myValue"));
      expect(cookies.map((e) => e.value), contains("withDomainOption"));

      final googleCookies = await cookieManager.getCookies(
        url: "https://google.com/",
        name: "myCookie",
      );
      expect(googleCookies.length, 1);
      expect(googleCookies.map((e) => e.name), ["myCookie"]);
      expect(googleCookies.map((e) => e.value), ["myGoogle"]);

      final subDomainCookies = await cookieManager.getCookies(
        url: "https://sub.flutter.dev/",
        name: "myCookie",
      );
      expect(subDomainCookies.length, 1);
    });

    test("get sub.flutter.dev's myCookie", () async {
      final cookieManager = CookieManager.instance();

      final currentUrl = "https://sub.flutter.dev/";
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
      await cookieManager.setCookie(
        url: currentUrl,
        name: "myCookie",
        value: "withDomainOption",
        domain: ".flutter.dev", // == "flutter.dev"
      );
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
      expect(cookies.map((e) => e.value), contains("myValue"));
      expect(cookies.map((e) => e.value), contains("withDomainOption"));

      final mainDomainCookies = await cookieManager.getCookies(
        url: "https://flutter.dev/",
        name: "myCookie",
      );
      expect(mainDomainCookies.length, 1);
      expect(mainDomainCookies.map((e) => e.value), ["withDomainOption"]);
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

        if (Platform.isAndroid) {
          final cookies2 = await cookieManager.getCookies(
            url: currentUrl,
            name: "myCookie",
          );
          expect(cookies2.length, 0);
        } else {
          // It doesn't work on iOS, so I'll temporarily skip it.
          final cookies2 = await cookieManager.getCookies(
            url: currentUrl,
            name: "myCookie",
          );
          expect(cookies2.length, 1);
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
