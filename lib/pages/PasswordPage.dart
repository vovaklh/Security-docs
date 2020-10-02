import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:security_docs/logics/Password.dart';
import 'package:security_docs/logics/fileUtils.dart';
import 'package:audioplayers/audio_cache.dart';

class PasswordPage extends StatefulWidget {
  String buttonText; //Text of button

  PasswordPage(String buttonText){
    this.buttonText = buttonText;
  }

  @override
  _PasswordPageState createState() => _PasswordPageState(this.buttonText);
}

class _PasswordPageState extends State<PasswordPage> {
  final controller = TextEditingController();
  String pattern;
  String errorMessageIncorrectPassword = "";
  String errorPatternMessage = "Password must contain more than 7 symbols, 1 alphabet and 1 digit";
  String buttonText;
  Image mainImage = Image(image: AssetImage("assets/images/password.png"));

  _PasswordPageState(String buttonText){
    this.buttonText = buttonText;
    if(buttonText == "Set"){
      pattern = r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$";
    }
  }

  bool validatePassword(String password){
    if(password.length >= 8){
        if(RegExp(pattern).hasMatch(password)){
          return true;
        }
        else{
          setState(() {
            errorPatternMessage = "Password must contain at least 1 alphabet and 1 digit";
          });
        }
    }
    else{
      return false;
    }
  }

  //Call this function when button pressed
  void controle(String newPassword, BuildContext context) async{
    //Create new instance of Password class and check if file with password exist
    Password password = Password();
    bool passwordExist = await password.checkIfPasswordExist();

    String path = await getLocalPath(); // Get path to local app directory

    //Set password if it doesn't exist
    if(!passwordExist){
      if(validatePassword(newPassword)) { // Validate password to set it
        password.setPassword(password: newPassword, path: path); // Set new password
        Navigator.pushReplacementNamed(context, "/homepage"); // Go back to homepage
        }
    }
    //Else check if password is correct and show homepage or error message
    else{
      String myPassword = await password.getPassword(path: path); // Get password
      if (myPassword != controller.text){ // If password and text of filed aren't equal
        setState(() {
          errorMessageIncorrectPassword = "Incorrect password";
        });
      }
      else{
        setState(() {
          mainImage = Image(image: AssetImage("assets/images/unlock.png")); //Set image to unlock
        });
        final player = AudioCache(prefix: "assets/sounds/");
        player.play("unlock.mp3"); // Play sound of unlocking
        await Future.delayed(Duration(milliseconds: 333)); //Sleep for 2000 milliseconds
        Navigator.pushReplacementNamed(context, "/homepage"); // Show page with user files
      }
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
              child: mainImage
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 15, left: 20, right: 20),
              //color: Colors.blue,
              child: PasswordField(
                controller: controller,
                backgroundColor: Colors.white,
                backgroundBorderRadius: BorderRadius.circular(20),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: 1, color: Colors.blue[200])),
                errorFocusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: 1, color: Colors.red[400])) ,
                pattern: pattern,
                errorMessage: errorPatternMessage,
          ),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 20),
              child: RaisedButton(
                onPressed: (){
                  //print(controller.text);
                  controle(controller.text, context);
                },
                padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                color: Colors.blue[300],
                shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                child: Text(buttonText, style: TextStyle(fontSize: 24, color: Colors.white),),
              ),
            ),
          )
        ],
      )
    );
  }


  //Widget of error message
  Widget MyErrorWidget(){
    if(errorMessageIncorrectPassword != ""){
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
                child: Text(errorMessageIncorrectPassword) ,
              ),
              IconButton(
                  icon: Icon(Icons.close),
                  onPressed: (){
                    setState(() {
                      errorMessageIncorrectPassword = "";
                    });
                  }),
            ],
          ),
        ),
      );
    }
    else{
      return SizedBox(height: 0,);
    }
  }
}

