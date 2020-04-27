.PHONY: all test clean


generate_test_file:
	cd example; dart ./test_driver/generate_test_file.dart

test:
	cd example; flutter drive test_driver/native_webview_e2e.dart
