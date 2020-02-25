import Flutter
import Foundation
import WebKit

public class NativeWebView: WKWebView, WKNavigationDelegate {
    var channel: FlutterMethodChannel?

    init(frame: CGRect, configuration: WKWebViewConfiguration, channel: FlutterMethodChannel) {
        self.channel = channel
        super.init(frame: frame, configuration: configuration)
        navigationDelegate = self
    }

    required public init(coder aDecoder: NSCoder) {
        self.channel = nil
        super.init(coder: aDecoder)!
    }

    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        let arguments: [String: String?] = ["url": webView.url?.absoluteString]
        channel?.invokeMethod("onPageStarted", arguments: arguments)
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let arguments: [String: String?] = ["url": webView.url?.absoluteString]
        channel?.invokeMethod("onPageFinished", arguments: arguments)
    }
}
