import 'package:e2e/e2e.dart';
import 'package:flutter_test/flutter_test.dart';

import 'tests/cookieManagerTests.dart';
import 'tests/webViewControllerTests.dart';
import 'tests/webViewTests.dart';

void main() {
  E2EWidgetsFlutterBinding.ensureInitialized();

  group("WebView", webViewTests);
  group("WebViewController", webViewControllerTests);
  group("CookieManager", cookieManagerTests);
}
