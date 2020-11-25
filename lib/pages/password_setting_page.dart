import 'package:flutter/material.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:security_docs/logics/Password.dart';
import 'package:security_docs/logics/Strings.dart';

class PasswordSettingPage extends StatefulWidget {
  @override
  _PasswordSettingPageState createState() => _PasswordSettingPageState();
}

class _PasswordSettingPageState extends State<PasswordSettingPage> {
  final _controller = TextEditingController();

  bool validatePassword(String password) {
    if (password.length >= 8) {
      if (RegExp(passwordSettingPageStrings.pattern).hasMatch(password)) {
        return true;
      }
    } else {
      return false;
    }
  }

  // Set password to empty string after user press enter button
  void resetPassword() {
    setState(() {
      _controller.text = "";
    });
  }

  void setPassword(String newPassword) async {
    Password password = Password();

    if (validatePassword(newPassword)) {
      await password.setPassword(password: newPassword);
      Navigator.pushReplacementNamed(context, "/homepage");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Image(
            image: AssetImage(passwordSettingPageStrings.pathToImage),
            height: 212,
            width: 212,
          )),
          Center(
            child: passwordField(),
          ),
          Center(
            child: mainButton(),
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
        pattern: passwordSettingPageStrings.pattern,
        errorMessage: passwordSettingPageStrings.passwordDoesntMatchPattern,
      ),
    );
  }

  Widget mainButton() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      height: 50.0,
      child: RaisedButton(
        onPressed: () {
          setPassword(_controller.text);
        },
        padding:
            EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
        color: Colors.blue[300],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Text(
          passwordSettingPageStrings.buttonText,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
