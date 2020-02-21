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

        let initialURL = args["initialUrl"] as? String ?? "about:blank"

        webview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.parent.addSubview(webview)

        channel.setMethodCallHandler(handle)
        webview.load(URLRequest(url: URL(string: initialURL)!))
    }

    deinit {
        channel.setMethodCallHandler(nil)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    }
}
