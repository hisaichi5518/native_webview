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

    static private let processPool = WKProcessPool()

    var parent: UIView
    var webview: NativeWebView
    var channel: FlutterMethodChannel
    var registrar: FlutterPluginRegistrar

    public func view() -> UIView {
        return parent
    }

    init(parent: UIView, channel: FlutterMethodChannel, arguments args: NSDictionary, registrar: FlutterPluginRegistrar) {
        self.parent = parent
        self.registrar = registrar

        let configuration = WKWebViewConfiguration()
        let userController = WKUserContentController()
        configuration.userContentController = userController
        configuration.processPool = FlutterWebViewController.processPool

        self.webview = NativeWebView(frame: parent.bounds, configuration: configuration, channel: channel)
        self.channel = channel

        super.init()

        let javaScriptBridgeJSScript = WKUserScript(source: javaScriptBridgeJS, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        configuration.userContentController.addUserScript(javaScriptBridgeJSScript)
        configuration.userContentController.add(self, name: "callHandler")

        let initialURL = args["initialUrl"] as? String ?? "about:blank"
        let initialFile = args["initialFile"] as? String
        let initialData = args["initialData"] as? [String: String]
        let initialHeaders = args["initialHeaders"] as? [String: String]

        webview.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        webview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.parent.addSubview(webview)

        channel.setMethodCallHandler(handle)

        load(initialData, initialFile, initialURL, initialHeaders)
    }

    deinit {
        channel.setMethodCallHandler(nil)
    }

    func load(_ initialData: [String: String]?, _ initialFile: String?,  _ initialURL: String, _ initialHeaders: [String: String]?) {
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

        if let initialFile = initialFile {
            let key = registrar.lookupKey(forAsset: initialFile)
            guard let assetURL = Bundle.main.url(forResource: key, withExtension: nil) else {
                NSLog("\n[ERROR]\(initialFile) asset file cannot be found.")
                return
            }

            webview.loadURL(assetURL, headers: initialHeaders)
            return
        }

        webview.loadURLString(initialURL, headers: initialHeaders)
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
                    let message = error.userInfo["WKJavaScriptExceptionMessage"] as? String
                        ?? error.userInfo["NSLocalizedDescription"] as? String
                        ?? "unknown javascript error"

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

            webview.loadURLString(url, headers: arguments["headers"] as? [String: String])
            result(true)
        case "canGoBack":
            result(webview.canGoBack)
        case "goBack":
            webview.goBack()
            result(true)
        case "canGoForward":
            result(webview.canGoForward)
        case "goForward":
            webview.goForward()
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
