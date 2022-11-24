//
//  WebViewManager.swift
//  native_webview
//
//  Created by hisaichi5518 on 2020/05/21.
//

import Foundation
import WebKit
import Flutter

class WebViewManager: NSObject, FlutterPlugin {
    var channel: FlutterMethodChannel?

    static func register(with registrar: FlutterPluginRegistrar) {
        let manager = WebViewManager()
        manager.channel = FlutterMethodChannel(name: "com.hisaichi5518/native_webview_webview_manager", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(manager, channel: manager.channel!)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            default:
                result(FlutterMethodNotImplemented)
        }
    }
}
