import 'dart:typed_data';
import 'package:image/image.dart' as imutils;
import 'dart:math';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

/// Convert imutils image to Float32List and normalize it
Float32List imageToByteListFloat32(
  imutils.Image image,
  int inputSize,
  double mean,
  double std,
) {
  var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
  var buffer = Float32List.view(convertedBytes.buffer);
  int pixelIndex = 0;
  for (var i = 0; i < inputSize; i++) {
    for (var j = 0; j < inputSize; j++) {
      var pixel = image.getPixel(j, i);
      buffer[pixelIndex++] = (imutils.getRed(pixel) - mean) / std;
      buffer[pixelIndex++] = (imutils.getGreen(pixel) - mean) / std;
      buffer[pixelIndex++] = (imutils.getBlue(pixel) - mean) / std;
    }
  }
  return convertedBytes.buffer.asFloat32List();
}

/// Crop the input image and rotate it if needed
imutils.Image cropFace(imutils.Image image, Face face, bool rotate) {
  if (rotate) {
    image = imutils.copyRotate(image, -90);
  }
  double x = (face.boundingBox.left - 10);
  double y = (face.boundingBox.top - 10);
  double w = (face.boundingBox.width + 10);
  double h = (face.boundingBox.height + 10);

  imutils.Image croppedFace =
      imutils.copyCrop(image, x.round(), y.round(), w.round(), h.round());

  return croppedFace;
}

/// Compute the euclidean distance between two vectors
double euclideanDistance(List e1, List e2) {
  double sum = 0.0;
  for (int i = 0; i < e1.length; i++) {
    sum += pow((e1[i] - e2[i]), 2);
  }
  return sqrt(sum);
}
