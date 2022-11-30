## 1.4.0

- [Suppress build warnings #110](https://github.com/hisaichi5518/native_webview/pull/110)
- [Upgrade Flutter and fix Android typing to align with the SDK #109](https://github.com/hisaichi5518/native_webview/pull/109)

## 1.2.0

- Fix null safety

## 1.1.0

- Fix null safety

## 1.0.0

- null safety

## 0.28.0

- The webview event callback returns FutureOr type.
- Add PlatformWebView

## 0.27.0

- [Use PlatformViewLink](https://github.com/hisaichi5518/native_webview/pull/79)

## 0.26.0

- [Fix crash](https://github.com/hisaichi5518/native_webview/pull/84)
- [Support video fullscreen](https://github.com/hisaichi5518/native_webview/pull/83)
- [set DownloadListener](https://github.com/hisaichi5518/native_webview/pull/82)

## 0.25.0

- [Add onReceivedHttpAuthRequest](https://github.com/hisaichi5518/native_webview/pull/72)
- [Update flutter](https://github.com/hisaichi5518/native_webview/pull/76)
- [set useWideViewPort and loadWithOverviewMode](https://github.com/hisaichi5518/native_webview/pull/77)
- [Add BasicAuthScreen to example](https://github.com/hisaichi5518/native_webview/pull/78)
- [Use integration_test](https://github.com/hisaichi5518/native_webview/pull/80)

## 0.24.0

- [Use Android Studio 4.0](https://github.com/hisaichi5518/native_webview/pull/70)
- [be able to use "callHandler", even if the readyState is interactive](https://github.com/hisaichi5518/native_webview/pull/71)

## 0.23.0

- [Fix ios webview leak](https://github.com/hisaichi5518/native_webview/pull/68)

## 0.22.0

- [Add userAgent option](https://github.com/hisaichi5518/native_webview/pull/67)

## 0.21.0

- [Fix FloatingAction design](https://github.com/hisaichi5518/native_webview/pull/65)
- [Fix null pointer exception](https://github.com/hisaichi5518/native_webview/pull/65)
- [Remove unnecessary code](https://github.com/hisaichi5518/native_webview/pull/65)

## 0.20.0

- [Add WebViewManager](https://github.com/hisaichi5518/native_webview/pull/63)
- [delete deleteCookie and deleteCookies](https://github.com/hisaichi5518/native_webview/pull/62)
- [Fix getCookie for iOS](https://github.com/hisaichi5518/native_webview/pull/62)

## 0.19.0

- [the keyboard does not appear on ASUS_X00PD](https://github.com/hisaichi5518/native_webview/pull/58)

## 0.18.0

- [Fix scroll bar appearing above contents problem](https://github.com/hisaichi5518/native_webview/pull/56)

## 0.17.0

- [Change the behavior when domain is not set](https://github.com/hisaichi5518/native_webview/pull/53)

## 0.16.0

- [Change Cookie Manager API](https://github.com/hisaichi5518/native_webview/pull/52)
- Fix [Keyboard persists after tapping outside text field](https://github.com/flutter/flutter/issues/36478#issuecomment-623542124)
- Fix [The keyboard is not displayed in the example application.](https://github.com/hisaichi5518/native_webview/pull/45)
- [Display selection popup on Android WebView](https://github.com/hisaichi5518/native_webview/pull/48)
- Fix [expiresDate, maxAge settings are ignored on iOS](https://github.com/hisaichi5518/native_webview/pull/50)
- Fix [The domain setting is not working on both OSs](https://github.com/hisaichi5518/native_webview/pull/50)

## 0.15.0

- Add debuggingEnabled
- Add gestureNavigationEnabled
- Add onWebResourceError
- Fix iOS WebView not opening href with target="\_blank"

## 0.14.0

- Fix [Sometimes the screen flickers when using WebView #22](https://github.com/hisaichi5518/native_webview/issues/22)
- Fix [Attempt to read from field 'android.view.WindowManager$LayoutParams android.view.ViewRootImpl.mWindowAttributes' on a null object reference #29](https://github.com/hisaichi5518/native_webview/issues/29)
- Fix [java.lang.ClassCastException: $Proxy0 cannot be cast to android.view.WindowManagerImpl #32](https://github.com/hisaichi5518/native_webview/pull/32)
- Update ThreadedInputConnectionProxyAdapterView
- Add DisplayListenerProxy
- Update InputAwareWebView

## 0.13.0

- Add goBack and goForward for Android
- changed Android min sdk version
- Chrome version >= 74.0.3729.185

## 0.12.0

- Add ContentBlocker

## 0.11.1

- shouldOverrideUrlLoading returns Future<ShouldOverrideUrlLoadingAction>.

## 0.11.0

- Add ShouldOverrideUrlLoading

## 0.10.0

- Rename to com.hisaichi5518

## 0.9.0

- Prevent screen flickering on iOS devices.
- Set the default text when using window.prompt on iOS.

## 0.0.2

- Update pubspec.yaml
- Add analysis_options.yaml

## 0.0.1

- Initial release.
