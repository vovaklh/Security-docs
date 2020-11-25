import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:security_docs/pages/home_page.dart';
import 'package:security_docs/pages/face_page.dart';
import 'package:security_docs/pages/splash_page.dart';
import 'package:security_docs/blocs/file_bloc.dart';
import 'package:security_docs/pages/password_entering_page.dart';
import 'package:security_docs/pages/password_setting_page.dart';

void main() {
  runApp(
    BlocProvider(
      blocs: [
        Bloc((i) => FileBloc(), singleton: false),
      ],
      child: MaterialApp(
        initialRoute: "/splash_page",
        debugShowCheckedModeBanner: false,
        routes: {
          "/home_page": (_) => new HomePage(),
          "/password_entering_page": (_) => new PasswordEnteringPage(),
          "/password_setting_page": (_) => new PasswordSettingPage(),
          "/splash_page": (_) => new SplashPage(),
          '/face_page': (_) => new FacePage()
        },
      ),
    ),
  );
}
