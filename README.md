# camera_image_method_channel

A Flutter plugin that provides support for other Flutter `MethodChannel` plugins to process a `CameraImage` received from the `camera` package, to perform custom modifications to the pixel buffer.

## Getting Started

1. Add this plugin as a dependency in the `pubspec.yaml` of the flutter plugin

```
    dependencies:
        camera_image_method_channel: ^0.1.0
```

2. Create methods in your `PlatformInterface` that will process a Flutter `CameraImage`, for example:

```
abstract class MyVideoRecorderPluginPlatform extends PlatformInterface {

    ...

    Future<void> appendCameraImageToVideo(CameraImage image);

}
```

3. In the `MethodChannel` implementation for your `PlatformInterface`, serialize the `CameraImage` using the `CameraImagePlatformSerialization` extension

```
class MethodChannelMyVideoRecorderPlugin
    extends MyVideoRecorderPluginPlatform {
    @visibleForTesting
    final methodChannel = const MethodChannel('my_video_recorder_plugin');

    @override
    Future<void> appendCameraImageToVideo(CameraImage image) async {
        await methodChannel.invokeMethod('appendCameraImageToVideo', image.serializedForMethodChannel());
    }
}

```

### For the iOS plugin implementation

- In the handler function for the method that processes a `CameraImage`, use the `FlutterCameraImageHelper` to convert the serialized arguments from a `Dictionary<String, Any>`, to either a `CVPixelBuffer`, `UIImage`, `CGImage`, or `CIImage`.

```
public class MyVideoRecorderPlugin: NSObject, FlutterPlugin {

    ...

    private func handleAppendCameraImageToVideo(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let dictionary = call.arguments as? Dictionary<String, Any>,
              let uiImage = FlutterCameraImageHelper.methodChannelDictionaryToUIImage(dictionary) else {
            result(FlutterError(code: "INVALID_ARGUMENTS",
                                message: "The arguments passed were invalid",
                                details: details))
            return
        }

    }
}
```

### For the Android plugin implementation

- In the handler function for the method that processes a `CameraImage`, use the `FlutterCameraImageHelper` to convert the serialized arguments from a `Dictionary<String, Any>`, to a `Bitmap`.

TODO: Add Android example