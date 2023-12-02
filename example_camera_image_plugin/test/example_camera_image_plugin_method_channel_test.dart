import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example_camera_image_plugin/example_camera_image_plugin_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelExampleCameraImagePlugin platform = MethodChannelExampleCameraImagePlugin();
  const MethodChannel channel = MethodChannel('example_camera_image_plugin');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
