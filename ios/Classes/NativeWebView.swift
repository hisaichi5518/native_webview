import Flutter
import Foundation
import WebKit

public class NativeWebView: WKWebView {
    var channel: FlutterMethodChannel?
    var options: WebViewOptions?
    // This flag is used to block the "shouldOverrideUrlLoading" event when the WKWebView is loading the first time,
    // in order to have the same behavior as Android
    var activateShouldOverrideUrlLoading = false

    init(frame: CGRect, configuration: WKWebViewConfiguration, channel: FlutterMethodChannel, options: WebViewOptions) {
        self.channel = channel
        self.options = options
        super.init(frame: frame, configuration: configuration)
        navigationDelegate = self
        uiDelegate = self

        if #available(iOS 13.0, *) {
            self.scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        }

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

extension NativeWebView: WKNavigationDelegate {
    public func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        if (navigationAction.targetFrame == nil) {
            webView.load(navigationAction.request)
        }

        return nil
    }

    public func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {

        if let url = navigationAction.request.url, activateShouldOverrideUrlLoading, let options = options, options.hasShouldOverrideUrlLoading {
            let isForMainFrame = navigationAction.targetFrame?.isMainFrame ?? false

            shouldOverrideUrlLoading(
                url: url,
                method: navigationAction.request.httpMethod,
                headers: navigationAction.request.allHTTPHeaderFields,
                isForMainFrame: isForMainFrame,
                navigationType: navigationAction.navigationType,
                decisionHandler: decisionHandler
            )
            return
        }
        if !activateShouldOverrideUrlLoading {
            activateShouldOverrideUrlLoading = true
        }

        decisionHandler(.allow)
    }

    public func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
    ) {
        decisionHandler(.allow)
    }

    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        let arguments: [String: String?] = ["url": webView.url?.absoluteString]
        channel?.invokeMethod("onPageStarted", arguments: arguments)
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let arguments: [String: String?] = ["url": webView.url?.absoluteString]
        channel?.invokeMethod("onPageFinished", arguments: arguments)
    }

    private func shouldOverrideUrlLoading(
        url: URL,
        method: String?,
        headers: [String: String]?,
        isForMainFrame: Bool,
        navigationType: WKNavigationType,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        let arguments: [String: Any?] = [
            "url": url.absoluteString,
            "method": method,
            "headers": headers,
            "isForMainFrame": isForMainFrame,
            "androidHasGesture": nil,
            "androidIsRedirect": nil,
            "iosWKNavigationType": navigationType.rawValue
        ]

        channel?.invokeMethod("shouldOverrideUrlLoading", arguments: arguments, result: { (result) -> Void in
            if result is FlutterError, let result = result as? FlutterError {
                NSLog("\n\(result.message ?? "message is nil")")
                decisionHandler(.allow)
                return
            }

            guard let response = result as? [String: Any] else {
                decisionHandler(.allow)
                return
            }

            let action = response["action"] as? Int ?? 0
            switch action {
            case 0:
                decisionHandler(.allow)
                break
            default:
                decisionHandler(.cancel)
            }
        })
    }
}

extension NativeWebView: WKUIDelegate {
    public func webView(
        _ webView: WKWebView,
        runJavaScriptTextInputPanelWithPrompt prompt: String,
        defaultText: String?,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping (String?) -> Void
    ) {
        let arguments: [String: String?] = ["message": prompt, "defaultText": defaultText]
        channel?.invokeMethod("onJsPrompt", arguments: arguments, result: { result -> Void in
            if result is FlutterError, let result = result as? FlutterError {
                NSLog("\n\(result.message ?? "message is nil")")
                return
            }

            var responseMessage: String?
            var okLabel: String?
            var cancelLabel: String?

            if let result = result, let response = result as? [String: Any] {
                if let handled = response["handledByClient"] as? Bool, handled {
                    let action = response["action"] as? Int
                    switch action {
                    case 0: // OK
                        let value = response["value"] as? String
                        completionHandler(value)
                    default: // Cancel
                        completionHandler(nil)
                    }
                    return
                }

                responseMessage = response["message"] as? String
                okLabel = response["okLabel"] as? String
                cancelLabel = response["cancelLabel"] as? String
            }

            self.createPromptDialog(
                message: responseMessage ?? prompt,
                defaultText: defaultText,
                okLabel: okLabel,
                cancelLabel: cancelLabel,
                completionHandler: completionHandler
            )
        })
    }

    public func webView(
        _ webView: WKWebView,
        runJavaScriptAlertPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping () -> Void
    ) {
        let arguments: [String: Any] = ["message": message]
        channel?.invokeMethod("onJsAlert", arguments: arguments, result: { result -> Void in
            if result is FlutterError, let result = result as? FlutterError {
                NSLog("\n\(result.message ?? "message is nil")")
                return
            }

            var responseMessage: String?
            var okLabel: String?

            if let result = result, let response = result as? [String: Any] {
                if let handled = response["handledByClient"] as? Bool, handled {
                    completionHandler()
                    return
                }

                responseMessage = response["message"] as? String
                okLabel = response["okLabel"] as? String
            }

            self.createAlertDialog(
                message: responseMessage ?? message,
                okLabel: okLabel,
                completionHandler: completionHandler
            )
        })
    }

