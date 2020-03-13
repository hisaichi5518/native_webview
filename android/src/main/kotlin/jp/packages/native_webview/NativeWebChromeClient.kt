package jp.packages.native_webview

import android.webkit.WebChromeClient
import android.webkit.WebView
import io.flutter.plugin.common.MethodChannel

class NativeWebChromeClient(private val channel: MethodChannel): WebChromeClient() {
    override fun onProgressChanged(view: WebView?, newProgress: Int) {
        super.onProgressChanged(view, newProgress)
        channel.invokeMethod("onProgressChanged", mapOf(
            "progress" to newProgress
        ))
    }
}