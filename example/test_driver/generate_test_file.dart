import 'dart:io';

Future<void> main() async {
  final dir = Directory('test_driver/tests');
  final List<File> files = [];
  await for (final file in dir.list(recursive: true)) {
    files.add(file);
  }

  final imports = files.map((file) {
    final basename = file.path?.split("/")?.last;
    final name = basename?.replaceAll(".dart", "");
    return """
import "tests/${basename}" as ${name};
""";
  }).join("");

  final tests = files.map((file) {
    final name = file.path?.split("/")?.last?.replaceAll(".dart", "");
    return """
  group("${name}", ${name}.main);
""";
  }).join("");

  final body = """
import 'package:e2e/e2e.dart';
import 'package:flutter_test/flutter_test.dart';

${imports}

void main() {
  E2EWidgetsFlutterBinding.ensureInitialized();
${tests}
}
""";

  final testFile = File("test_driver/native_webview_e2e.dart");
  await testFile.writeAsString(body);
}
