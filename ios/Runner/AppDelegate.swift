import UIKit
import Flutter
import NaverThirdPartyLogin

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if let url = launchOptions?[.url] as? URL, url.absoluteString.contains("kakao"){
      super.application(application, didFinishLaunchingWithOptions: launchOptions)
      return true
    } else if let url = launchOptions?[.url] as? URL, url.absoluteString.contains("naverlogin") {
        NaverThirdPartyLoginConnection.getSharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    } else {
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions) 
    }
  }
}
