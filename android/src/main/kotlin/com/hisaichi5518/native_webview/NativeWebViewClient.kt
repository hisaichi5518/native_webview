package com.hisaichi5518.native_webview

import android.graphics.Bitmap
import android.view.KeyEvent
import android.webkit.*
import io.flutter.Log
import io.flutter.plugin.common.MethodChannel
import java.util.*

class NativeWebViewClient(private val channel: MethodChannel, private val options: WebViewOptions) : WebViewClient() {

    private val contentBlockerHandler = ContentBlockerHandler(options.contentBlockers.map {
        ContentBlocker.fromMap(it)
    })

    override fun onReceivedHttpAuthRequest(view: WebView, handler: HttpAuthHandler, host: String, realm: String) {
        channel.invokeMethod(
            "onReceivedHttpAuthRequest",
            mapOf("host" to host, "realm" to realm),
            object : MethodChannel.Result {
                override fun notImplemented() {
                    Log.i("NativeWebViewClient", "onReceivedHttpAuthRequest is notImplemented")
                    handler.cancel()
                }

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                    Log.e("NativeWebViewClient", "$errorCode $errorMessage $errorDetails")
                    handler.cancel()
                }

                override fun success(response: Any?) {
                    val responseMap = response as? Map<String, Any>
                    if (responseMap != null) {
                        when (responseMap["action"] as? Int ?: 1) {
                            0 -> {
                                val username = responseMap["username"] as String
                                val password = responseMap["password"] as String
                                handler.proceed(username, password)
                            }
                            1 -> handler.cancel()
                            else -> handler.cancel()
                        }
                        return
                    }

                    handler.cancel()
                }
            })
    }

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
                    Log.i("NativeWebViewClient", "shouldOverrideUrlLoading is notImplemented")
                }

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                    Log.e("NativeWebViewClient", "$errorCode $errorMessage $errorDetails")
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

    override fun onUnhandledKeyEvent(view: WebView?, event: KeyEvent?) {}

    override fun onReceivedError(
        view: WebView?, request: WebResourceRequest?, error: WebResourceError) {
        onWebResourceError(
            error.errorCode, error.description.toString())
    }

    private fun onWebResourceError(errorCode: Int, description: String) {
        val args = mutableMapOf<String, Any>(
            "errorCode" to errorCode,
            "description" to description,
            "errorType" to   errorCodeToString(errorCode)
        )
        channel.invokeMethod("onWebResourceError", args)
    }

    private fun errorCodeToString(errorCode: Int): String {
        when (errorCode) {
            ERROR_AUTHENTICATION -> return "authentication"
            ERROR_BAD_URL -> return "badUrl"
            ERROR_CONNECT -> return "connect"
            ERROR_FAILED_SSL_HANDSHAKE -> return "failedSslHandshake"
            ERROR_FILE -> return "file"
            ERROR_FILE_NOT_FOUND -> return "fileNotFound"
            ERROR_HOST_LOOKUP -> return "hostLookup"
            ERROR_IO -> return "io"
            ERROR_PROXY_AUTHENTICATION -> return "proxyAuthentication"
            ERROR_REDIRECT_LOOP -> return "redirectLoop"
            ERROR_TIMEOUT -> return "timeout"
            ERROR_TOO_MANY_REQUESTS -> return "tooManyRequests"
            ERROR_UNKNOWN -> return "unknown"
            ERROR_UNSAFE_RESOURCE -> return "unsafeResource"
            ERROR_UNSUPPORTED_AUTH_SCHEME -> return "unsupportedAuthScheme"
            ERROR_UNSUPPORTED_SCHEME -> return "unsupportedScheme"
        }

        val message = "Could not find a string for errorCode: %d".format(Locale.getDefault(), errorCode)
        throw IllegalArgumentException(message)
    }

}