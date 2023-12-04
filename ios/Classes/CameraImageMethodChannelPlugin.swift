import Flutter
import UIKit

/// This is a dummy FlutterPlugin
public class CameraImageMethodChannelPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "camera_image_method_channel", binaryMessenger: registrar.messenger())
        let instance = CameraImageMethodChannelPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(nil)
    }
    
}
