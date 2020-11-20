import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:security_docs/pages/HomePage.dart';
import 'package:security_docs/pages/PasswordPage.dart';
import 'package:security_docs/pages/FacePage.dart';
import 'package:security_docs/pages/SplashPage.dart';
import 'package:security_docs/blocs/FileBloc.dart';

void main() {
  runApp(
    BlocProvider(
      blocs: [
        Bloc((i) => FileBloc(), singleton: false),
      ],
      child: MaterialApp(
        initialRoute: "/splashpage",
        debugShowCheckedModeBanner: false,
        routes: {
          "/homepage": (_) => new HomePage(),
          "/passwordEnteringPage": (_) => new PasswordPage("Enter"),
          "/passwordSettingPage": (_) => new PasswordPage("Set"),
          "/splashpage": (_) => new SplashPage(),
          '/facepage': (_) => new FacePage()
        },
      ),
    ),
  );
}
