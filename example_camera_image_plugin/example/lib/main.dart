import 'package:example_camera_image_plugin_example/video_recording_page.dart';
import 'package:flutter/material.dart';

import 'package:example_camera_image_plugin/example_camera_image_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: VideoRecordingPage(),
      ),
    );
  }
}
