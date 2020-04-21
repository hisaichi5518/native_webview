import Foundation
import Flutter
import UIKit

public class FlutterWebViewFactory: NSObject, FlutterPlatformViewFactory {
    private var registrar: FlutterPluginRegistrar

    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        super.init()
    }

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        let arguments = args as? NSDictionary ?? [:]
        let channel = FlutterMethodChannel(name: "com.hisaichi5518/native_webview_\(viewId)", binaryMessenger: registrar.messenger())

        return FlutterWebViewController(
            parent: UIView(frame: frame),
            channel: channel,
            arguments: arguments,
            registrar: registrar
        )
    }
}
