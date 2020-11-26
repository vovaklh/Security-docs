import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image/image.dart' as imutils;
import 'package:security_docs/logics/face_verificator.dart';
import 'package:security_docs/utils/face_utils.dart';
import 'package:security_docs/logics/my_face_detector.dart';
import 'package:security_docs/resources/strings.dart';

class FacePage extends StatefulWidget {
  @override
  _FacePageState createState() => _FacePageState();
}

class _FacePageState extends State<FacePage> {
  Image _face;
  String _text = FacePageStrings.initialMessage;

  /// Set status of face detection(no face detected, too many...)
  void _setStatus(String text) {
    setState(() {
      this._text = text;
    });
  }

  /// Set state of face page to default
  void _setButtonToDefault() {
    setState(() {
      this._face == null;
      this._text = FacePageStrings.initialMessage;
    });
  }

  /// Encode detected face and save to file
  Future<void> _encodeFace(imutils.Image face) async {
    FaceVerificator faceVerificator = FaceVerificator();
    await faceVerificator.loadModel(modelPath: FacePageStrings.pathToModel);
    List faceVector = faceVerificator.getOutput(face);
    faceVerificator.saveArrayToFile(faceVector);
    faceVerificator.closeInterpreter();
  }

  /// Detect faces in chosen image
  Future<void> _detectFaces() async {
    _setStatus(FacePageStrings.imageSelected);

    File image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
    MyFaceDetector myFaceDetector = MyFaceDetector();
    List<Face> faces = await myFaceDetector.predictImageFromFile(image);

    if (faces.length == 0) {
      _setStatus(FacePageStrings.noFaces);
    } else if (faces.length > 1) {
      _setStatus(FacePageStrings.manyFaces);
    } else {
      imutils.Image croppedFace = cropFace(
          imutils.decodeImage(image.readAsBytesSync()), faces.first, true);

      setState(() {
        this._face = Image.memory(imutils.encodePng(croppedFace));
      });

      await _encodeFace(croppedFace);

      Future.delayed(Duration(seconds: 4)).then(
          (value) => Navigator.pushReplacementNamed(context, "/home_page"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FacePageStrings.title),
      ),
      body: _textOrFace(),
      bottomNavigationBar: _bottomNavigator(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _selectImageButton(),
    );
  }

  /// Return text if face was not found else return cropped face
  Widget _textOrFace() {
    if (_face == null) {
      return Center(
        child: Text(
          _text,
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey[300],
          ),
        ),
      );
    } else {
      return Center(
        child: Container(
          child: this._face,
        ),
      );
    }
  }

  /// Return bottom navigation bar
  Widget _bottomNavigator() {
    return BottomAppBar(
      color: Colors.grey[250],
      child: Container(
        height: 60,
      ),
    );
  }

  /// Return button to choose image on device
  Widget _selectImageButton() {
    return Container(
      height: 65,
      width: 65,
      child: FloatingActionButton(
        onPressed: () => _detectFaces(),
        child: Icon(
          Icons.add_a_photo,
          size: 35,
        ),
      ),
    );
  }
}
