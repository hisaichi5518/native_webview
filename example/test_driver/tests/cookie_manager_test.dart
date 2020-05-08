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
      final controller = await context.webviewController.future;
      final currentUrl = await controller.currentUrl();
      final cookieManager = CookieManager.instance();

      context.pageFinished.stream.listen(onData([
        (event) async {
          final cookies = await cookieManager.getCookies(url: currentUrl);
          expect(cookies.length, greaterThanOrEqualTo(1));
          context.complete();
        },
      ]));
    });

    testWebView('has name', (tester, context) async {
      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://flutter.dev/',
          onWebViewCreated: context.onWebViewCreated,
        ),
      );

      final controller = await context.webviewController.future;
      final currentUrl = await controller.currentUrl();
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
      context.complete();
    });
  });

  group("setCookie", () {
    testWebView('expire cookie', (tester, context) async {
      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://flutter.dev/',
          onWebViewCreated: context.onWebViewCreated,
        ),
      );
      final controller = await context.webviewController.future;
      final currentUrl = await controller.currentUrl();
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

      final cookies2 = await cookieManager.getCookies(
        url: currentUrl,
        name: "myCookie",
      );
      expect(cookies2.length, 0);

      context.complete();
    });

    testWebView('normal cookie', (tester, context) async {
      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://flutter.dev/',
          onWebViewCreated: context.onWebViewCreated,
        ),
      );

      final controller = await context.webviewController.future;
      final currentUrl = await controller.currentUrl();
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

      context.complete();
    });

    testWebView('secure cookie', (tester, context) async {
      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://flutter.dev/',
          onWebViewCreated: context.onWebViewCreated,
        ),
      );

      final controller = await context.webviewController.future;
      final currentUrl = await controller.currentUrl();
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
      context.complete();
    });

    testWebView('specify domain', (tester, context) async {
      await tester.pumpWidget(
        WebView(
          initialUrl: 'https://en.wikipedia.org/wiki/Flutter_(software)',
          onWebViewCreated: context.onWebViewCreated,
        ),
      );

      final controller = await context.webviewController.future;
      var currentUrl = await controller.currentUrl();
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

      await controller.loadUrl("https://ja.wikipedia.org/wiki/Flutter");
      currentUrl = await controller.currentUrl();

      final cookies = await cookieManager.getCookies(
        url: currentUrl,
        name: "myCookie",
      );
      expect(cookies.length, 1);
      expect(cookies.first.name, "myCookie");
      expect(cookies.first.value, "myValue");
      context.complete();
    });
  });

  testWebView('deleteCookie', (tester, context) async {
    await tester.pumpWidget(
      WebView(
        initialUrl: 'https://flutter.dev/',
        onWebViewCreated: context.onWebViewCreated,
      ),
    );
    final controller = await context.webviewController.future;
    final currentUrl = await controller.currentUrl();
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
    context.complete();
  });

  testWebView('deleteCookies', (tester, context) async {
    await tester.pumpWidget(
      WebView(
        initialUrl: 'https://flutter.dev/',
        onWebViewCreated: context.onWebViewCreated,
      ),
    );

    final controller = await context.webviewController.future;
    final currentUrl = await controller.currentUrl();
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

    context.complete();
  });

  testWebView('deleteAllCookies', (tester, context) async {
    await tester.pumpWidget(
      WebView(
        initialUrl: 'https://flutter.dev/',
        onWebViewCreated: context.onWebViewCreated,
      ),
    );

    final controller = await context.webviewController.future;
    final currentUrl = await controller.currentUrl();
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
    context.complete();
  });
}
