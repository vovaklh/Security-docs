import 'package:flutter/material.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:security_docs/logics/Password.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:security_docs/logics/FaceVerificator.dart';
import 'package:security_docs/logics/CameraVerificator.dart';
import 'package:security_docs/logics/Strings.dart'
    show passwordEnteringPageStrings;
import 'package:flutter_gifimage/flutter_gifimage.dart';

class PasswordEnteringPage extends StatefulWidget {
  @override
  _PasswordEnteringPageState createState() => _PasswordEnteringPageState();
}

class _PasswordEnteringPageState extends State<PasswordEnteringPage>
    with TickerProviderStateMixin {
  final _controller = TextEditingController();
  final double _animateTo = 165.0;
  final int _timeOfGifDuration = 3000;
  final int _timeOfSoundDuration = 2400;
  CameraVerificator _cameraVerificator;
  GifController _gifController;

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this);
  }

  @override
  void dispose() {
    _cameraVerificator?.disposeVerification();
    _gifController.dispose();
    super.dispose();
  }

  Future<void> unlock() async {
    final player = AudioCache(prefix: passwordEnteringPageStrings.pathToSound);
    Future.delayed(Duration(milliseconds: _timeOfSoundDuration))
        .then((value) => player.play(passwordEnteringPageStrings.soundName));
    _gifController
        .animateTo(_animateTo,
            duration: Duration(milliseconds: _timeOfGifDuration))
        .then((value) {
      Navigator.pushReplacementNamed(context, "/homepage");
    });
  }

  Future<void> verifyFace() async {
    FaceVerificator faceVerificator = FaceVerificator(112, 128, 128);
    bool faceExist = await faceVerificator.checkIfFaceExist();

    if (faceExist) {
      _cameraVerificator = CameraVerificator();
      _cameraVerificator.startDetectingAndVerifyFace(unlock);
    }
  }

  void resetPassword() {
    setState(() {
      _controller.text = "";
    });
  }

  void checkPassword(String newPassword) async {
    Password password = Password();
    String myPassword = await password.getPassword();

    if (myPassword != _controller.text.hashCode.toString()) {
      incorrectPasswordAlertDialog(context);
    } else {
      _cameraVerificator?.stopVerification();
      await unlock();
    }
    resetPassword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: GifImage(
            image: AssetImage(passwordEnteringPageStrings.pathToGif),
            controller: _gifController,
            height: 250,
            width: 250,
          )),
          Center(
            child: passwordField(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              inputPasswordButton(),
              verifyFaceButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget passwordField() {
    return Container(
      margin: EdgeInsets.only(top: 15, left: 20, right: 20),
      child: PasswordField(
        controller: _controller,
        backgroundColor: Colors.white,
        backgroundBorderRadius: BorderRadius.circular(20),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 1, color: Colors.blue[200])),
        errorFocusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 1, color: Colors.red[400])),
      ),
    );
  }

  Widget inputPasswordButton() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      height: 50.0,
      child: RaisedButton(
        onPressed: () {
          checkPassword(_controller.text);
        },
        padding:
            EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
        color: Colors.blue[300],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Text(
          passwordEnteringPageStrings.buttonText,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  Widget verifyFaceButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.only(left: 5.0, top: 15.0),
      child: FloatingActionButton(
        child: Icon(
          Icons.face,
          size: 35,
        ),
        onPressed: verifyFace,
        backgroundColor: Colors.blue[300],
      ),
    );
  }

  incorrectPasswordAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(passwordEnteringPageStrings.titleOfDialog),
            content: Text(passwordEnteringPageStrings.incorrectPasswordMessage),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        });
  }
}
