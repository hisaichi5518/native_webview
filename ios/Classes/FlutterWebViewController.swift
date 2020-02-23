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
        switch call.method {
        case "evaluateJavascript":
            guard let javaScriptString = call.arguments as? String else {
                result(FlutterError.init(
                    code: "evaluateJavascript",
                    message: "evaluateJavaScript error",
                    details: "\(call.arguments ?? "<nil>") is not String"
                ))
                break;
            }
            webview.evaluateJavaScript(javaScriptString, completionHandler: { (completed, err) in
                if let err = err {
                    let error = err as NSError
                    let message = error.userInfo["WKJavaScriptExceptionMessage"] as? String ?? "javascript error"
                    result(FlutterError.init(
                        code: "evaluateJavascript",
                        message: message,
                        details: nil
                    ))
                } else {
                    result(completed)
                }
            })
        case "currentUrl":
            guard let url = webview.url else {
                result(nil)
                return
            }
            result(url.absoluteString)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
