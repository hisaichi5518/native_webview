import 'package:flutter_test/flutter_test.dart';
import 'package:native_webview/src/web_resource_error.dart';

void main() {
  group("WebResourceError", () {
    test("toString()", () async {
      final error = WebResourceError(
        errorCode: 1000,
        description: "description",
        domain: "ios domain",
        errorType: WebResourceErrorType.badUrl,
      );

      expect(error.toString(), "WebResourceError(1000, description, ios domain, WebResourceErrorType.badUrl)");
    });
  });
}
