# native_webview

A Flutter plugin that allows you to add an inline WebView.

## Motivation

There is already a useful library for working with WebViews in Flutter.

These libraries come with trade-offs such as simple implementation but lack features, or very advanced features and complex implementation.

native_webview is designed to provide users with a standard set of WebView features provided by iOS and Android while keeping the implementation simple.

### Developers Preview Status

The native_webview is dependent on the PlatformView. Since this PlatformView is currently in the Developer Preview, this plugin should also be considered a Developer Preview.
Known issues are tagged with the  [flutter/flutter’s platform-views label](https://github.com/flutter/flutter/labels/a%3A%20platform-views). 

If you want to run native_webview on iOS, please test it on an actual device such as an iPhone.

## Requirements

- Dart: >=2.6.0 <3.0.0
- Flutter: >=1.12.13+hotfix.5 <2.0.0
- Android: minSdkVersion 24, AndroidX, Kotlin, Chrome version >= 74.0.3729.185
- iOS: iOS version >= 11.0, Xcode version >= 11, Swift

## Getting Started

### Setup

#### iOS

Opt-in to the embedded views preview by adding a boolean property to the app's Info.plist file with the key `io.flutter.embedded_views_preview` and the value `YES`.

#### Android

Change `android:windowSoftInputMode="adjustResize"` to `android:windowSoftInputMode="adjustPan"` in android/app/src/main/AndroidManifest.xml.

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

- [Can't paste text copied from other apps on Android 10](https://github.com/hisaichi5518/native_webview/issues/49)
- The following is an issue with Flutter's PlatformView.
  - The app becomes inoperable when using window.prompt in the iOS simulator.
  - Sometimes Dropdown doesn't work in the iOS simulator.
  - [Keyboard support](https://github.com/flutter/flutter/labels/p%3A%20webview-keyboard)
