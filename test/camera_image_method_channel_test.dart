import 'package:flutter_test/flutter_test.dart';
import 'package:camera_image_method_channel/camera_image_method_channel.dart';
import 'package:camera_image_method_channel/camera_image_method_channel_platform_interface.dart';
import 'package:camera_image_method_channel/camera_image_method_channel_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCameraImageMethodChannelPlatform
    with MockPlatformInterfaceMixin
    implements CameraImageMethodChannelPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final CameraImageMethodChannelPlatform initialPlatform = CameraImageMethodChannelPlatform.instance;

  test('$MethodChannelCameraImageMethodChannel is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCameraImageMethodChannel>());
  });

  test('getPlatformVersion', () async {
    CameraImageMethodChannel cameraImageMethodChannelPlugin = CameraImageMethodChannel();
    MockCameraImageMethodChannelPlatform fakePlatform = MockCameraImageMethodChannelPlatform();
    CameraImageMethodChannelPlatform.instance = fakePlatform;

    expect(await cameraImageMethodChannelPlugin.getPlatformVersion(), '42');
  });
}
