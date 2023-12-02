import AVFoundation
import camera_image_method_channel
import Flutter
import UIKit

public class ExampleCameraImagePlugin: NSObject, FlutterPlugin {
    
    private let dispatchQueue = DispatchQueue(label: "nz.jamiewalker.example.camera_image_plugin", qos: .userInitiated)
    private let videoRecorder = VideoRecorder()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "example_camera_image_plugin", binaryMessenger: registrar.messenger())
        let instance = ExampleCameraImagePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "startRecordingVideo":
            handleStartRecordingVideo(call, result: result)
        case "stopRecordingVideo":
            handleStopRecordingVideo(call, result: result)
        case "appendCameraImageToVideo":
            handleAppendCameraImageToVideo(call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func handleStartRecordingVideo(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let url = URL.randomTemporaryFileUrl(withExtension: "mp4")
        
        do {
            try videoRecorder.prepareToRecord(toURL: url)
            try videoRecorder.startRecording()
        } catch {
            result(FlutterError())
        }
        
        result(nil)
    }
    
    private func handleStopRecordingVideo(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        dispatchQueue.async {
            self.videoRecorder.stopRecording { url in
                DispatchQueue.main.async {
                    result(url.relativePath)
                }
            }
        }
    }
    
    private func handleAppendCameraImageToVideo(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let dictionary = call.arguments as? Dictionary<String, Any> else {
            result(FlutterError())
            return
        }
        
        dispatchQueue.async {
            if let pixelBuffer = FlutterCameraImageHelper.cvPixelBufferFrom(cameraImageDictionary: dictionary) {
                try? self.videoRecorder.appendPixelBuffer(pixelBuffer)
            }
        }
        
        result(nil)
    }
    
}
