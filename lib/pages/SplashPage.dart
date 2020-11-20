import 'package:flutter/material.dart';
import 'package:security_docs/logics/Password.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    goToNextPage();
    super.initState();
  }

  Future<void> goToNextPage() async {
    bool passwordExist = await Password().checkIfPasswordExist();
    Future.delayed(Duration(seconds: 3)).then((value) {
      if (passwordExist)
        Navigator.pushReplacementNamed(context, "/passwordEnteringPage");
      else
        Navigator.pushReplacementNamed(context, "/homepage");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mainImage(),
    );
  }

  Widget mainImage() {
    return Center(
      child: Image(
        image: AssetImage("assets/images/animation.gif"),
      ),
    );
  }
}
