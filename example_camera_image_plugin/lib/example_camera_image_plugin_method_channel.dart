import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'example_camera_image_plugin_platform_interface.dart';

class MethodChannelExampleCameraImagePlugin
    extends ExampleCameraImagePluginPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('example_camera_image_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
