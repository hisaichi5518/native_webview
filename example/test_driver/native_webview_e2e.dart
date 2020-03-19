import 'package:e2e/e2e.dart';

import 'tests/webViewControllerTests.dart';
import 'tests/webViewTests.dart';

void main() {
  E2EWidgetsFlutterBinding.ensureInitialized();

  webViewTests();
  webViewControllerTests();
}
