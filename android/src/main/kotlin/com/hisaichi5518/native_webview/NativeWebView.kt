package com.hisaichi5518.native_webview

import android.annotation.SuppressLint
import android.content.Context
import android.os.IBinder
import android.view.*
import android.widget.LinearLayout
import android.widget.TextView
import io.flutter.plugin.common.MethodChannel

class NativeWebView(context: Context, channel: MethodChannel, options: WebViewOptions) : InputAwareWebView(context, null as View?) {
    private var motionEvent: MotionEvent? = null
    private var floatingActionView: LinearLayout? = null

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

    override fun dispatchTouchEvent(event: MotionEvent?): Boolean {
        motionEvent = event
        return super.dispatchTouchEvent(event)
    }

    @SuppressLint("ClickableViewAccessibility")
    override fun onTouchEvent(event: MotionEvent): Boolean {
        if (event.action == MotionEvent.ACTION_DOWN && floatingActionView != null) {
            removeView(floatingActionView)
            floatingActionView = null
        }
        return super.onTouchEvent(event)
    }

    override fun startActionMode(callback: ActionMode.Callback): ActionMode? {
        return rebuildActionMode(super.startActionMode(callback), callback)
    }

    override fun startActionMode(callback: ActionMode.Callback, type: Int): ActionMode? {
        return rebuildActionMode(super.startActionMode(callback, type), callback)
    }

    private fun rebuildActionMode(
        actionMode: ActionMode?,
        callback: ActionMode.Callback
    ): ActionMode? {
        if (floatingActionView != null) {
            removeView(floatingActionView)
            floatingActionView = null
        }
        if (actionMode == null) {
            return null
        }

        floatingActionView = LayoutInflater.from(context)
            .inflate(R.layout.floating_action_mode, this, false) as LinearLayout
        for (i in 0 until actionMode.menu.size()) {
            val menu = actionMode.menu.getItem(i)
            val text = LayoutInflater.from(context)
                .inflate(R.layout.floating_action_mode_item, this, false) as TextView
            text.text = menu.title
            text.setOnClickListener {
                removeView(floatingActionView)
                floatingActionView = null
                callback.onActionItemClicked(actionMode, menu)
            }
            floatingActionView?.addView(text)

            // Maximum 4 items for the sake of screen size.
            if (i >= 4) {
                break
            }
        }
        val x = motionEvent?.x?.toInt() ?: 0
        val y = motionEvent?.y?.toInt() ?: 0
        floatingActionView
            ?.viewTreeObserver
            ?.addOnGlobalLayoutListener(object : ViewTreeObserver.OnGlobalLayoutListener {
                override fun onGlobalLayout() {
                    floatingActionView!!.viewTreeObserver.removeOnGlobalLayoutListener(this)
                    onFloatingActionGlobalLayout(x, y)
                }
            })
        addView(floatingActionView, LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT, x, y))
        actionMode.menu.clear()
        return actionMode
    }

    private fun onFloatingActionGlobalLayout(x: Int, y: Int) {
        val maxWidth: Int = width
        val maxHeight: Int = height
        val width = floatingActionView!!.width
        val height = floatingActionView!!.height
        var curx = x - width / 2
        if (curx < 0) {
            curx = 0
        } else if (curx + width > maxWidth) {
            curx = maxWidth - width
        }
        val size = 12 * context.resources.displayMetrics.density
        var cury = y + size
        if (cury + height > maxHeight) {
            cury = y - height - size
        }
        updateViewLayout(
            floatingActionView,
            LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT, curx, cury.toInt() + scrollY)
        )
        floatingActionView!!.alpha = 1f
    }
}