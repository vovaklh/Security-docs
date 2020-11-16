import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:security_docs/logics/Password.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:security_docs/logics/FaceVerificator.dart';
import 'package:security_docs/logics/CameraVerificator.dart';
import 'package:security_docs/logics/Strings.dart' show passwordPageStrings;

class PasswordPage extends StatefulWidget {
  String buttonText; //Text of button

  PasswordPage(String buttonText) {
    this.buttonText = buttonText;
  }

  @override
  _PasswordPageState createState() => _PasswordPageState(this.buttonText);
}

class _PasswordPageState extends State<PasswordPage> {
  final _controller = TextEditingController();
  String _pattern;
  String _errorMessageIncorrectPassword = "";
  String _errorPatternMessage =
      "Password must contain more than 7 symbols, 1 alphabet and 1 digit";
  String _buttonText;
  String _mainImage = "assets/images/lock.png";
  CameraVerificator _cameraVerificator;

  _PasswordPageState(String buttonText) {
    this._buttonText = buttonText;
    if (buttonText == "Set") _pattern = passwordPageStrings.passwordPattern;
  }

  @override
  void dispose() {
    _cameraVerificator?.disposeVerification();
    super.dispose();
  }

  // Play signal and go to homepage if password is correct
  Future<void> unblock() async {
    setState(() {
      _mainImage = passwordPageStrings.pathToGif; //Set image to unlock
    });

    final player = AudioCache(prefix: passwordPageStrings.pathToSound);
    player.play(passwordPageStrings.soundName); // Play sound of unlocking
    await Future.delayed(Duration(milliseconds: 900));

    Navigator.pushReplacementNamed(context, "/homepage");
  }

  bool validatePassword(String password) {
    if (password.length >= 8) {
      if (RegExp(_pattern).hasMatch(password)) {
        return true;
      } else {
        setPatternMessage(passwordPageStrings.setIncorrectPassword);
      }
    } else {
      return false;
    }
  }

  // Start camera stream and verifying faces
  verifyFace() async {
    FaceVerificator faceVerificator = FaceVerificator(112, 128, 128);
    bool faceExist = await faceVerificator.checkIfFaceExist();

    if (faceExist) {
      _cameraVerificator = CameraVerificator();
      _cameraVerificator.startDetectingAndVerifyFace(unblock);
    }
  }

  // Set password to empty string after user press enter button
  void resetPassword() {
    setState(() {
      _controller.text = "";
    });
  }

  void setIncorrectPasswordMessage(String text) {
    setState(() {
      _errorMessageIncorrectPassword = text;
    });
  }

  void setPatternMessage(String text) {
    setState(() {
      _errorPatternMessage = text;
    });
  }

  // Compare passwords or set new password
  void controle(String newPassword) async {
    Password password = Password();
    bool passwordExist = await password.checkIfPasswordExist();

    //Set password if it doesn't exist
    if (!passwordExist) {
      if (validatePassword(newPassword)) {
        // Validate password to set it
        await password.setPassword(password: newPassword); // Set new password
        Navigator.pushReplacementNamed(
            context, "/facepage"); // Go back to homepage
      }
    }
    //Else check if password is correct and show homepage or error message
    else {
      String myPassword = await password.getPassword();

      if (myPassword != _controller.text.hashCode.toString()) {
        setIncorrectPasswordMessage(passwordPageStrings.enterIncorrectPassword);
      } else {
        _cameraVerificator
            ?.stopVerification(); // If password is correct and camera is streaming
        await unblock();
      }
      resetPassword();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: MyErrorWidget(),
          margin: EdgeInsets.only(bottom: 40),
        ),
        Center(
            child: Image(
          image: AssetImage(_mainImage),
          height: 212,
          width: 212,
        )),
        Center(
          child: passwordField(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            mainButton(),
            conditionButton(_buttonText),
          ],
        )
      ],
    ));
  }

  Widget passwordField() {
    return Container(
      margin: EdgeInsets.only(top: 15, left: 20, right: 20),
      //color: Colors.blue,
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
        pattern: _pattern,
        errorMessage: _errorPatternMessage,
      ),
    );
  }

  Widget mainButton() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      height: 50.0,
      child: RaisedButton(
        onPressed: () {
          controle(_controller.text);
        },
        padding:
            EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
        color: Colors.blue[300],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Text(
          _buttonText,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  Widget conditionButton(String buttonText) {
    if (buttonText == "Enter") {
      return Container(
        height: 50,
        margin: EdgeInsets.only(left: 5.0, top: 20.0),
        child: FloatingActionButton(
          child: Icon(
            Icons.face,
            size: 35,
          ),
          onPressed: verifyFace,
          backgroundColor: Colors.blue[300],
        ),
      );
    } else {
      return SizedBox(
        height: 0,
      );
    }
  }

  Widget MyErrorWidget() {
    if (_errorMessageIncorrectPassword != "") {
      return SafeArea(
        child: Container(
          color: Colors.amberAccent,
          width: double.infinity,
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.error_outline)),
              Expanded(
                child: Text(_errorMessageIncorrectPassword),
              ),
              IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _errorMessageIncorrectPassword = "";
                    });
                  }),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 0,
      );
    }
  }
}
