import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image/image.dart' as imutils;
import 'package:security_docs/logics/FaceVerificator.dart';
import 'package:security_docs/utils/faceUtils.dart';
import 'package:security_docs/logics/MyFaceDetector.dart';
import 'package:security_docs/logics/Strings.dart' show facePageStrings;

class FacePage extends StatefulWidget {
  @override
  _FacePageState createState() => _FacePageState();
}

class _FacePageState extends State<FacePage> {
  Image _face;
  String _text = facePageStrings.initialMessage;

  void setStatus(String text){
    setState(() {
      this._text = text;
    });
  }

  void setButtonToDefault(){
    setState(() {
      this._face == null;
      this._text = facePageStrings.imageSelected;
    });
  }

  void encodeFace(imutils.Image face) async{
    FaceVerificator faceVerificator = FaceVerificator(112, 128, 128);
    await faceVerificator.loadModel(modelPath: "models/mobilefacenet.tflite");
    List faceVector = faceVerificator.getOutput(face);
    faceVerificator.saveArrayToFile(faceVector);
    faceVerificator.closeInterpreter();
  }

  Future detectFaces() async{
    setButtonToDefault();

    File image = await ImagePicker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    MyFaceDetector myFaceDetector = MyFaceDetector();
    List<Face> faces = await myFaceDetector.predictImageFromFile(image);

    if(faces.length == 0){
      setStatus(facePageStrings.noFaces);
    }

    else if(faces.length > 1){
      setStatus(facePageStrings.manyFaces);
    }

    else{
      imutils.Image croppedFace = cropFace(imutils.decodeImage(image.readAsBytesSync()), faces.first, true);

      setState(() {
        this._face = Image.memory(imutils.encodePng(croppedFace));
      });

      encodeFace(croppedFace);

      await Future.delayed(Duration(seconds: 2));
      Navigator.pushReplacementNamed(context, "/homepage");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(facePageStrings.title),
      ),
      body: textOrFace(),
      bottomNavigationBar: bottomNavigator(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: mainButton(),
    );
  }


  // Return image with face or text
  Widget textOrFace(){
    if(_face == null){
      return Center(
        child: Text(_text,
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey[300],
          ),
        ),
      );
    }
    else{
      return Center(
        child: Container(
          child: this._face,
        ),
      );
    }
  }

  Widget bottomNavigator(){
    return BottomAppBar(
      color: Colors.grey[250],
      child: Container(height: 60,),
    );
  }

  Widget mainButton(){
    return Container(
      height: 65,
      width: 65,
      child: FloatingActionButton(
        onPressed: () => detectFaces(),
        child: Icon(Icons.add_a_photo, size: 35,),
      ),
    );
  }
}
