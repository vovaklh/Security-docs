import 'package:flutter/material.dart';
import 'package:security_docs/logics/password.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:security_docs/utils/file_utils.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  final double _animateTo = 63.0;
  final int _timeOfDuration = 3000;
  GifController _gifController;

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this);
    _gifController
        .animateTo(_animateTo,
            duration: Duration(milliseconds: _timeOfDuration))
        .then((value) => goToNextPage());
  }

  @override
  void dispose() {
    super.dispose();
    _gifController.dispose();
  }

  /// Go to passwordEnteringPage if password exist
  /// else navigate to passwordSetting page
  Future<void> goToNextPage() async {
    bool passwordExist = await Password().checkIfPasswordExist();

    if (passwordExist)
      Navigator.pushReplacementNamed(context, "/password_entering_page");
    else {
      deleteAllFiles();
      Navigator.pushReplacementNamed(context, "/password_setting_page");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loadingImage(),
    );
  }

  Widget loadingImage() {
    return Center(
      child: GifImage(
        image: AssetImage("assets/images/animation.gif"),
        controller: _gifController,
      ),
    );
  }
}
