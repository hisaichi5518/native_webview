import 'package:flutter_test/flutter_test.dart';
import 'package:native_webview/src/stringify.dart';

void main() {
  test("mapPropsToString", () async {
    final error = mapPropsToString("".runtimeType, ["test1", "test2", "test3"]);
    expect(error.toString(), "String(test1, test2, test3)");
  });
}
