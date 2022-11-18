package com.hisaichi5518.native_webview

import androidx.webkit.WebViewCompat
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class WebViewManager(messenger: BinaryMessenger) : MethodCallHandler {

    private var channel = MethodChannel(messenger, "com.hisaichi5518/native_webview_webview_manager")

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getAndroidWebViewInfo" -> {
                val context = Locator.activity?.applicationContext
                if (context == null) {
                    result.success(null)
                    return
                }
                val packageInfo = WebViewCompat.getCurrentWebViewPackage(context)
                if (packageInfo == null) {
                    result.success(null)
                    return
                }

                result.success(mapOf(
                    "versionName" to packageInfo.versionName,
                    "packageName" to packageInfo.packageName
                ))
            }
            else -> result.notImplemented()
        }
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
    }
}