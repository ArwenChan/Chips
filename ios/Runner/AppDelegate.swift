import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // let eventChannelName = "clipboardChangeStream"
    // let handler = ClipboardHandler()
    // let rootViewController : FlutterViewController = window?.rootViewController as! FlutterViewController
    // let eventChannel = FlutterEventChannel(name: eventChannelName, binaryMessenger: rootViewController.binaryMessenger)
    // eventChannel.setStreamHandler(handler)    
    // NSLog("userActivity :\(userActivity.webpageURL.description)")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// class ClipboardHandler: NSObject, FlutterStreamHandler {
//   private var _eventSink: FlutterEventSink?

//   func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
//     print("on listen")
//     _eventSink = events
//     NotificationCenter.default.addObserver(self, selector: #selector(clipboardChanged),
//                           name: UIPasteboard.changedNotification, object: nil)
//     return nil
//   }

//   func onCancel(withArguments arguments: Any?) -> FlutterError? {
//     print("on cancel")
//     _eventSink = nil
//     return nil
//   }

//   @objc func clipboardChanged(){
//     let pasteboardString: String? = UIPasteboard.general.string
//     if let theString = pasteboardString {
//         print("String is \(theString)")
//         // Do cool things with the string
//         // _eventSink(theString ?? "")
//     }
//   }
// }
