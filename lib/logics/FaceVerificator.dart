import 'dart:io';
import 'package:image/image.dart' as imutils;
import 'package:security_docs/logics/faceUtils.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tf;
import 'package:security_docs/logics/fileUtils.dart';

class FaceVerificator{

  tf.Interpreter interpreter;
  int size;
  double mean;
  double std;

  FaceVerificator(int size, double mean, double std){
    this.size = size;
    this.mean = mean;
    this.std = std;
  }

  loadModel({String modelPath}) async {
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
      this.interpreter = await tf.Interpreter.fromAsset(modelPath,
          options: interpreterOptions);
    } on Exception {
      print('Failed to load model.');
    }
  }


  Future<List<dynamic>> getOutput(String modelPath,  imutils.Image face) async{
      // Load model
      await loadModel(modelPath: modelPath);

      // Resize face to 112 height and with
      face = imutils.copyResizeCropSquare(face, 112);

      //Reshape image
      List input = imageToByteListFloat32(face, size, mean, std);
      input = input.reshape([1, size, size, 3]);

      //Creating list for otput
      List output = List(1 * 192).reshape([1, 192]);
      this.interpreter.run(input, output);

      //Reshape otput
      output = output.reshape([192]);

      return output;
  }

  void saveArrayToFile(List<dynamic> vector) async {
    String path = await getLocalPath();

    File(path + "/" + "face.txt").writeAsStringSync(vector.toString());
  }

  Future<bool> checkIfFaceExist() async{
    String path = await getLocalPath();

    return File(path + "/" + "face.txt").existsSync();
  }

}