import 'package:camera/camera.dart';
import 'package:collection/collection.dart';
import 'package:example_camera_image_plugin/example_camera_image_plugin.dart';
import 'package:example_camera_image_plugin_example/recording_button.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class VideoRecordingPage extends StatefulWidget {
  const VideoRecordingPage({super.key});

  @override
  State<VideoRecordingPage> createState() => _VideoRecordingPageState();
}

class _VideoRecordingPageState extends State<VideoRecordingPage> {
  /// The video recording plugin
  final _exampleCameraImagePlugin = ExampleCameraImagePlugin();

  /// The current [CameraController]
  CameraController? _cameraController;

  /// [true] if there is a video recording
  bool _isRecording = false;

  /// To avoid errors if the user mashes the [RecordingButton]
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  void _setupCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.firstWhereOrNull(
          (element) => element.lensDirection == CameraLensDirection.back,
        ) ??
        cameras.firstOrNull;

    if (camera == null) {
      return;
    }

    final cameraController = CameraController(camera, ResolutionPreset.max);
    await cameraController.initialize();

    if (!mounted) {
      return;
    }

    setState(() {
      _cameraController = cameraController;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: _buildCameraPreviewOrBlankBoxIfNoCamera(context),
        ),
        Positioned.fill(
          child: SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox.square(
                  dimension: 80,
                  child: RecordingButton(
                    isRecording: _isRecording,
                    onPressed: () async {
                      if (_isRecording) {
                        final xFile = await _stopRecording();
                        if (context.mounted && xFile != null) {
                          final box = context.findRenderObject() as RenderBox?;
                          Share.shareXFiles(
                            [xFile],
                            sharePositionOrigin:
                                box!.localToGlobal(Offset.zero) & box.size,
                          );
                        }
                      } else {
                        _startRecording();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCameraPreviewOrBlankBoxIfNoCamera(BuildContext context) {
    if (_cameraController == null) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(
          child: SizedBox.square(
            dimension: 40,
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      final scale = 1 /
          (_cameraController!.value.aspectRatio *
              MediaQuery.of(context).size.aspectRatio);
      return Transform.scale(
        scale: scale,
        alignment: Alignment.topCenter,
        child: _cameraController!.buildPreview(),
      );
    }
  }

  void _startRecording() async {
    if (_busy) return;
    _busy = true;

    await _exampleCameraImagePlugin.startRecordingVideo();
    await _cameraController!.startImageStream(_handleCameraImage);

    setState(() {
      _isRecording = true;
    });
    _busy = false;
  }

  Future<XFile?> _stopRecording() async {
    if (_busy) return null;
    _busy = true;

    final resultPath = await _exampleCameraImagePlugin.stopRecording();
    await _cameraController!.stopImageStream();

    setState(() {
      _isRecording = false;
    });
    _busy = false;

    await Future.delayed(const Duration(seconds: 1));

    if (resultPath == null) {
      return null;
    }

    final xFile = XFile(resultPath);
    return xFile;
  }

  void _handleCameraImage(CameraImage cameraImage) {
    _exampleCameraImagePlugin.appendCameraImageToVideo(cameraImage);
  }
}
