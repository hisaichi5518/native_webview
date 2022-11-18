package com.hisaichi5518.native_webview

import android.webkit.CookieManager
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class MyCookieManager(messenger: BinaryMessenger) : MethodCallHandler {

    private var channel = MethodChannel(messenger, "com.hisaichi5518/native_webview_cookie_manager")
    private var cookieManager: CookieManager = CookieManager.getInstance()

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "setCookie" -> {
                val url = call.argument<String>("url")!!
                val name = call.argument<String>("name")!!
                val value = call.argument<String>("value")!!
                val path = call.argument<String>("path")!!
                val domain = call.argument<String>("domain")
                val maxAge = call.argument<String>("maxAge")
                val isSecure = call.argument<Boolean>("isSecure") ?: false
                setCookie(url, name, value, path, domain, maxAge, isSecure, result)
            }
            "getCookies" -> result.success(getCookies(call.argument<String>("url")))
            "deleteAllCookies" -> deleteAllCookies(result)
            else -> result.notImplemented()
        }
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
    }

    private fun setCookie(
        url: String,
        name: String,
        value: String,
        path: String,
        domain: String?,
        maxAge: String?,
        isSecure: Boolean,
        result: MethodChannel.Result
    ) {
        val cookieValue = buildCookieValue(name, value, path, domain, maxAge, isSecure)
        cookieManager.setCookie(url, cookieValue) { result.success(true) }
        cookieManager.flush()
    }

    private fun getCookies(url: String?): List<Map<String, Any>> {
        val cookieMapList = mutableListOf<Map<String, Any>>()
        val cookiesString = cookieManager.getCookie(url) ?: return cookieMapList

        val cookies = cookiesString.split(";")
        for (cookie in cookies) {
            val nameValue = cookie.split(Regex("="), 2)
            val name = nameValue[0].trim()
            val value = if (nameValue.size > 1) nameValue[1].trim() else ""

            cookieMapList.add(mapOf(
                "name" to name,
                "value" to value
            ))
        }
        return cookieMapList
    }

    private fun deleteAllCookies(result: MethodChannel.Result) {
        cookieManager.removeAllCookies { result.success(true) }
        cookieManager.flush()
    }

    // refs https://blog.tokumaru.org/2011/10/cookiedomain.html
    // refs https://tools.ietf.org/html/rfc6265
    private fun buildCookieValue(
        name: String,
        value: String,
        path: String,
        domain: String?,
        maxAge: String?,
        isSecure: Boolean
    ) : String {
        val builder = StringBuilder("$name=$value; Path=$path")
        if (domain != null) builder.append("; Domain=$domain")
        if (maxAge != null) builder.append("; Max-Age=$maxAge")
        if (isSecure) builder.append("; Secure")
        builder.append(";")
        return builder.toString()
    }
}