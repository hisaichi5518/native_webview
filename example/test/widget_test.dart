import 'package:flutter_test/flutter_test.dart';
import 'package:native_webview_example/main.dart';

void main() {
  testWidgets('Verify Platform version', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
  });
}
