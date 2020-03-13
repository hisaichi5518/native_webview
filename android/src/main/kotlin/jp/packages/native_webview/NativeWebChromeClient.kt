package jp.packages.native_webview

import androidx.appcompat.app.AlertDialog
import android.content.DialogInterface
import android.util.Log
import android.webkit.JsResult
import android.webkit.WebChromeClient
import android.webkit.WebView
import io.flutter.plugin.common.MethodChannel


class NativeWebChromeClient(private val channel: MethodChannel) : WebChromeClient() {
    override fun onProgressChanged(view: WebView?, newProgress: Int) {
        super.onProgressChanged(view, newProgress)
        channel.invokeMethod("onProgressChanged", mapOf(
            "progress" to newProgress
        ))
    }

    override fun onJsConfirm(view: WebView?, url: String?, message: String, result: JsResult): Boolean {
        channel.invokeMethod(
            "onJsConfirm",
            mapOf("message" to message),
            object : MethodChannel.Result {
                override fun notImplemented() {
                    Log.i("NativeWebChromeClient", "onJsConfirm is notImplemented")
                    result.cancel()
                }

                override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
                    Log.e("NativeWebChromeClient", "$errorCode $errorMessage $errorDetails")
                    result.cancel()
                }

                override fun success(response: Any?) {
                    var responseMessage: String? = null
                    var okLabel: String? = null
                    var cancelLabel: String? = null

                    val responseMap = response as? Map<String, Any>
                    if (responseMap != null) {
                        val handledByClient = responseMap["handledByClient"] as? Boolean
                        val action = responseMap["action"] as? Int
                        if (handledByClient != null && handledByClient) {
                            when (action) {
                                0 -> result.confirm()
                                1 -> result.cancel()
                                else -> result.cancel()
                            }
                            return
                        }

                        responseMessage = responseMap["message"] as? String ?: message
                        okLabel = responseMap["okLabel"] as? String
                        cancelLabel = responseMap["cancelLabel"] as? String
                    }

                    createConfirmDialog(
                        responseMessage ?: message,
                        result,
                        okLabel,
                        cancelLabel
                    )
                }
            })

        return true
    }

    private fun createConfirmDialog(
        message: String,
        result: JsResult,
        okLabel: String?,
        cancelLabel: String?
    ) {
        val builder = AlertDialog.Builder(Locator.activity!!, R.style.Theme_AppCompat_Dialog_Alert).apply {
            setMessage(message)
        }

        val confirmClickListener = DialogInterface.OnClickListener { dialog, _ ->
            result.confirm()
            dialog.dismiss()
        }
        if (okLabel != null && okLabel.isNotEmpty()) {
            builder.setPositiveButton(okLabel, confirmClickListener)
        } else {
            builder.setPositiveButton(android.R.string.ok, confirmClickListener)
        }

        val cancelClickListener = DialogInterface.OnClickListener { dialog, _ ->
            result.cancel()
            dialog.dismiss()
        }
        if (cancelLabel != null && cancelLabel.isNotEmpty()) {
            builder.setNegativeButton(cancelLabel, cancelClickListener)
        } else {
            builder.setNegativeButton(android.R.string.cancel, cancelClickListener)
        }
        builder.setOnCancelListener { dialog ->
            result.cancel()
            dialog.dismiss()
        }
        builder.show()
    }
}