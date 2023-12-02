import 'package:camera/camera.dart';
import 'package:camera_image_method_channel/camera_image_method_channel_serialization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'example_camera_image_plugin_platform_interface.dart';

class MethodChannelExampleCameraImagePlugin
    extends ExampleCameraImagePluginPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('example_camera_image_plugin');

  /// Starts recording a video
  @override
  Future<void> startRecordingVideo() async {
    return methodChannel.invokeMethod('startRecordingVideo');
  }

  /// Stops recording a video
  ///
  /// Returns a [String] path where the resulting video is located
  @override
  Future<String?> stopRecording() async {
    return methodChannel.invokeMethod<String?>('stopRecordingVideo');
  }

  /// Appends a [CameraImage] frame to the video
  @override
  Future<void> appendCameraImageToVideo(CameraImage image) async {
    return methodChannel.invokeMethod(
      'appendCameraImageToVideo',
      image.serializedForMethodChannel(),
    );
  }
}
