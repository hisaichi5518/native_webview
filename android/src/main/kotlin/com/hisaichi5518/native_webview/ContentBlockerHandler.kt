package com.hisaichi5518.native_webview

import android.net.Uri
import android.os.Looper
import android.util.Log
import android.webkit.WebResourceResponse
import android.webkit.WebView
import java.net.URI
import java.util.concurrent.CopyOnWriteArrayList
import java.util.concurrent.CountDownLatch
import java.util.logging.Handler
import java.util.regex.Pattern


class ContentBlocker(val trigger: ContentBlockerTrigger, val action: ContentBlockerAction) {
    companion object {
        fun fromMap(map: Map<String, Map<String?, Any?>>): ContentBlocker {
            val trigger = map["trigger"] as Map<String?, Any?>
            val action = map["action"] as Map<String?, Any?>

            return ContentBlocker(
                ContentBlockerTrigger.fromMap(trigger),
                ContentBlockerAction.fromMap(action)
            )
        }
    }
}


class ContentBlockerAction(val type: ContentBlockerActionType, val selector: String?) {
    companion object {
        fun fromMap(map: Map<String?, Any?>): ContentBlockerAction {
            val typeString = map["type"] as String
            val type = ContentBlockerActionType.fromValue(typeString)
            val selector = map["selector"] as String?
            return ContentBlockerAction(type, selector)
        }
    }

    init {
        if (this.type == ContentBlockerActionType.CSS_DISPLAY_NONE) {
            assert(selector != null)
        }
    }
}

enum class ContentBlockerActionType(private val value: String) {
    BLOCK("block"),
    CSS_DISPLAY_NONE("css-display-none"),
    MAKE_HTTPS("make-https");

    fun equalsValue(otherValue: String): Boolean {
        return value == otherValue
    }

    override fun toString(): String {
        return value
    }

    companion object {
        fun fromValue(value: String): ContentBlockerActionType {
            for (type in values()) {
                if (value == type.value) return type
            }
            throw IllegalArgumentException("No enum constant: $value")
        }
    }
}

class ContentBlockerTrigger(
    urlFilter: String,
    val urlFilterIsCaseSensitive: Boolean = false,
    val resourceType: MutableList<ContentBlockerTriggerResourceType> = mutableListOf(),
    val ifDomain: List<String> = listOf(),
    val unlessDomain: List<String> = listOf(),
    val loadType: List<String> = listOf(),
    val ifTopUrl: List<String> = listOf(),
    val unlessTopUrl: List<String> = listOf()
) {
    val urlFilterPatternCompiled: Pattern = Pattern.compile(urlFilter)

    companion object {
        fun fromMap(map: Map<String?, Any?>): ContentBlockerTrigger {
            val urlFilter = map["url-filter"] as String
            val urlFilterIsCaseSensitive = map["url-filter-is-case-sensitive"] as Boolean? ?: false
            val resourceTypeStringList = map["resource-type"] as List<String>? ?: listOf()
            val resourceType: MutableList<ContentBlockerTriggerResourceType> = mutableListOf()
            for (type in resourceTypeStringList) {
                resourceType.add(ContentBlockerTriggerResourceType.fromValue(type))
            }
            val ifDomain = map["if-domain"] as List<String>? ?: listOf()
            val unlessDomain = map["unless-domain"] as List<String>? ?: listOf()
            val loadType = map["load-type"] as List<String>? ?: listOf()
            val ifTopUrl = map["if-top-url"] as List<String>? ?: listOf()
            val unlessTopUrl = map["unless-top-url"] as List<String>? ?: listOf()
            return ContentBlockerTrigger(
                urlFilter,
                urlFilterIsCaseSensitive,
                resourceType,
                ifDomain,
                unlessDomain,
                loadType,
                ifTopUrl,
                unlessTopUrl
            )
        }
    }

    init {
        if (!(this.ifDomain.isEmpty() || this.unlessDomain.isEmpty()) || this.loadType.size > 2 || !(this.ifTopUrl.isEmpty() || this.unlessTopUrl.isEmpty())) {
            throw AssertionError()
        }
    }
}

