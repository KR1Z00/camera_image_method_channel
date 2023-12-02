import 'package:camera/camera.dart';

extension CameraImageMethodChannelSerialization on CameraImage {
  Map serializedForMethodChannel() {
    return {
      "format": format.raw,
      "width": width,
      "height": height,
      "planes":
          planes.map((plane) => plane.serializedForMethodChannel()).toList(),
    };
  }
}

extension CameraImagePlaneMethodChannelSerialization on Plane {
  Map serializedForMethodChannel() {
    return {
      "bytes": bytes,
      "bytesPerPixel": bytesPerPixel,
      "bytesPerRow": bytesPerRow,
      "width": width,
      "height": height,
    };
  }
}
