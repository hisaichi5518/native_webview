import Flutter
import UIKit
import WebKit

public class SwiftNativeWebviewPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    registrar.register(FlutterWebViewFactory(registrar: registrar), withId: "packages.jp/native_webview")
  }
}
