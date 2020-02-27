import Flutter
import UIKit
import WebKit


private let JAVASCRIPT_BRIDGE_NAME = "nativeWebView"

private let javaScriptBridgeJS = """
window.\(JAVASCRIPT_BRIDGE_NAME) = {};
window.\(JAVASCRIPT_BRIDGE_NAME).callHandler = function() {
    window.webkit.messageHandlers['callHandler'].postMessage( {
        'handlerName': arguments[0],
        'args': JSON.stringify(Array.prototype.slice.call(arguments, 1))
    } );
}
"""

public class FlutterWebViewController: NSObject, FlutterPlatformView {

    var parent: UIView
    var webview: NativeWebView
    var channel: FlutterMethodChannel

    public func view() -> UIView {
        return parent
    }

    init(parent: UIView, channel: FlutterMethodChannel, arguments args: NSDictionary) {
        self.parent = parent

        let configuration = WKWebViewConfiguration()
        let userController = WKUserContentController()
        configuration.userContentController = userController

        self.webview = NativeWebView(frame: parent.bounds, configuration: configuration, channel: channel)
        self.channel = channel

        super.init()

        let javaScriptBridgeJSScript = WKUserScript(source: javaScriptBridgeJS, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        configuration.userContentController.addUserScript(javaScriptBridgeJSScript)
        configuration.userContentController.add(self, name: "callHandler")

        let initialURL = args["initialUrl"] as? String ?? "about:blank"
        let initialData = args["initialData"] as? [String: String]

        webview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.parent.addSubview(webview)

        channel.setMethodCallHandler(handle)

        load(initialData, initialURL);
    }

    deinit {
        channel.setMethodCallHandler(nil)
    }

    func load(_ initialData: [String: String]?, _ initialURL: String) {
        if let initialData = initialData,
            let dataString = initialData["data"],
            let mimeType = initialData["mimeType"],
            let encoding = initialData["encoding"],
            let baseURL = initialData["baseUrl"],
            let data = dataString.data(using: .utf8),
            let url = URL(string: baseURL)
        {
            webview.load(data, mimeType: mimeType, characterEncodingName: encoding, baseURL: url)
            return
        }

        webview.load(URLRequest(url: URL(string: initialURL)!))
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
        case "loadUrl":
            guard let arguments = call.arguments as? [String: Any?], let url = arguments["url"] as? String else {
                result(FlutterError.init(
                    code: "loadUrl",
                    message: "Can not find url",
                    details: nil
                ))
                return
            }

            var request = URLRequest(url: URL(string: url)!)
            if let headers = arguments["headers"] as? [String: String] {
                for (key, value) in headers {
                    request.setValue(value, forHTTPHeaderField: key)
                }
            }

            webview.load(request)
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

extension FlutterWebViewController: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? [String: Any],
            let handlerName = body["handlerName"] as? String,
            let args = body["args"] as? String
        else {
            return
        }
        let arguments = ["handlerName": handlerName, "args": args]
        channel.invokeMethod("onJavascriptHandler", arguments: arguments)
    }
}
