package com.hisaichi5518.native_webview

import android.graphics.Bitmap
import android.webkit.WebView
import android.webkit.WebViewClient
import io.flutter.plugin.common.MethodChannel

class NativeWebViewClient(private val channel: MethodChannel) : WebViewClient() {
    companion object {
        const val JAVASCRIPT_BRIDGE_NAME = "nativeWebView"
    }

    private val javascript = """
        window.${JAVASCRIPT_BRIDGE_NAME}.callHandler = function() {
            window.${JAVASCRIPT_BRIDGE_NAME}._callHandler(arguments[0], JSON.stringify(Array.prototype.slice.call(arguments, 1)));
        };
        """.trimIndent()

    override fun onPageStarted(view: WebView?, url: String?, favicon: Bitmap?) {
        super.onPageStarted(view, url, favicon)

        channel.invokeMethod("onPageStarted", mapOf(
            "url" to url
        ))
    }

    override fun onPageFinished(view: WebView?, url: String?) {
        super.onPageFinished(view, url)

        // https://issues.apache.org/jira/browse/CB-11248
        view?.apply {
            clearFocus()
            requestFocus()
        }

        view?.evaluateJavascript(javascript) {}

        channel.invokeMethod("onPageFinished", mapOf(
            "url" to url
        ))
    }
}