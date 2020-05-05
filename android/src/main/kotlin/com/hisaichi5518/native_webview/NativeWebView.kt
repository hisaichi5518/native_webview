package com.hisaichi5518.native_webview

import android.annotation.SuppressLint
import android.content.Context
import android.os.IBinder
import android.view.View
import io.flutter.plugin.common.MethodChannel

class NativeWebView(context: Context, channel: MethodChannel, options: WebViewOptions) : InputAwareWebView(context, null as View?) {
    init {
        webViewClient = NativeWebViewClient(channel, options)
        webChromeClient = NativeWebChromeClient(channel)
        @SuppressLint("SetJavaScriptEnabled")
        settings.javaScriptEnabled = true
        settings.domStorageEnabled = true
        settings.javaScriptCanOpenWindowsAutomatically = true
        addJavascriptInterface(JavascriptHandler(channel), NativeWebViewClient.JAVASCRIPT_BRIDGE_NAME)
    }

    fun load(initialData: Map<String, String>?, initialFile: String?, initialURL: String, initialHeaders: Map<String, String>?) {
        initialData?.let {
            val data = it["data"]
            val mimeType = it["mimeType"]
            val encoding = it["encoding"]
            val baseUrl = it["baseUrl"]
            val historyUrl = it["historyUrl"]
            loadDataWithBaseURL(baseUrl, data, mimeType, encoding, historyUrl)
            return
        }

        initialFile?.let { path ->
            val filename = Locator.binding!!.flutterAssets.getAssetFilePathByName(path)
            loadUrl("file:///android_asset/${filename}", initialHeaders)
            return
        }

        loadUrl(initialURL, initialHeaders)
    }

    // https://github.com/flutter/flutter/issues/36478
    // https://github.com/hisaichi5518/native_webview/pull/46
    override fun getWindowToken(): IBinder? {
        val token = Locator.activity?.window?.decorView?.windowToken
        if (token != null) {
            return token
        }
        return super.getWindowToken()
    }
}