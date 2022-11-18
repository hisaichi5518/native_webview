package com.hisaichi5518.native_webview

import android.app.Activity
import android.content.DialogInterface
import android.content.Intent
import android.content.pm.ActivityInfo
import android.graphics.Color
import android.net.Uri
import android.util.Log
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.webkit.*
import android.widget.EditText
import android.widget.FrameLayout
import android.widget.LinearLayout
import androidx.appcompat.app.AlertDialog
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry


class NativeWebChromeClient(private val channel: MethodChannel) : WebChromeClient(), PluginRegistry.ActivityResultListener {
    private var videoView: View? = null
    private var videoViewCallback: CustomViewCallback? = null
    private var originalRequestedOrientation = ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED
    private var originalSystemUiVisibility = 0
    private var filePathCallback: ValueCallback<Array<Uri>>? = null

    companion object {
        const val FULLSCREEN_SYSTEM_UI_VISIBILITY = View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION or
            View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or
            View.SYSTEM_UI_FLAG_LAYOUT_STABLE or
            View.SYSTEM_UI_FLAG_HIDE_NAVIGATION or
            View.SYSTEM_UI_FLAG_FULLSCREEN or
            View.SYSTEM_UI_FLAG_IMMERSIVE or
            View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY

        val FULLSCREEN_LAYOUT_PARAMS = FrameLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT,
            Gravity.CENTER
        )

