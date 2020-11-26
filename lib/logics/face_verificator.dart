import 'dart:io';
import 'package:image/image.dart' as imutils;
import 'package:security_docs/utils/face_utils.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tf;
import 'package:security_docs/utils/file_utils.dart';

class FaceVerificator {
  tf.Interpreter _interpreter;
  int _size;
  int _outShape;
  double _mean;
  double _std;

  FaceVerificator({
    int size = 112,
    double mean = 128,
    double std = 128,
    int outShape = 192,
  }) {
    this._size = size;
    this._mean = mean;
    this._std = std;
    this._outShape = outShape;
  }

  /// Load model from assets
  Future<bool> loadModel({String modelPath}) async {
    try {
      final gpuDelegateV2 = tf.GpuDelegateV2(
          options: tf.GpuDelegateOptionsV2(
        false,
        tf.TfLiteGpuInferenceUsage.fastSingleAnswer,
        tf.TfLiteGpuInferencePriority.minLatency,
        tf.TfLiteGpuInferencePriority.auto,
        tf.TfLiteGpuInferencePriority.auto,
      ));

      tf.InterpreterOptions interpreterOptions = tf.InterpreterOptions()
        ..addDelegate(gpuDelegateV2);
      this._interpreter = await tf.Interpreter.fromAsset(modelPath,
          options: interpreterOptions);
    } on Exception {
      print('Failed to load model.');
    }
  }

  /// Take the image and return the output of facenet model
  List<dynamic> getOutput(imutils.Image face) {
    face = imutils.copyResizeCropSquare(face, _size);

    List input = imageToByteListFloat32(face, _size, _mean, _std);
    input = input.reshape([1, _size, _size, 3]);

    List output = List(1 * _outShape).reshape([1, _outShape]);
    this._interpreter.run(input, output);

    output = output.reshape([_outShape]);
    return output;
  }

  /// Save encoded face to txt file
  void saveArrayToFile(List vector) async {
    String path = await getLocalPath();

    File(path + "/" + "face.txt").writeAsStringSync(vector.toString());
  }

  /// Check if file with face exist in local storage
  Future<bool> checkIfFaceExist() async {
    String path = await getLocalPath();

    return File(path + "/" + "face.txt").existsSync();
  }

  /// Return the encoded face
  Future<List> getFace() async {
    String path = await getLocalPath();
    List face = File(path + "/" + "face.txt")
        .readAsStringSync()
        .replaceAll(RegExp(r'[\[\]]'), '')
        .split(",")
        .map((e) => double.parse(e))
        .toList();

    return face;
  }

  /// Compute the similarity between faces
  bool sameFaces({List savedFace, List scannedFace, double threshold}) {
    double facesDistance = euclideanDistance(savedFace, scannedFace);

    return facesDistance < threshold;
  }

  /// Close tflite interpreter
  void closeInterpreter() {
    this._interpreter.close();
  }
}
