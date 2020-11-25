import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:security_docs/utils/camera_utils.dart';
import 'package:security_docs/logics/my_face_detector.dart';
import 'package:security_docs/logics/face_verificator.dart';
import 'package:image/image.dart' as imutils;
import 'package:security_docs/utils/face_utils.dart';

class CameraVerificator {
  CameraController _cameraController;
  CameraLensDirection _direction = CameraLensDirection.front;
  double _threshold = 1.0;
  bool _faceVerified = false;
  FaceVerificator _faceVerificator;

  /// Stop image streaming
  Future<void> stopVerification() async {
    if (_cameraController.value.isStreamingImages) {
      _cameraController.stopImageStream();
    }
  }

  disposeVerification() {
    _cameraController?.dispose();
    _faceVerificator?.closeInterpreter();
  }

  /// Start verifying faces and run function if face was verified
  Future<void> startDetectingAndVerifyFace(Function unlock) async {
    MyFaceDetector myFaceDetector = MyFaceDetector();
    _faceVerificator = FaceVerificator();
    await _faceVerificator.loadModel(modelPath: "models/mobilefacenet.tflite");
    List savedFace = await _faceVerificator.getFace();

    CameraDescription cameraDescription = await getCamera(_direction);
    ImageRotation rotation =
        rotationIntToImageRotation(cameraDescription.sensorOrientation);

    _cameraController = CameraController(
        cameraDescription, ResolutionPreset.low,
        enableAudio: false);
    await _cameraController.initialize();
    _cameraController.startImageStream((CameraImage image) async {
      if (!_faceVerified) {
        myFaceDetector.predictImageFromBytes(image, rotation).then((faces) {
          if (faces.length == 1) {
            imutils.Image face = convertCameraImage(image, _direction);
            face = cropFace(face, faces.first, false);
            List faceVector = _faceVerificator.getOutput(face);
            if (_faceVerificator.sameFaces(
                savedFace: savedFace,
                scannedFace: faceVector,
                threshold: _threshold)) {
              _faceVerified = true;
            }
          }
        });
      } else {
        if (_cameraController.value.isStreamingImages) {
          _cameraController.stopImageStream();
          await unlock();
        }
      }
    });
  }
}
