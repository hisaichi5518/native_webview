package com.hisaichi5518.native_webview

import android.graphics.Bitmap
import android.webkit.WebResourceRequest
import android.webkit.WebResourceResponse
import android.webkit.WebView
import android.webkit.WebViewClient
import io.flutter.Log
import io.flutter.plugin.common.MethodChannel

class NativeWebViewClient(private val channel: MethodChannel, private val options: WebViewOptions) : WebViewClient() {
    companion object {
        const val JAVASCRIPT_BRIDGE_NAME = "nativeWebView"
    }

    private val contentBlockerHandler = ContentBlockerHandler(options.contentBlockers.map {
        ContentBlocker.fromMap(it)
    })

    private val javascript = """
        window.${JAVASCRIPT_BRIDGE_NAME}.callHandler = function() {
            window.${JAVASCRIPT_BRIDGE_NAME}._callHandler(arguments[0], JSON.stringify(Array.prototype.slice.call(arguments, 1)));
        };
        """.trimIndent()

    override fun shouldInterceptRequest(view: WebView?, request: WebResourceRequest): WebResourceResponse? {
        if (contentBlockerHandler.ruleList.isNotEmpty() && view != null) {
            try {
                return this.contentBlockerHandler.handleURL(view, request.url)
            } catch (e: Exception) {
                e.printStackTrace()
                Log.e("NativeWebView", e.toString())
            }
        }
        return null
    }

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

    override fun shouldOverrideUrlLoading(view: WebView?, request: WebResourceRequest): Boolean {
        if (!options.hasShouldOverrideUrlLoading) {
            return false
        }

        channel.invokeMethod(
            "shouldOverrideUrlLoading",
            mapOf(
                "url" to request.url.toString(),
                "method" to request.method,
                "headers" to request.requestHeaders,
                "isForMainFrame" to request.isForMainFrame
            ),
            object : MethodChannel.Result {
                override fun notImplemented() {
                    Log.i("NativeWebChromeClient", "shouldOverrideUrlLoading is notImplemented")
                }

                override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
                    Log.e("NativeWebChromeClient", "$errorCode $errorMessage $errorDetails")
                }

                override fun success(response: Any?) {
                    val responseMap = response as? Map<String, Any>
                    if (responseMap != null) {
                        when (responseMap["action"] as? Int) {
                            0 -> {
                                if (!request.isForMainFrame) {
                                    return
                                }
                                // There isn't any way to load an URL for a frame that is not the main frame,
                                // so call this only on main frame.
                                view?.loadUrl(request.url.toString(), request.requestHeaders)
                            }
                            else -> { }
                        }
                        return
                    }
                }

            }
        )
        // There isn't any way to load an URL for a frame that is not the main frame,
        // so if the request is not for the main frame, the navigation is allowed.
        return request.isForMainFrame
    }
}