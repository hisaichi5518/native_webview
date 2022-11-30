import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:native_webview/native_webview.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("androidWebViewInfo", () {
    test("on Android", () async {
      final info = (await WebViewManager.instance().androidWebViewInfo)!;
      expect(info.versionName, isNotEmpty);
      expect(info.packageName, isNotEmpty);
    }, skip: !Platform.isAndroid);

    test("on iOS", () async {
      final info = await WebViewManager.instance().androidWebViewInfo;
      expect(info, null);
    }, skip: !Platform.isIOS);
  });
}
