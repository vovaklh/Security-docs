import 'package:flutter/material.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:security_docs/logics/password.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:security_docs/logics/face_verificator.dart';
import 'package:security_docs/logics/camera_verificator.dart';
import 'package:security_docs/resources/strings.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';

class PasswordEnteringPage extends StatefulWidget {
  @override
  _PasswordEnteringPageState createState() => _PasswordEnteringPageState();
}

class _PasswordEnteringPageState extends State<PasswordEnteringPage>
    with TickerProviderStateMixin {
  final _controller = TextEditingController();
  final double _animateTo = 35.0;
  final int _timeOfGifDuration = 1000;
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

  /// Play sound and start animation
  Future<void> unlock() async {
    final player = AudioCache(prefix: PasswordEnteringPageStrings.pathToSound);
    player.play(PasswordEnteringPageStrings.soundName);
    _gifController
        .animateTo(_animateTo,
            duration: Duration(milliseconds: _timeOfGifDuration))
        .then((value) {
      Navigator.pushReplacementNamed(context, "/home_page");
    });
  }

  /// Start verifying faces
  Future<void> _verifyFace() async {
    FaceVerificator faceVerificator = FaceVerificator();
    bool faceExist = await faceVerificator.checkIfFaceExist();

    if (faceExist) {
      _cameraVerificator = CameraVerificator();
      _cameraVerificator.startDetectingAndVerifyFace(unlock);
    } else {
      _faceDoesNotExistAlertDialog(context);
    }
  }

  /// Reset password to empty string
  void resetPassword() {
    setState(() {
      _controller.text = "";
    });
  }

  /// Check if password exist and then compare password user input
  Future<void> _checkPassword(String newPassword) async {
    Password password = Password();
    String myPassword = await password.getPassword();

    if (myPassword != _controller.text.hashCode.toString()) {
      _incorrectPasswordAlertDialog(context);
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
            child: _padlockGif(),
          ),
          Center(
            child: _passwordField(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _inputPasswordButton(),
              _verifyFaceButton(),
            ],
          ),
        ],
      ),
    );
  }

  /// Return the gif of padlock
  Widget _padlockGif() {
    return GifImage(
      image: AssetImage(PasswordEnteringPageStrings.pathToGif),
      controller: _gifController,
      height: 250,
      width: 250,
    );
  }

  /// Return the password filed
  Widget _passwordField() {
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

  /// Return button to input password
  Widget _inputPasswordButton() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      height: 50.0,
      child: RaisedButton(
        onPressed: () {
          _checkPassword(_controller.text);
        },
        padding:
            EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
        color: Colors.blue[300],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Text(
          PasswordEnteringPageStrings.buttonText,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  /// Return button to verify face
  Widget _verifyFaceButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.only(left: 5.0, top: 15.0),
      child: FloatingActionButton(
        child: Icon(
          Icons.face,
          size: 35,
        ),
        onPressed: _verifyFace,
        backgroundColor: Colors.blue[300],
      ),
    );
  }

  /// Show message that password is incorrect
  _incorrectPasswordAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(PasswordEnteringPageStrings.titleOfDialog),
            content: Text(PasswordEnteringPageStrings.incorrectPasswordMessage),
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

  /// Show message that user doesn't add face
  _faceDoesNotExistAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(PasswordEnteringPageStrings.titleOfDialog),
            content: Text(PasswordEnteringPageStrings.faceDoesNotExistMessage),
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
