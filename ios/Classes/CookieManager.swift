import Foundation
import WebKit
import Flutter

class CookieManager: NSObject, FlutterPlugin {
    var channel: FlutterMethodChannel?
    var httpCookieStore = WKWebsiteDataStore.default().httpCookieStore

    static func register(with registrar: FlutterPluginRegistrar) {
        let manager = CookieManager()
        manager.channel = FlutterMethodChannel(name: "com.hisaichi5518/native_webview_cookie_manager", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(manager, channel: manager.channel!)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? NSDictionary
        switch call.method {
            case "setCookie":
                guard let arguments = arguments else {
                    break
                }
                let url = arguments["url"] as! String
                let name = arguments["name"] as! String
                let value = arguments["value"] as! String
                let domain = arguments["domain"] as? String
                let path = arguments["path"] as! String
                let maxAge = arguments["maxAge"] as? String
                let isSecure = arguments["isSecure"] as? Bool

                setCookie(url: url, name: name, value: value, domain: domain, path: path, maxAge: maxAge, isSecure: isSecure, result: result)
            case "getCookies":
                guard let arguments = arguments else {
                    break
                }
                let url = arguments["url"] as! String
                getCookies(url: url, result: result)
            case "deleteAllCookies":
                deleteAllCookies(result: result)
            default:
                result(FlutterMethodNotImplemented)
        }
    }

    public func setCookie(
        url: String,
        name: String,
        value: String,
        domain: String?,
        path: String,
        maxAge: String?,
        isSecure: Bool?,
        result: @escaping FlutterResult
    ) {
        var properties: [HTTPCookiePropertyKey: Any] = [:]
        properties[.originURL] = url
        properties[.name] = name
        properties[.value] = value
        properties[.path] = path

        if let domain = domain {
            properties[.domain] = domain.hasPrefix(".") ? domain : ".\(domain)"
        }

        if let maxAge = maxAge {
            properties[.maximumAge] = maxAge
        }

        // https://github.com/pichillilorenzo/flutter_inappwebview/pull/311
        if let isSecure = isSecure, isSecure {
            properties[.secure] = "TRUE"
        }

        if let cookie = HTTPCookie(properties: properties) {
            httpCookieStore.setCookie(cookie, completionHandler: {() in
                result(true)
            })
        } else {
            result(false)
        }
    }

    public func getCookies(url: String, result: @escaping FlutterResult) {
        var cookieList: [[String: Any]] = []
        httpCookieStore.getAllCookies { (cookies) in
            for cookie in cookies {
                // get url's domain
                let dummyCookie = HTTPCookie(properties: [
                    .originURL: url,
                    .name: "test",
                    .value: "test",
                    .path: "/"
                ])
                let domain = cookie.domain
                let canGetSubDomain = domain.hasPrefix(".")

                if canGetSubDomain, let dummyCookie = dummyCookie {
                    let mainDomain = String(domain.suffix(domain.count - 1))
                    if dummyCookie.domain.hasSuffix(mainDomain) {
                        cookieList.append([
                            "name": cookie.name,
                            "value": cookie.value
                        ])
                    }
                } else if dummyCookie?.domain == domain {
                    cookieList.append([
                        "name": cookie.name,
                        "value": cookie.value
                    ])
                }
            }
            result(cookieList)
        }
    }

    public func deleteAllCookies(result: @escaping FlutterResult) {
        WKWebsiteDataStore.default().removeData(
            ofTypes: [WKWebsiteDataTypeCookies],
            modifiedSince: Date(timeIntervalSince1970: 0),
            completionHandler:{
                result(true)
            }
        )
    }
}
