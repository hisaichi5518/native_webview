package com.hisaichi5518.native_webview

import android.app.Activity
import io.flutter.plugin.common.PluginRegistry
import io.flutter.embedding.engine.plugins.FlutterPlugin

class Locator {
    companion object {
        var activity: Activity? = null
        var binding: FlutterPlugin.FlutterPluginBinding? = null
        var activityResultListener: PluginRegistry.ActivityResultListener? = null
    }
}