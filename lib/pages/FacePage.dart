import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image/image.dart' as imutils;

class FacePage extends StatefulWidget {
  @override
  _FacePageState createState() => _FacePageState();
}

class _FacePageState extends State<FacePage> {
  Image face;
  String text = "No image selected";

  Future<ui.Image> loadImage(File image) async{
    var img = await image.readAsBytes();

    return await decodeImageFromList(img);
  }

  Future detectFaces() async{

    setState(() {
      this.face = null;
      this.text = "Wait...";
    });

    File image = await ImagePicker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);

    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
    FaceDetector faceDetector = FirebaseVision.instance.faceDetector();

    List<Face> faces = await faceDetector.processImage(visionImage);

    if(faces.length == 0){
      setState(() {
        text = "No face was found";
      });
    }

    else if(faces.length > 1){
      setState(() {
        text = "Too many faces";
      });
    }

    else{
      imutils.Image croppedFace = imutils.copyRotate(imutils.copyCrop(imutils.decodeImage(image.readAsBytesSync()),
          faces.first.boundingBox.topLeft.dy.floor(), faces.first.boundingBox.topLeft.dx.floor(),
          faces.first.boundingBox.height.floor(), faces.first.boundingBox.width.floor()), -90);

      setState(() {
        this.face = Image.memory(imutils.encodePng(croppedFace));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Face Detection"),
      ),
      body: (this.face == null) ?
        Center(
          child: Text(text,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[300],
            ),
          ),
        ) :
        Center(
          child: Container(
              child: this.face,
            ),
          ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[250],
        child: Container(height: 60,),

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 65,
        width: 65,
        child: FloatingActionButton(
          onPressed: detectFaces,
          child: Icon(Icons.add_a_photo, size: 35,),
        ),
      ),
    );
  }
}
