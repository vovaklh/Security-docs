import 'package:flutter/material.dart';
import 'package:security_docs/widgets/FileWidget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Documents"),
      ),
      body: FileWidget(fileName: "my_Face", fileExtension: "png",),
      floatingActionButton: FloatingActionButton(onPressed: null),
    );
  }
}


