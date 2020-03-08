import 'package:e2e/e2e.dart';

import 'tests/evaluate_javascript_test.dart';
import 'tests/initial_webview_test.dart';
import 'tests/javascript_callback_test.dart';
import 'tests/message_handler_test.dart';
import 'tests/navigation_test.dart';

void main() {
  E2EWidgetsFlutterBinding.ensureInitialized();

  evaluateJavascriptTest();
  initialWebViewTest();
  javascriptCallbackTest();
  messageHandlerTest();
  navigationTest();
}
