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
