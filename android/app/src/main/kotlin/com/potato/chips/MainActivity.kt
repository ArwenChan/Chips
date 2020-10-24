package com.potato.chips

import android.os.Bundle
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import android.content.ClipboardManager
import android.content.Context
import android.os.Handler

class MainActivity: FlutterActivity() {
  // protected lateinit var clipboardManager: ClipboardManager
  // protected lateinit var clipboardListener: ClipboardManager.OnPrimaryClipChangedListener

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);
  }

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    // clipboardManager = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
    // val eventChannel = EventChannel(this.getFlutterEngine()!!.getDartExecutor().getBinaryMessenger(), "clipboardChangeStream")
    // eventChannel.setStreamHandler(object: EventChannel.StreamHandler {
    //     override fun onListen(p0: Any?, p1: EventChannel.EventSink) { 
    //       clipboardListener = object : ClipboardManager.OnPrimaryClipChangedListener {
    //         override fun onPrimaryClipChanged() {
    //           clipboardManager.removePrimaryClipChangedListener(clipboardListener);
    //           val handler = Handler();
    //           handler.postDelayed({
    //             clipboardManager.addPrimaryClipChangedListener(clipboardListener);
    //           }, 500);
    //           p1.success(clipboardManager.getText())
    //         }
    //       }
    //       clipboardManager.addPrimaryClipChangedListener(clipboardListener)
    //     }
      
    //     override fun onCancel(p0: Any) {
    //       clipboardManager.removePrimaryClipChangedListener(clipboardListener);
    //     }
    // })
  }

}
