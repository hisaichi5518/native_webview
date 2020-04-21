package com.hisaichi5518.native_webview

import android.os.Handler
import android.os.Looper
import android.webkit.JavascriptInterface
import io.flutter.plugin.common.MethodChannel

class JavascriptHandler(private val channel: MethodChannel) {
    @JavascriptInterface
    fun _callHandler(handlerName: String, args: String) {
        val handler = Handler(Looper.getMainLooper())
        handler.post {
            channel.invokeMethod("onJavascriptHandler", mapOf(
                "handlerName" to handlerName,
                "args" to args
            ))
        }
    }
}