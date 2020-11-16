import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:security_docs/widgets/FileWidget.dart';
import 'package:security_docs/widgets/PopUpButton.dart';
import 'package:security_docs/logics/Strings.dart' show homePageStrings;
import 'package:security_docs/blocs/FileBloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _bloc = BlocProvider.getBloc<FileBloc>();

  @override
  void dispose() {
    _bloc?.dispose();
    print("disposed");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(homePageStrings.title),
      ),
      body: userDocuments(),
      floatingActionButton: popupButton(
          context, _bloc.addFile), //Create popupbutton in right bottom side
    );
  }

  Widget userDocuments() {
    return StreamBuilder(
        stream: _bloc.fileStream,
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            // Show progress indicator if we got null
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data.length == 0) {
            //Show that user has no files
            return emptyDocuments();
          } else {
            return SafeArea(
              child: ListView.builder(
                  // Else create ListView with files
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.only(top: 5.0),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return fileWidget(
                      filePath: snapshot.data[index].filePath,
                      fileName: snapshot.data[index].fileName,
                      fileExtension: snapshot.data[index].fileExtension,
                    );
                  }),
            );
          }
        });
  }

  Widget emptyDocuments() {
    return Center(
      child: Text(
        homePageStrings.emptyDocuments,
        style: TextStyle(
          fontSize: 20,
          color: Colors.grey[300],
        ),
      ),
    );
  }
}
