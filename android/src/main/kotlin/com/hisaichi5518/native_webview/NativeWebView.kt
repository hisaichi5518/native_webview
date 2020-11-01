package com.hisaichi5518.native_webview

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.*
import android.widget.LinearLayout
import android.widget.TextView
import androidx.core.content.ContextCompat.startActivity
import io.flutter.plugin.common.MethodChannel

class NativeWebView(context: Context, channel: MethodChannel, options: WebViewOptions) : InputAwareWebView(context, null as View?) {
    init {
        webViewClient = NativeWebViewClient(channel, options)
        webChromeClient = NativeWebChromeClient(channel)
        @SuppressLint("SetJavaScriptEnabled")
        settings.javaScriptEnabled = true
        settings.domStorageEnabled = true
        settings.javaScriptCanOpenWindowsAutomatically = true
        settings.useWideViewPort = true
        settings.loadWithOverviewMode = true
        settings.loadsImagesAutomatically = true
        addJavascriptInterface(JavascriptHandler(channel), NativeWebChromeClient.JAVASCRIPT_BRIDGE_NAME)

        setDownloadListener { url, _, _, mimetype, _ ->
            val intent = Intent(Intent.ACTION_VIEW)
            intent.type = mimetype
            intent.data = Uri.parse(url)

            val activity = Locator.activity ?: return@setDownloadListener
            if (intent.resolveActivity(activity.packageManager) != null) {
                startActivity(activity, intent, Bundle())
            }
        }
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
}