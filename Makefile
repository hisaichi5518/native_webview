.PHONY: all test clean

test:
	cd example; flutter drive test_driver/native_webview_e2e.dart
