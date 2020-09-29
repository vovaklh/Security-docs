import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:security_docs/logics/Password.dart';
import 'package:security_docs/logics/fileUtils.dart';

class PasswordPage extends StatefulWidget {
  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final controller = TextEditingController();
  String errorMessage = "";

  void controle(String newPassword) async{
    Password password = Password();
    String path = await getLocalPath();

    bool passwordExist = await password.checkIfPasswordExist();
    print(passwordExist);

    if(!passwordExist){
      password.setPassword(password: newPassword, path: path);
    }
    else{
      String myPassword = await password.getPassword(path: path);
      if (myPassword != controller.text){
        setState(() {
          errorMessage = "Incorrect password";
        });
      };
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
                  image: AssetImage("assets/images/password.png"))
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
          ),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 20),
              child: RaisedButton(
                onPressed: (){
                  //print(controller.text);
                  controle(controller.text);
                },
                padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                color: Colors.blue[300],
                shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                child: Text("Enter", style: TextStyle(fontSize: 24, color: Colors.white),),
              ),
            ),
          )
        ],
      )
    );
  }

  Widget MyErrorWidget(){
    if(errorMessage != ""){
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
                child: Text(errorMessage) ,
              ),
              IconButton(
                  icon: Icon(Icons.close),
                  onPressed: (){
                    setState(() {
                      errorMessage = "";
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

