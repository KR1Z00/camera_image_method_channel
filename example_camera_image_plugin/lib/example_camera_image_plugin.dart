import 'package:camera/camera.dart';

import 'example_camera_image_plugin_platform_interface.dart';

class ExampleCameraImagePlugin {
  /// Starts recording a video
  Future<void> startRecordingVideo() {
    return ExampleCameraImagePluginPlatform.instance.startRecordingVideo();
  }

  /// Stops recording a video
  ///
  /// Returns a [String] path where the resulting video is located
  Future<String?> stopRecording() {
    return ExampleCameraImagePluginPlatform.instance.stopRecording();
  }

  /// Appends a [CameraImage] frame to the video
  Future<void> appendCameraImageToVideo(CameraImage image) {
    return ExampleCameraImagePluginPlatform.instance.appendCameraImageToVideo(
      image,
    );
  }
}
