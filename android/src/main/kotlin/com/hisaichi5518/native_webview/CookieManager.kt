package com.hisaichi5518.native_webview

import android.webkit.CookieManager
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import kotlin.collections.ArrayList
import kotlin.collections.HashMap

class MyCookieManager(messenger: BinaryMessenger?) : MethodCallHandler {

    private var channel = MethodChannel(messenger, "com.hisaichi5518/native_webview_cookie_manager")
    private var cookieManager: CookieManager = CookieManager.getInstance()

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "setCookie" -> {
                val url = call.argument<String>("url")
                val name = call.argument<String>("name")
                val value = call.argument<String>("value")
                val domain = call.argument<String>("domain")
                val path = call.argument<String>("path")
                val maxAge = call.argument<String>("maxAge")
                val isSecure = call.argument<Boolean>("isSecure")
                setCookie(url, name, value, domain, path, maxAge, isSecure, result)
            }
            "getCookies" -> result.success(getCookies(call.argument<String>("url")))
            "deleteCookies" -> {
                val url = call.argument<String>("url")
                val domain = call.argument<String>("domain")
                val path = call.argument<String>("path")
                deleteCookies(url, domain, path, result)
            }
            "deleteAllCookies" -> deleteAllCookies(result)
            else -> result.notImplemented()
        }
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
    }

    private fun setCookie(
        url: String?,
        name: String?,
        value: String?,
        domain: String?,
        path: String?,
        maxAge: String?,
        isSecure: Boolean?,
        result: MethodChannel.Result
    ) {
        var cookieValue = "$name=$value; Path=$path"
        if (domain != null) cookieValue += "; Domain=$domain"
        if (maxAge != null) cookieValue += "; Max-Age=$maxAge"
        if (isSecure != null && isSecure) cookieValue += "; Secure"
        cookieValue += ";"

        cookieManager.setCookie(url, cookieValue) { result.success(true) }
        cookieManager.flush()
    }

    private fun getCookies(url: String?): List<Map<String, Any>> {
        val cookieListMap: MutableList<Map<String, Any>> = ArrayList()
        val cookiesString: String? = cookieManager.getCookie(url)
        val cookies = cookiesString?.split(";") ?: listOf()
        for (cookie in cookies) {
            val nameValue = cookie.split(Regex("="), 2)
            val name = nameValue[0].trim { it <= ' ' }
            val value = nameValue[1].trim { it <= ' ' }
            val cookieMap: MutableMap<String, Any> = HashMap()

            cookieMap["name"] = name
            cookieMap["value"] = value
            cookieListMap.add(cookieMap)
        }
        return cookieListMap
    }

    private fun deleteCookies(url: String?, domain: String?, path: String?, result: MethodChannel.Result) {
        val cookiesString: String? = cookieManager.getCookie(url)
        val cookies = cookiesString?.split(";") ?: listOf()
        for (cookie in cookies) {
            val nameValue = cookie.split(Regex("="), 2)
            val name = nameValue[0].trim { it <= ' ' }
            val cookieValue = "$name=; Path=$path; Domain=$domain; Max-Age=-1;"
            cookieManager.setCookie(url, cookieValue, null)
        }
        cookieManager.flush()
        result.success(true)
    }

    private fun deleteAllCookies(result: MethodChannel.Result) {
        cookieManager.removeAllCookies { result.success(true) }
        cookieManager.flush()
    }
}