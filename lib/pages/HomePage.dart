import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:security_docs/widgets/FileWidget.dart';
import 'package:security_docs/widgets/PopUpButton.dart';
import 'package:security_docs/logics/Strings.dart';
import 'package:security_docs/blocs/FileBloc.dart';
import 'package:security_docs/utils/fileUtils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final _bloc = BlocProvider.getBloc<FileBloc>();

  @override
  void initState() {
    _bloc.addFile();
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    _bloc?.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      deleteAllEncrypted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(homePageStrings.title),
      ),
      body: userDocuments(),
      floatingActionButton: popupButton(context, _bloc.addFile),
    );
  }

  Widget userDocuments() {
    return StreamBuilder(
        stream: _bloc.fileStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data.length == 0) {
            return emptyDocuments();
          } else {
            return SafeArea(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.only(top: 5.0),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return fileWidget(
                      filePath: snapshot.data[index].filePath,
                      fileName: snapshot.data[index].fileName,
                      fileExtension: snapshot.data[index].fileExtension,
                      showDialog: showLoadingAlertDialog,
                      closeDialog: closeLoadingAlertDialog
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

  void showLoadingAlertDialog() {
    loadingAlertDialog(context);
  }

  void closeLoadingAlertDialog() {
    Navigator.of(context).pop();
  }

  loadingAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(homePageStrings.titleOfDialog),
            content: Image(
              image: AssetImage(homePageStrings.pathToGif),
              height: 50,
              width: 50,
            ),
          );
        });
  }
}
