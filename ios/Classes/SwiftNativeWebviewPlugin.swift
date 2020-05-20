import Flutter
import UIKit
import WebKit

public class SwiftNativeWebviewPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    registrar.register(FlutterWebViewFactory(registrar: registrar), withId: "com.hisaichi5518/native_webview")
    CookieManager.register(with: registrar)
    WebViewManager.register(with: registrar)
  }
}
