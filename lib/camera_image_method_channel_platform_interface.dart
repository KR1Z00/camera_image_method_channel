import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'camera_image_method_channel_method_channel.dart';

abstract class CameraImageMethodChannelPlatform extends PlatformInterface {
  /// Constructs a CameraImageMethodChannelPlatform.
  CameraImageMethodChannelPlatform() : super(token: _token);

  static final Object _token = Object();

  static CameraImageMethodChannelPlatform _instance = MethodChannelCameraImageMethodChannel();

  /// The default instance of [CameraImageMethodChannelPlatform] to use.
  ///
  /// Defaults to [MethodChannelCameraImageMethodChannel].
  static CameraImageMethodChannelPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CameraImageMethodChannelPlatform] when
  /// they register themselves.
  static set instance(CameraImageMethodChannelPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