    public func webView(
        _ webView: WKWebView,
        runJavaScriptConfirmPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping (Bool) -> Void
    ) {
        let arguments: [String: Any] = ["message": message]
        channel?.invokeMethod("onJsConfirm", arguments: arguments, result: { (result) -> Void in
            if result is FlutterError, let result = result as? FlutterError {
                NSLog("\n\(result.message ?? "message is nil")")
                return
            }

            var responseMessage: String?
            var okLabel: String?
            var cancelLabel: String?

            if let result = result, let response = result as? [String: Any] {
                if let handled = response["handledByClient"] as? Bool, handled {
                    let action = response["action"] as? Int
                    switch action {
                    case 0: // Confirm
                        completionHandler(true)
                    default: // Cancel
                        completionHandler(false)
                    }
                    return
                }

                responseMessage = response["message"] as? String
                okLabel = response["okLabel"] as? String
                cancelLabel = response["cancelLabel"] as? String
            }

            self.createConfirmDialog(
                message: responseMessage ?? message,
                okLabel: okLabel,
                cancelLabel: cancelLabel,
                completionHandler: completionHandler
            )
        })
        return
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        onWebResourceError(error as NSError)
    }

    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        onWebResourceError(error as NSError)
    }

    public func webView(
        _ webView: WKWebView,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        let host = challenge.protectionSpace.host
        let realm = challenge.protectionSpace.realm
        let arguments = ["host": host, "realm": realm]
        channel?.invokeMethod("onReceivedHttpAuthRequest", arguments: arguments, result: { (result) -> Void in
            if result is FlutterError, let result = result as? FlutterError {
                NSLog("\n\(result.message ?? "message is nil")")
                return
            }


            if let result = result, let response = result as? [String: Any] {
                    let action = response["action"] as? Int
                    switch action {
                    case 0: // useCredential
                        let username = response["username"] as! String
                        let password = response["password"] as! String
                        let credential = URLCredential(
                            user: username,
                            password: password,
                            persistence: URLCredential.Persistence.forSession
                        )
                        completionHandler(.useCredential, credential)
                    default: // Cancel
                        // Use .performDefaultHandling to make it behave the same as Android
                        completionHandler(.performDefaultHandling, nil)
                    }
                    return
            }

        })
    }

    private func createPromptDialog(
        message: String,
        defaultText: String?,
        okLabel: String?,
        cancelLabel: String?,
        completionHandler: @escaping (String?) -> Void
    ) {

        let okTitle = okLabel ?? NSLocalizedString("Ok", comment: "")
        let cancelTitle = cancelLabel ?? NSLocalizedString("Cancel", comment: "")
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.text = defaultText
        }

        alertController.addAction(UIAlertAction(title: okTitle, style: .default, handler: { (action) in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler("")
            }
        }))

        alertController.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: { (action) in
            completionHandler(nil)
        }))

        if let window = window, let controller = window.rootViewController {
            controller.present(alertController, animated: true, completion: nil)
        }
    }


    private func createAlertDialog(
        message: String,
        okLabel: String?,
        completionHandler: @escaping () -> Void
    ) {
        let okTitle = okLabel ?? NSLocalizedString("Ok", comment: "")
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: okTitle, style: .default, handler: { (action) in
            completionHandler()
        }))

        if let window = window, let controller = window.rootViewController {
            controller.present(alertController, animated: true, completion: nil)
        }
    }

    private func createConfirmDialog(
        message: String,
        okLabel: String?,
        cancelLabel: String?,
        completionHandler: @escaping (Bool) -> Void
    ) {
        let okTitle = okLabel ?? NSLocalizedString("Ok", comment: "")
        let cancelTitle = cancelLabel ?? NSLocalizedString("Cancel", comment: "")
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: okTitle, style: .default, handler: { (action) in
            completionHandler(true)
        }))

        alertController.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: { (action) in
            completionHandler(false)
        }))

        if let window = window, let controller = window.rootViewController {
            controller.present(alertController, animated: true, completion: nil)
        }
    }

    private func onWebResourceError(_ error: NSError) {
        let arguments: [String: Any?] = [
            "errorCode": error.code,
            "domain": error.domain,
            "description": error.description,
            "errorType": errorCodeToString(error.code)
        ]
        channel?.invokeMethod("onWebResourceError", arguments: arguments)
    }

    private func errorCodeToString(_ code: Int) -> String? {
        switch code {
        case WKError.unknown.rawValue:
            return "unknown"
        case WKError.webContentProcessTerminated.rawValue:
            return "webContentProcessTerminated"
        case WKError.webViewInvalidated.rawValue:
            return "webViewInvalidated"
        case WKError.javaScriptExceptionOccurred.rawValue:
            return "javaScriptExceptionOccurred"
        case WKError.javaScriptResultTypeIsUnsupported.rawValue:
            return "javaScriptResultTypeIsUnsupported"
        default:
            return nil
        }
    }
}
