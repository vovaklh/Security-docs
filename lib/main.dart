import 'package:flutter/material.dart';
import 'package:security_docs/logics/Password.dart';
import 'package:security_docs/pages/HomePage.dart';
import 'package:security_docs/pages/PasswordPage.dart';
import 'package:security_docs/pages/FacePage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // For main function with async
  bool passwordExist =  await Password().checkIfPasswordExist(); //Get password existing

  // If password exist we ask user to enter password to show page with files
  if(passwordExist){
    runApp(MaterialApp(
      home: PasswordPage("Enter"),
      debugShowCheckedModeBanner: false,
      routes: {
        "/homepage" : (_) => new HomePage(),
        "/facepage" : (_) => new FacePage()
      },
    ));
  }

  //Else password does not exist we show user empty page with files and he can set password
  else {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/homepage",
      routes: {
        "/passwordpage": (_) => PasswordPage("Set"),
        "/homepage": (_) => HomePage(),
        "/facepage" : (_) => new FacePage()
      },
    ));
  }
}




