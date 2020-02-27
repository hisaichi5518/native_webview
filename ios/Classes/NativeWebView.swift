import Flutter
import Foundation
import WebKit

public class NativeWebView: WKWebView, WKNavigationDelegate {
    var channel: FlutterMethodChannel?

    init(frame: CGRect, configuration: WKWebViewConfiguration, channel: FlutterMethodChannel) {
        self.channel = channel
        super.init(frame: frame, configuration: configuration)
        navigationDelegate = self

        addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil
        )

    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    func loadURLString(_ url: String, headers: [String: String]?) {
        loadURL(URL(string: url)!, headers: headers)
    }

    func loadURL(_ url: URL, headers: [String: String]?) {
        var request = URLRequest(url: url)
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        load(request)
    }


    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        let arguments: [String: String?] = ["url": webView.url?.absoluteString]
        channel?.invokeMethod("onPageStarted", arguments: arguments)
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let arguments: [String: String?] = ["url": webView.url?.absoluteString]
        channel?.invokeMethod("onPageFinished", arguments: arguments)
    }


    override public func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            let arguments: [String: Int] = ["progress": Int(estimatedProgress * 100)]
            channel?.invokeMethod("onProgressChanged", arguments: arguments)
        }
    }
}