enum class ContentBlockerTriggerResourceType(private val value: String) {
    DOCUMENT("document"),
    IMAGE("image"),
    STYLE_SHEET("style-sheet"),
    SCRIPT("script"),
    FONT("font"),
    SVG_DOCUMENT("svg-document"),
    MEDIA("media"),
    POPUP("popup"),
    RAW("raw");

    fun equalsValue(otherValue: String): Boolean {
        return value == otherValue
    }

    override fun toString(): String {
        return value
    }

    companion object {
        fun fromValue(value: String): ContentBlockerTriggerResourceType {
            for (type in values()) {
                if (value == type.value) return type
            }
            throw java.lang.IllegalArgumentException("No enum constant: $value")
        }
    }

}
class ContentBlockerHandler(val ruleList: List<ContentBlocker>) {
    fun handleURL(view: WebView, url: Uri): WebResourceResponse? {
        val host = url.host ?: ""
        val port = url.port
        val scheme = url.scheme
        // thread safe copy list
        val ruleListCopy: List<ContentBlocker> = CopyOnWriteArrayList(ruleList)

        for (contentBlocker in ruleListCopy) {
            val trigger  = contentBlocker.trigger
            val resourceTypes = trigger.resourceType
            if (resourceTypes.contains(ContentBlockerTriggerResourceType.IMAGE) && !resourceTypes.contains(ContentBlockerTriggerResourceType.SVG_DOCUMENT)) {
                resourceTypes.add(ContentBlockerTriggerResourceType.SVG_DOCUMENT)
            }
            val action = contentBlocker.action
            val matcher = trigger.urlFilterPatternCompiled.matcher(url.toString())
            if (!matcher.matches()) {
                continue
            }

            if (trigger.ifDomain.isNotEmpty()) {
                var matched = false
                for (domain in trigger.ifDomain) {
                    if ((domain.startsWith("*") && host.endsWith(domain.replace("*", ""))) || domain == host) {
                        matched = true
                        break
                    }
                }
                if (!matched) {
                    return null
                }
            }
            if (trigger.unlessDomain.isNotEmpty()) {
                for (domain in trigger.unlessDomain) {
                    if ((domain.startsWith("*") && host.endsWith(domain.replace("*", ""))) || domain == host) {
                        return null
                    }
                }
            }

            // WebView methods need to be called in MainThread.
            val webViewUrl = arrayOfNulls<String>(1)
            if (trigger.loadType.isNotEmpty() || trigger.ifTopUrl.isNotEmpty() || trigger.unlessTopUrl.isNotEmpty()) {
                val latch = CountDownLatch(1)
                val handler = android.os.Handler(Looper.getMainLooper())
                handler.post {
                    webViewUrl[0] = view.url
                    latch.countDown()
                }
                latch.await()
            }
            if (trigger.loadType.isNotEmpty()) {
                val viewUrl = webViewUrl[0] ?: ""
                val cUrl = URI(viewUrl)
                val cHost = cUrl.host
                val cPort = cUrl.port
                val cScheme = cUrl.scheme
                if (trigger.loadType.contains("first-party") && !(cScheme == scheme && cHost == host && cPort == port) || trigger.loadType.contains("third-party") && cHost == host) {
                    return null
                }
            }
            if (trigger.ifTopUrl.isNotEmpty()) {
                var matchFound = false
                val viewUrl = webViewUrl[0] ?: ""
                for (topUrl in trigger.ifTopUrl) {
                    if (viewUrl.startsWith(topUrl)) {
                        matchFound = true
                        break
                    }
                }
                if (!matchFound) {
                    return null
                }
            }
            if (trigger.unlessTopUrl.isNotEmpty()) {
                val viewUrl = webViewUrl[0] ?: ""
                for (topUrl in trigger.unlessTopUrl) {
                    if (viewUrl.startsWith(topUrl)) {
                        return null
                    }
                }
            }

            when (action.type) {
                ContentBlockerActionType.BLOCK -> {
                    return WebResourceResponse("", "", null)
                }
                ContentBlockerActionType.CSS_DISPLAY_NONE -> {
                    Log.e("NativeWebView", "CSS_DISPLAY_NONE is not supported on Android.")
                }
                ContentBlockerActionType.MAKE_HTTPS -> {
                    Log.e("NativeWebView", "MAKE_HTTPS is not supported on Android.")
                }
            }
        }

        return null
    }
}