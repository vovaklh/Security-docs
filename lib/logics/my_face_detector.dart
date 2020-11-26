import 'dart:io';
import 'dart:ui';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:camera/camera.dart';

class MyFaceDetector {
  FaceDetector _faceDetector;

  MyFaceDetector() {
    this._faceDetector = FirebaseVision.instance.faceDetector();
  }

  /// Return list of faces predicted from file
  Future<List<Face>> predictImageFromFile(File image) async {
    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
    List<Face> faces = await _faceDetector.processImage(visionImage);

    return faces;
  }

  /// Return list of faces predicted from CameraImage image
  Future<List<Face>> predictImageFromBytes(
    CameraImage image,
    ImageRotation rotation,
  ) async {
    FirebaseVisionImage visionImage = FirebaseVisionImage.fromBytes(
        image.planes[0].bytes, _buildMetaData(image, rotation));
    List<Face> faces = await _faceDetector.processImage(visionImage);

    return faces;
  }

  /// Build metadata of image
  FirebaseVisionImageMetadata _buildMetaData(
    CameraImage image,
    ImageRotation rotation,
  ) {
    return FirebaseVisionImageMetadata(
      rawFormat: image.format.raw,
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation,
      planeData: image.planes.map(
        (Plane plane) {
          return FirebaseVisionImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList(),
    );
  }
}
