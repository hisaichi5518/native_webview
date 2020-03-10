package jp.packages.native_webview

import android.content.Context
import android.view.View
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class FlutterWebViewController(
    context: Context,
    private val channel: MethodChannel,
    args: Map<String, Any>
) : PlatformView, MethodChannel.MethodCallHandler {
    private val webview: InputAwareWebView

    init {
        val initialUrl = args["initialUrl"] as? String
        val initialFile = args["initialFile"] as? String
        val initialData = args["initialData"] as? Map<String, String>
        val initialHeaders = args["initialHeaders"] as? Map<String, String>

        webview = NativeWebView(Locator.activity!!)

        webview.loadUrl(initialUrl)
    }

    override fun getView(): View {
        return webview
    }

    override fun dispose() {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "evaluateJavascript" -> {
                val javaScriptString = call.arguments as String
                webview.evaluateJavascript(javaScriptString) {
                    if (it == null)
                        return@evaluateJavascript
                    result.success(it)
                }
            }
        }
    }

    override fun onFlutterViewAttached(flutterView: View) {
        webview.setContainerView(flutterView)
    }

    override fun onFlutterViewDetached() {
        webview.setContainerView(null)
    }
}