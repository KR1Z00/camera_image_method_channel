
import 'camera_image_method_channel_platform_interface.dart';

class CameraImageMethodChannel {
  Future<String?> getPlatformVersion() {
    return CameraImageMethodChannelPlatform.instance.getPlatformVersion();
  }
}
