package com.hisaichi5518.native_webview

import android.content.Context
import android.hardware.display.DisplayManager
import android.view.View
import android.webkit.WebView
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.platform.PlatformView

class FlutterWebViewController(
    context: Context,
    private val  methodChannel: MethodChannel,
    params: Map<String, Any?>
) : PlatformView, MethodCallHandler {
    private val webview: NativeWebView

    init {
        val displayListenerProxy = DisplayListenerProxy()
        val displayManager = Locator.activity!!.getSystemService(Context.DISPLAY_SERVICE) as DisplayManager
        displayListenerProxy.onPreWebViewInitialization(displayManager)
        displayListenerProxy.onPostWebViewInitialization(displayManager)

        val initialData = params["initialData"] as? Map<String, String>
        val initialFile = params["initialFile"] as? String
        val initialUrl = params["initialUrl"] as? String ?: "about:blank"
        val initialHeaders = params["initialHeaders"] as? Map<String, String>
        val hasShouldOverrideUrlLoading = params["hasShouldOverrideUrlLoading"] as? Boolean ?: false
        val contentBlockers = params["contentBlockers"] as? List<Map<String, Map<String?, Any?>>> ?: listOf()

        // This only works on iOS.
        // val gestureNavigationEnabled = params["gestureNavigationEnabled"] as? Boolean ?: false

        val debuggingEnabled = params["debuggingEnabled"] as? Boolean ?: false
        WebView.setWebContentsDebuggingEnabled(debuggingEnabled)

        val options = WebViewOptions(
            hasShouldOverrideUrlLoading,
            contentBlockers
        )

        methodChannel.setMethodCallHandler(this)

        webview = NativeWebView(context, methodChannel, options)

        val customUserAgent = params["userAgent"] as? String
        if (customUserAgent != null) {
            webview.settings.userAgentString = customUserAgent
        }

        webview.load(initialData, initialFile, initialUrl, initialHeaders)
    }

    override fun getView(): View {
        return webview
    }

    override fun onInputConnectionUnlocked() {
        webview.unlockInputConnection()
    }

    override fun onInputConnectionLocked() {
        webview.lockInputConnection()
    }

    override fun onFlutterViewAttached(flutterView: View) {
        webview.setContainerView(flutterView)
    }

    override fun onFlutterViewDetached() {
        webview.setContainerView(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "evaluateJavascript" -> {
                val javaScriptString = call.arguments as String
                webview.evaluateJavascript(javaScriptString) {
                    result.success(it)
                }
            }
            "currentUrl" -> {
                result.success(webview.url)
            }
            "loadUrl" -> {
                val arguments = call.arguments as Map<String, Any>
                val url = arguments["url"] as? String
                if (url == null) {
                    result.error("loadUrl", "Can not find url", null)
                    return
                }

                webview.loadUrl(url, arguments["headers"] as? Map<String, String>)
                result.success(true)
            }
            "canGoBack" -> {
                result.success(webview.canGoBack())
            }
            "goBack" -> {
                webview.goBack()
                result.success(true)
            }
            "canGoForward" -> {
                result.success(webview.canGoForward())
            }
            "goForward" -> {
                webview.goForward()
                result.success(true)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun dispose() {
        methodChannel.setMethodCallHandler(null)
        webview.dispose()
        webview.destroy()
    }
}