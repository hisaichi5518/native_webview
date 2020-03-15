package jp.packages.native_webview

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.platform.PlatformViewRegistry
import io.flutter.view.FlutterView

class NativeWebviewPlugin : FlutterPlugin, ActivityAware {
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
            "packages.jp/native_webview",
            FlutterWebViewFactory(messenger)
        )
    }

    override fun onDetachedFromActivity() {
        Locator.activity = null
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
