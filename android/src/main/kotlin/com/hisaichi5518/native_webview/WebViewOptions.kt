package com.hisaichi5518.native_webview

data class WebViewOptions(val hasShouldOverrideUrlLoading: Boolean, val contentBlockers: List<Map<String, Map<String?, Any?>>>)