import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'camera_image_method_channel_platform_interface.dart';

/// An implementation of [CameraImageMethodChannelPlatform] that uses method channels.
class MethodChannelCameraImageMethodChannel extends CameraImageMethodChannelPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('camera_image_method_channel');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
