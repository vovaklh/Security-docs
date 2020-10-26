import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:security_docs/widgets/FileWidget.dart';
import 'package:security_docs/logics/CustomFile.dart';
import 'package:security_docs/logics/fileUtils.dart';
import 'package:security_docs/widgets/PopUpButton.dart';
import 'package:security_docs/logics/Strings.dart' show homePageStrings;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamController _streamController;
  Stream _stream;
  List<CustomFile> _files;

  @override
  void initState(){
    super.initState();

    _streamController = StreamController();
    _stream = _streamController.stream;

    _files = new List<CustomFile>();
    _streamController.add(_files);

    addFile();
  }

  // Load files from external storage and add new files to list
  addFile() async {
    while(true){
      List<CustomFile> newFiles = await loadFiles();
      if(newFiles.length > _files.length){
        for(int i = _files.length; i < newFiles.length; i++){
          CustomFile newFile = newFiles[i];

          if(_files.where((el) => el == newFile).toList().length == 0){
            if(mounted){
              setState(() {
                _files.add(newFile);
              });
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(homePageStrings.title),
      ),
      body: userDocuments(),
      floatingActionButton: popupButton(context), //Create popupbutton in right bottom side
    );
  }

  Widget userDocuments(){
    return StreamBuilder(
        stream: _stream,
        builder: (BuildContext ctx, AsyncSnapshot snapshot){
          if(snapshot.data == null){ // Show progress indicator if we got null
            return Center(child: CircularProgressIndicator());
          }
          else if(snapshot.data.length == 0){ //Show that user has no files
            return emptyDocuments();
          }
          else{
            return SafeArea(
              child: ListView.builder(// Else create ListView with files
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.only(top: 5.0),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    return fileWidget(filePath: snapshot.data[index].filePath, fileName: snapshot.data[index].fileName,
                      fileExtension: snapshot.data[index].fileExtension,);
                  }),
            );
          }
        });
  }

  Widget emptyDocuments(){
    return Center(
      child: Text(homePageStrings.emptyDocuments,
        style: TextStyle(
          fontSize: 20,
          color: Colors.grey[300],
        ),
      ),
    );
  }
}


