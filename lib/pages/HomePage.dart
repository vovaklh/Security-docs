import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:security_docs/widgets/FileWidget.dart';
import 'package:security_docs/logics/CustomFile.dart';
import 'package:security_docs/logics/fileUtils.dart';
import 'package:security_docs/widgets/MainButtonWidget.dart';

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

    files = new List<CustomFile>();
    streamController.add(files);

    addFile();
  }


  addFile() async {
    while(true){
      List<CustomFile> newFiles = await loadFiles();
      if(newFiles.length > files.length){
        for(int i = files.length; i < newFiles.length; i++){
          CustomFile newFile = newFiles[i];

          if(files.where((el) => el == newFile).toList().length == 0){
            setState(() {
              files.add(newFile);
            });
          }
        }
      }
      await Future.delayed(Duration(microseconds: 500));
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
            else if(snapshot.data.length == 0){
              return Center(
                child: Text("No documents",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[300],
                          ),
                ),
              );
            }
            else{
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.only(top: 5.0),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    return FileWidget(filePath: snapshot.data[index].filePath, fileName: snapshot.data[index].fileName,
                                      fileExtension: snapshot.data[index].fileExtension,);
                  });
            }
          }),
      floatingActionButton: PopUpButton(),
    );
  }
}


