import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:security_docs/widgets/FileWidget.dart';
import 'package:security_docs/logics/CustomFile.dart';
import 'package:security_docs/logics/fileUtils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamController streamController;
  Stream stream;
  List<CustomFile> files;

  @override
  void initState(){
    super.initState();

    // Initialize stream and streamcontroler
    streamController = StreamController();
    stream = streamController.stream;

    getFiles();
  }

  getFiles() async {
    files = await loadFiles();
    streamController.add(files);
  }

  addFile(CustomFile file){
    if(files.where((el) => el == file).toList().length == 0){
      setState(() {
        files.add(file);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Documents"),
      ),
      body: StreamBuilder(
          stream: stream,
          builder: (BuildContext ctx, AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Center(child: CircularProgressIndicator());
            }
            else{
              return ListView.builder(
                  padding: EdgeInsets.only(top: 5.0),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    return FileWidget(filePath: snapshot.data[index].filePath, fileName: snapshot.data[index].fileName,
                                      fileExtension: snapshot.data[index].fileExtension,);
                  });
            }
          }),
      floatingActionButton: FloatingActionButton(onPressed: () {
        addFile(CustomFile(filePath: "dfdf", fileName: "fgfg", fileExtension: "pdpf"));
      })
    );
  }
}


