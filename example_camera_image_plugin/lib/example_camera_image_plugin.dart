import 'example_camera_image_plugin_platform_interface.dart';

class ExampleCameraImagePlugin {
  Future<String?> getPlatformVersion() {
    return ExampleCameraImagePluginPlatform.instance.getPlatformVersion();
  }
}
