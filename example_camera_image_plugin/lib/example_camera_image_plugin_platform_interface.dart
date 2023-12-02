import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'example_camera_image_plugin_method_channel.dart';

abstract class ExampleCameraImagePluginPlatform extends PlatformInterface {
  ExampleCameraImagePluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static ExampleCameraImagePluginPlatform _instance =
      MethodChannelExampleCameraImagePlugin();

  static ExampleCameraImagePluginPlatform get instance => _instance;

  static set instance(ExampleCameraImagePluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
