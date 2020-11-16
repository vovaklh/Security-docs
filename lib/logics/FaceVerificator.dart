import 'dart:io';
import 'package:image/image.dart' as imutils;
import 'package:security_docs/utils/faceUtils.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tf;
import 'package:security_docs/utils/fileUtils.dart';

class FaceVerificator {
  tf.Interpreter _interpreter;
  int _size;
  double _mean;
  double _std;

  FaceVerificator(int size, double mean, double std) {
    this._size = size;
    this._mean = mean;
    this._std = std;
  }

  // Load model with delegate
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

  // Return output of facenet model
  List<dynamic> getOutput(imutils.Image face) {
    // Resize face to 112 height and with
    face = imutils.copyResizeCropSquare(face, 112);

    //Reshape image
    List input = imageToByteListFloat32(face, _size, _mean, _std);
    input = input.reshape([1, _size, _size, 3]);

    //Creating list for otput
    List output = List(1 * 192).reshape([1, 192]);
    this._interpreter.run(input, output);

    //Reshape otput
    output = output.reshape([192]);

    return output;
  }

  // Save encoded vector as String to txt file
  void saveArrayToFile(List vector) async {
    String path = await getLocalPath();

    File(path + "/" + "face.txt").writeAsStringSync(vector.toString());
  }

  // Check if encoded face exist if directory
  Future<bool> checkIfFaceExist() async {
    String path = await getLocalPath();

    return File(path + "/" + "face.txt").existsSync();
  }

  // Return decoded face from file
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

  // Return true if euclidean distance between faces is smaller than threshold
  bool sameFaces({List savedFace, List scannedFace, double threshold}) {
    double facesDistance = euclideanDistance(savedFace, scannedFace);

    return facesDistance < threshold;
  }

  // Close tflite interpreter
  void closeInterpreter() {
    this._interpreter.close();
  }
}
