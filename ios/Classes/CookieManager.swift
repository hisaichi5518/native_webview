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
                let domain = arguments["domain"] as! String
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
            case "deleteCookie":
                guard let arguments = arguments else {
                    break
                }
                let url = arguments["url"] as! String
                let name = arguments["name"] as! String
                let domain = arguments["domain"] as! String
                let path = arguments["path"] as! String
                deleteCookie(url: url, name: name, domain: domain, path: path, result: result)
            case "deleteCookies":
                guard let arguments = arguments else {
                    break
                }
                let url = arguments["url"] as! String
                let domain = arguments["domain"] as! String
                let path = arguments["path"] as! String
                deleteCookies(url: url, domain: domain, path: path, result: result)
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
        domain: String,
        path: String,
        maxAge: String?,
        isSecure: Bool?,
        result: @escaping FlutterResult
    ) {
        var properties: [HTTPCookiePropertyKey: Any] = [:]
        properties[.originURL] = url
        properties[.name] = name
        properties[.value] = value
        properties[.domain] = domain.hasPrefix(".") ? domain : ".\(domain)"
        properties[.path] = path

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
                var domain = cookie.domain
                domain = domain.hasPrefix(".") ? String(domain.suffix(domain.count - 1)) : domain
                if let host = URL(string: url)?.host, host.hasSuffix(domain) {
                    cookieList.append([
                        "name": cookie.name,
                        "value": cookie.value
                    ])
                }
            }
            result(cookieList)
        }
    }

    public func deleteCookie(url: String, name: String, domain: String, path: String, result: @escaping FlutterResult) {
        httpCookieStore.getAllCookies { [weak self] (cookies) in
            guard let strongSelf = self else {
                result(false)
                return
            }

            for cookie in cookies {
                var originURL = ""
                guard let properties = cookie.properties else {
                    continue
                }

                if let url = properties[.originURL] as? String {
                    originURL = url
                } else if let url = properties[.originURL] as? URL {
                    originURL = url.absoluteString
                }

                if !originURL.isEmpty, originURL != url {
                    continue
                }

                if cookie.domain.contains(domain) && cookie.name == name && cookie.path == path {
                    strongSelf.httpCookieStore.delete(cookie, completionHandler: {
                        result(true)
                    })
                    return
                }
            }
            result(false)
        }
    }

    public func deleteCookies(url: String, domain: String, path: String, result: @escaping FlutterResult) {
        httpCookieStore.getAllCookies { [weak self] (cookies) in
            guard let strongSelf = self else {
                result(false)
                return
            }
            for cookie in cookies {
                var originURL = ""
                guard let properties = cookie.properties else {
                    continue
                }

                if let url = properties[.originURL] as? String {
                    originURL = url
                } else if let url = properties[.originURL] as? URL {
                    originURL = url.absoluteString
                }

                if !originURL.isEmpty, originURL != url {
                    continue
                }

                if cookie.domain.contains(domain) && cookie.path == path {
                    strongSelf.httpCookieStore.delete(cookie, completionHandler: nil)
                }
            }
            result(true)
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
