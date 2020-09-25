import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:security_docs/widgets/FileWidget.dart';
import 'package:security_docs/logics/fileUtils.dart';

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
      body: ListView(
          padding: EdgeInsets.only(top: 5.0,),
          children: [
            FileWidget(filePath: "/storage/emulated/0/Download/", fileName: "1294.pdf", fileExtension: "pdf",),

      ]),
      floatingActionButton: FloatingActionButton(onPressed: (){convertList();},)
    );
  }
}


