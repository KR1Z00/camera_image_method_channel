import 'package:flutter_test/flutter_test.dart';
import 'package:example_camera_image_plugin/example_camera_image_plugin.dart';
import 'package:example_camera_image_plugin/example_camera_image_plugin_platform_interface.dart';
import 'package:example_camera_image_plugin/example_camera_image_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockExampleCameraImagePluginPlatform
    with MockPlatformInterfaceMixin
    implements ExampleCameraImagePluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ExampleCameraImagePluginPlatform initialPlatform = ExampleCameraImagePluginPlatform.instance;

  test('$MethodChannelExampleCameraImagePlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelExampleCameraImagePlugin>());
  });

  test('getPlatformVersion', () async {
    ExampleCameraImagePlugin exampleCameraImagePlugin = ExampleCameraImagePlugin();
    MockExampleCameraImagePluginPlatform fakePlatform = MockExampleCameraImagePluginPlatform();
    ExampleCameraImagePluginPlatform.instance = fakePlatform;

    expect(await exampleCameraImagePlugin.getPlatformVersion(), '42');
  });
}
