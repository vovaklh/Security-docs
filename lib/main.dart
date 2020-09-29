import 'package:flutter/material.dart';
import 'package:security_docs/pages/HomePage.dart';
import 'package:security_docs/pages/PasswordPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Security docs',
      //home: HomePage(),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}



