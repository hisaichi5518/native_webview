import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import "tests/content_blocker_test.dart" as content_blocker_test;
import "tests/cookie_manager_test.dart" as cookie_manager_test;
import "tests/webview_controller_test.dart" as webview_controller_test;
import "tests/webview_manager_test.dart" as webview_manager_test;
import "tests/webview_page_callback_test.dart" as webview_page_callback_test;
import "tests/webview_should_override_url_loading_test.dart" as webview_should_override_url_loading_test;
import "tests/webview_test.dart" as webview_test;


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group(
    "content_blocker_test",
    content_blocker_test.main,
  );
  group(
    "cookie_manager_test",
    cookie_manager_test.main,
  );
  group(
    "webview_controller_test",
    webview_controller_test.main,
  );
  group(
    "webview_manager_test",
    webview_manager_test.main,
  );
  group(
    "webview_page_callback_test",
    webview_page_callback_test.main,
  );
  group(
    "webview_should_override_url_loading_test",
    webview_should_override_url_loading_test.main,
  );
  group(
    "webview_test",
    webview_test.main,
  );

}