        const val JAVASCRIPT_BRIDGE_NAME = "nativeWebView"
        val JAVASCRIPT = """
if (!window.${JAVASCRIPT_BRIDGE_NAME}.callHandler) {
    window.${JAVASCRIPT_BRIDGE_NAME}.callHandler = function() {
        window.${JAVASCRIPT_BRIDGE_NAME}._callHandler(arguments[0], JSON.stringify(Array.prototype.slice.call(arguments, 1)));
    };
}""".trimIndent()
        const val PICKER_REQUEST_CODE = 1;
    }

    override fun onShowCustomView(view: View?, callback: CustomViewCallback?) {
        if (videoView != null) {
            onHideCustomView()
            return
        }
        val activity = Locator.activity ?: return
        val decorView = activity.findViewById(android.R.id.content) as ViewGroup? ?: return

        videoView = view
        videoViewCallback = callback

        originalSystemUiVisibility = decorView.systemUiVisibility
        originalRequestedOrientation = activity.requestedOrientation

        decorView.systemUiVisibility = FULLSCREEN_SYSTEM_UI_VISIBILITY
        activity.window.setFlags(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS, WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS)

        videoView?.setBackgroundColor(Color.BLACK)
        decorView.addView(videoView, FULLSCREEN_LAYOUT_PARAMS)

        super.onShowCustomView(view, callback)
    }

    override fun onHideCustomView() {
        if (videoView == null) {
            return
        }
        videoView?.visibility = View.GONE

        val activity = Locator.activity ?: return
        val decorView = activity.findViewById(android.R.id.content) as ViewGroup? ?: return

        decorView.systemUiVisibility = originalSystemUiVisibility
        decorView.removeView(videoView)

        activity.window.clearFlags(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS)
        activity.requestedOrientation = originalRequestedOrientation

        videoViewCallback?.onCustomViewHidden()

        videoView = null
        videoViewCallback = null

        super.onHideCustomView()
    }

    override fun onProgressChanged(view: WebView?, newProgress: Int) {
        super.onProgressChanged(view, newProgress)

        view?.evaluateJavascript(JAVASCRIPT) {}

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

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
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

    override fun onJsAlert(view: WebView?, url: String?, message: String, result: JsResult): Boolean {
        channel.invokeMethod(
            "onJsAlert",
            mapOf("message" to message),
            object : MethodChannel.Result {
                override fun notImplemented() {
                    Log.i("NativeWebChromeClient", "onJsAlert is notImplemented")
                    result.cancel()
                }

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                    Log.e("NativeWebChromeClient", "$errorCode $errorMessage $errorDetails")
                    result.cancel()
                }

                override fun success(response: Any?) {
                    var responseMessage: String? = null
                    var okLabel: String? = null

                    val responseMap = response as? Map<String, Any>
                    if (responseMap != null) {
                        val handledByClient = responseMap["handledByClient"] as? Boolean
                        if (handledByClient != null && handledByClient) {
                            result.confirm()
                            return
                        }

                        responseMessage = responseMap["message"] as? String ?: message
                        okLabel = responseMap["okLabel"] as? String
                    }

                    createAlertDialog(
                        responseMessage ?: message,
                        result,
                        okLabel
                    )
                }
            })

        return true
    }

    override fun onJsPrompt(view: WebView?, url: String?, message: String, defaultValue: String?, result: JsPromptResult): Boolean {
        channel.invokeMethod(
            "onJsPrompt",
            mapOf("message" to message),
            object : MethodChannel.Result {
                override fun notImplemented() {
                    Log.i("NativeWebChromeClient", "onJsPrompt is notImplemented")
                    result.cancel()
                }

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
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
                                0 -> {
                                    val value = responseMap["value"] as? String
                                    result.confirm(value)
                                }
                                1 -> result.cancel()
                                else -> result.cancel()
                            }
                            return
                        }

                        responseMessage = responseMap["message"] as? String ?: message
                        okLabel = responseMap["okLabel"] as? String
                        cancelLabel = responseMap["cancelLabel"] as? String
                    }

                    createPromptDialog(
                        responseMessage ?: message,
                        defaultValue,
                        result,
                        okLabel,
                        cancelLabel
                    )
                }
            })
        return true
    }

    private fun createAlertDialog(
        message: String,
        result: JsResult,
        okLabel: String?
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

        builder.setOnCancelListener { dialog ->
            result.cancel()
            dialog.dismiss()
        }
        builder.show()
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

    private fun createPromptDialog(
        message: String,
        defaultText: String?,
        result: JsPromptResult,
        okLabel: String?,
        cancelLabel: String?
    ) {
        val layout = FrameLayout(Locator.activity!!)
        val editText = EditText(Locator.activity!!).apply {
            maxLines = 1
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT
            )
            setText(defaultText)
        }

        layout.setPaddingRelative(45, 15, 45, 0)
        layout.addView(editText)

        val builder = AlertDialog.Builder(Locator.activity!!, R.style.Theme_AppCompat_Dialog_Alert).apply {
            setMessage(message)
        }

        val confirmClickListener = DialogInterface.OnClickListener { dialog, _ ->
            result.confirm(editText.text.toString())
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

        builder.setView(layout)

        builder.setOnCancelListener { dialog ->
            result.cancel()
            dialog.dismiss()
        }
        builder.show()
    }

    override fun onShowFileChooser(
        webview: WebView?,
        filePathCallback: ValueCallback<Array<Uri>>?,
        fileChooserParams: FileChooserParams?
    ): Boolean {
        val acceptTypes = fileChooserParams?.acceptTypes;
        val allowMultiple = fileChooserParams?.mode == FileChooserParams.MODE_OPEN_MULTIPLE
        val activity = Locator.activity
        activity ?: return false
        this.filePathCallback = filePathCallback
        Locator.activityResultListener = this

        val contentIntent = Intent(Intent.ACTION_GET_CONTENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "*/*"
            val isEmptyArray = acceptTypes?.isEmpty() == true || (acceptTypes?.size == 1 && acceptTypes[0].isEmpty())
            if (!isEmptyArray) {
                putExtra(Intent.EXTRA_MIME_TYPES, acceptTypes);
            }
            putExtra(Intent.EXTRA_ALLOW_MULTIPLE, allowMultiple);
        }

        activity.startActivityForResult(contentIntent, PICKER_REQUEST_CODE)

        return true
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (filePathCallback == null || requestCode != PICKER_REQUEST_CODE) {
            return false
        }
        if (resultCode == Activity.RESULT_CANCELED) {
            filePathCallback?.onReceiveValue(null)
        } else if (resultCode == Activity.RESULT_OK) {
            filePathCallback?.onReceiveValue(
                    FileChooserParams.parseResult(resultCode, data)
            )
        }
        filePathCallback = null
        Locator.activityResultListener = null
        return true
    }
}