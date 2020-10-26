import 'package:flutter/material.dart';
import 'package:security_docs/logics/Password.dart';
import 'package:security_docs/pages/HomePage.dart';
import 'package:security_docs/pages/PasswordPage.dart';
import 'package:security_docs/pages/FacePage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // For main function with async
  bool passwordExist =  await Password().checkIfPasswordExist(); //Get password existing

  // Show password page if password existe
  if(passwordExist){
    runApp(MaterialApp(
      initialRoute: "/passwordpage",
      debugShowCheckedModeBanner: false,
      routes: {
        "/homepage" : (_) => new HomePage(),
        "/passwordpage": (_) => new PasswordPage("Enter"),
      },
    ));
  }

  //Else show homepage
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




