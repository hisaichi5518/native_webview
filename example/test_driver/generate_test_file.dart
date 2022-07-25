import 'dart:io';

Future<void> main() async {
  final dir = Directory('integration_test/tests');
  final files = <FileSystemEntity>[];
  await for (final file in dir.list(recursive: true)) {
    files.add(file);
  }

  files.sort((a, b) => a.path.compareTo(b.path));

  final imports = files.map((file) {
    final basename = file.path.split("/").last;
    final name = basename.replaceAll(".dart", "");
    return """
import "tests/$basename" as $name;
""";
  }).join("");

  final tests = files.map((file) {
    final name = file.path.split("/").last.replaceAll(".dart", "");
    return """
  group(
    "$name",
    $name.main,
  );
""";
  }).join("");

  final body = """
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

$imports

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
$tests
}
""";

  final testFile = File("integration_test/webview_test.dart");
  await testFile.writeAsString(body);
}
