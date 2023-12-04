import AVFoundation
import Flutter
import UIKit

public class FlutterCameraImageHelper {
    
    public static func cvPixelBufferFrom(cameraImageDictionary dictionary: Dictionary<String, Any>) -> CVPixelBuffer? {
        guard let planes = dictionary["planes"] as? Array<Dictionary<String, Any>>,
              let width = (dictionary["width"] as? NSNumber)?.int32Value,
              let height = (dictionary["height"] as? NSNumber)?.int32Value,
              let format = dictionary["format"] as? UInt32 else {
            return nil
        }
        
        // Get the image data. On iOS-Flutter, the images are not planar, but the Flutter API is planar
        guard let planeDictionary = planes.first,
              var imageData = (planeDictionary["bytes"] as? FlutterStandardTypedData)?.data,
              let bytesPerRow = (planeDictionary["bytesPerRow"] as? NSNumber)?.int32Value else {
            return nil
        }
        
        var pixelBuffer: CVPixelBuffer?
        
        imageData.withUnsafeMutableBytes { (existingPixelBufferPointer: UnsafeMutableRawBufferPointer) in
            guard let baseAddress = existingPixelBufferPointer.baseAddress else { return }
            
            let status = CVPixelBufferCreateWithBytes(kCFAllocatorDefault,
                                                      Int(width),
                                                      Int(height),
                                                      format,
                                                      baseAddress,
                                                      Int(bytesPerRow),
                                                      nil,
                                                      nil,
                                                      nil,
                                                      &pixelBuffer)
            
            if status != kCVReturnSuccess {
                debugPrint("FHVitalsSDKFlutterPlugin: Could not successfully create CVPixelBuffer")
            }
            
            if let pixelBuffer = pixelBuffer {
                CVPixelBufferUnlockBaseAddress(pixelBuffer, [])
            } else {
                debugPrint("FHVitalsSDKFlutterPlugin: Could not successfully create CVPixelBuffer, status \(status)")
            }
        }
        
        return pixelBuffer
    }
    
    public static func ciImageFrom(cameraImageDictionary dictionary: Dictionary<String, Any>) -> CIImage? {
        guard let cvPixelBuffer = cvPixelBufferFrom(cameraImageDictionary: dictionary) else {
            return nil
        }
        
        return CIImage(cvPixelBuffer: cvPixelBuffer)
    }
    
    public static func cgImageFrom(cameraImageDictionary dictionary: Dictionary<String, Any>) -> CGImage? {
        guard let ciImage = ciImageFrom(cameraImageDictionary: dictionary) else {
            return nil
        }
        
        let ciContext = CIContext()
        return ciContext.createCGImage(ciImage, from: ciImage.extent)
    }
    
    public static func uiImageFrom(cameraImageDictionary dictionary: Dictionary<String, Any>) -> UIImage? {
        guard let cgImage = cgImageFrom(cameraImageDictionary: dictionary) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
}
