package com.hisaichi5518.native_webview

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformViewRegistry

class NativeWebviewPlugin : FlutterPlugin, ActivityAware {
    private var cookieManager: MyCookieManager? = null
    private var webviewManager: WebViewManager? = null

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        Locator.binding = binding

        onAttachedToEngine(
            binding.binaryMessenger,
            binding.platformViewRegistry
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Locator.binding = null
    }

    private fun onAttachedToEngine(messenger: BinaryMessenger, registry: PlatformViewRegistry) {
        registry.registerViewFactory(
            "com.hisaichi5518/native_webview",
            FlutterWebViewFactory(messenger)
        )
        cookieManager = MyCookieManager(messenger)
        webviewManager = WebViewManager(messenger)
    }

    override fun onDetachedFromActivity() {
        Locator.activity = null
        cookieManager?.dispose()
        cookieManager = null
        webviewManager?.dispose()
        webviewManager = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        Locator.activity = binding.activity
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Locator.activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        Locator.activity = null
    }
}
