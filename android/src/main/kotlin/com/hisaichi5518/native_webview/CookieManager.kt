package com.hisaichi5518.native_webview

import android.webkit.CookieManager
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import java.text.SimpleDateFormat
import java.util.*
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
                val expiresDateString = call.argument<String>("expiresDate")
                val expiresDate = expiresDateString?.toLong()
                val maxAge = call.argument<Int>("maxAge")
                val isSecure = call.argument<Boolean>("isSecure")
                setCookie(url, name, value, domain, path, expiresDate, maxAge, isSecure, result)
            }
            "getCookies" -> result.success(getCookies(call.argument<String>("url")))
            "deleteCookie" -> {
                val url = call.argument<String>("url")
                val name = call.argument<String>("name")
                val domain = call.argument<String>("domain")
                val path = call.argument<String>("path")
                deleteCookie(url, name, domain, path, result)
            }
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
        expiresDate: Long?,
        maxAge: Int?,
        isSecure: Boolean?,
        result: MethodChannel.Result
    ) {
        var cookieValue = "$name=$value; Domain=$domain; Path=$path"
        if (expiresDate != null) cookieValue += "; Expires=" + getCookieExpirationDate(expiresDate)
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

    private fun deleteCookie(url: String?, name: String?, domain: String?, path: String?, result: MethodChannel.Result) {
        val cookieValue = "$name=; Path=$path; Domain=$domain; Max-Age=-1;"
        cookieManager.setCookie(url, cookieValue) { result.success(true) }
        cookieManager.flush()
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

    private fun getCookieExpirationDate(timestamp: Long): String {
        val sdf = SimpleDateFormat("EEE, d MMM yyyy hh:mm:ss z")
        sdf.timeZone = TimeZone.getTimeZone("GMT")
        return sdf.format(Date(timestamp))
    }
}