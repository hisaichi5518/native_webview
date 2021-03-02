# native_webview [![Pub Version](https://img.shields.io/pub/v/native_webview)](https://pub.dev/packages/native_webview)

A Flutter plugin that allows you to add an inline WebView.

## Motivation

There is already a useful library for working with WebViews in Flutter.

These libraries come with trade-offs such as simple implementation but lack features, or very advanced features and complex implementation.

native_webview is designed to provide users with a standard set of WebView features provided by iOS and Android while keeping the implementation simple.

## Requirements

- Dart: >=2.10.0 <3.0.0
- Flutter: >=1.22.0 <2.0.0
- Android: minSdkVersion 24, AndroidX, Kotlin, Chrome version >= 74.0.3729.185
- iOS: iOS version >= 11.0, Xcode version >= 11, Swift

## Getting Started

### Usage

```dart
class InitialUrlScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Initial URL"),
      ),
      body: WebView(
        initialUrl: "https://flutter.dev",
      ),
    );
  }
}
```

If you want to see other examples, see [example](./example) or see DartDoc.

## Known issues

- [Bad hybrid composition performance on Android](https://github.com/flutter/flutter/issues/62303)
