package jp.packages.native_webview

import android.webkit.WebView
import android.webkit.WebViewClient
import io.flutter.plugin.common.MethodChannel

class NativeWebViewClient(private val channel: MethodChannel): WebViewClient() {
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
}