import Flutter
import UIKit
import WebKit

public class FlutterWebViewController: NSObject, FlutterPlatformView {

    var parent: UIView
    var webview: NativeWebView
    var channel: FlutterMethodChannel

    public func view() -> UIView {
        return parent
    }

    init(parent: UIView, channel: FlutterMethodChannel, arguments args: NSDictionary) {
        self.parent = parent
        self.webview = NativeWebView()
        self.channel = channel

        super.init()

        webview.loadHTMLString("<div>hisaichi5518</div>", baseURL: nil)

        webview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.parent.addSubview(webview)

        channel.setMethodCallHandler(handle)
    }

    deinit {
        channel.setMethodCallHandler(nil)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    }
}
