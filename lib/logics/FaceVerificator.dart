import 'package:image/image.dart' as imutils;
import 'package:security_docs/logics/faceUtils.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tf;

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


  void getOutput(String modelPath,  imutils.Image face) async{
      await loadModel(modelPath: modelPath);

      List input = imageToByteListFloat32(face, size, mean, std);
      input = input.reshape([1, size, size, 3]);

      List output = List(1 * 192).reshape([1, 192]);
      this.interpreter.run(input, output);

      output = output.reshape([192]);

      print(output);
  }

}