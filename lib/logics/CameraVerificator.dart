import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:security_docs/logics/cameraUtils.dart';
import 'package:security_docs/logics/MyFaceDetector.dart';
import 'package:security_docs/logics/FaceVerificator.dart';
import 'package:image/image.dart' as imutils;
import 'package:security_docs/logics/faceUtils.dart';

class CameraVerificator{
  CameraController _cameraController;
  CameraLensDirection _direction = CameraLensDirection.front;
  double _threshold = 1.0;
  bool _faceVerified = false;
  FaceVerificator _faceVerificator;

  void stopVerification(){
    if(_cameraController.value.isStreamingImages) _cameraController.stopImageStream();
  }

  disposeVerification(){
    _cameraController?.dispose();
    _faceVerificator?.closeInterpreter();
  }

  void startDetectingAndVerifyFace(BuildContext context) async{
    MyFaceDetector myFaceDetector = MyFaceDetector();
    _faceVerificator = FaceVerificator(112, 128, 128);
    await _faceVerificator.loadModel(modelPath: "models/mobilefacenet.tflite");
    List savedFace = await _faceVerificator.getFace();

    CameraDescription cameraDescription = await getCamera(_direction);
    ImageRotation rotation = rotationIntToImageRotation(cameraDescription.sensorOrientation);


    _cameraController = CameraController(cameraDescription, ResolutionPreset.low, enableAudio: false);
    await _cameraController.initialize();
    _cameraController.startImageStream((CameraImage image){
          if(!_faceVerified) {
            myFaceDetector.predictImageFromBytes(image, rotation).then((faces) {
              if(faces.length == 1){
                imutils.Image face = convertCameraImage(image, _direction);
                face = cropFace(face, faces.first, false);
                List faceVector = _faceVerificator.getOutput(face);
                if(_faceVerificator.sameFaces(savedFace : savedFace, scannedFace : faceVector, threshold : _threshold)){
                  _faceVerified = true;
                  Navigator.pushReplacementNamed(context, "/homepage"); // Show page with user files
                }
              }
            });
          }
          else{
            stopVerification();
          }
    });
  }
}