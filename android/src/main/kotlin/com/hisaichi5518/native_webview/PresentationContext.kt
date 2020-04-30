package com.hisaichi5518.native_webview

import android.app.Activity
import android.app.AlertDialog
import android.content.Context
import android.content.ContextWrapper

class PresentationContext(
    base: Context?,
    private val activity: Activity
) : ContextWrapper(base) {

    private val isCalledFromAlertDialog: Boolean
        get() {
            val stackTraceElements = Thread.currentThread().stackTrace
            var i = 0
            while (i < stackTraceElements.size && i < 11) {
                if (stackTraceElements[i].className == AlertDialog::class.java.canonicalName && stackTraceElements[i].methodName == "<init>") {
                    return true
                }
                i++
            }
            return false
        }

    override fun getSystemService(name: String): Any? {
        return if (isCalledFromAlertDialog) {
            // Alert dialogs are showing on top of the entire application and should not be limited to
            // the virtual
            // display. If we detect that an android.app.AlertDialog constructor is what's fetching
            // the window manager
            // we return the one for the application's window.
            //
            // Note that if we don't do this AlertDialog will throw a ClassCastException as down the
            // line it tries
            // to case this instance to a WindowManagerImpl which the object returned by
            // getWindowManager is not
            // a subclass of.
            activity.getSystemService(name)
        } else {
            super.getSystemService(name)
        }
    }
}