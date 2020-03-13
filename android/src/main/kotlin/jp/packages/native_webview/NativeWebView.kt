package jp.packages.native_webview

import android.annotation.SuppressLint
import android.content.Context
import io.flutter.plugin.common.MethodChannel

class NativeWebView(channel: MethodChannel, context: Context) : InputAwareWebView(context, null) {
    init {
        webViewClient = NativeWebViewClient(channel)
        webChromeClient = NativeWebChromeClient(channel)
        @SuppressLint("SetJavaScriptEnabled")
        settings.javaScriptEnabled = true
    }

    fun load(initialData: Map<String, String>?, initialFile: String?, initialURL: String, initialHeaders: Map<String, String>?) {
        initialData?.let {
            it["data"]
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
}