import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:security_docs/widgets/file_widget.dart';
import 'package:security_docs/widgets/add_face_and_file_button.dart';
import 'package:security_docs/resources/strings.dart';
import 'package:security_docs/blocs/file_bloc.dart';
import 'package:security_docs/utils/file_utils.dart';

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
        title: Text(HomePageStrings.title),
      ),
      body: userDocuments(),
      floatingActionButton: addFaceAndFileButton(goToFacePage, _bloc.addFile),
    );
  }

  /// Return StreamBuilder of user files
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
                        closeDialog: closeLoadingAlertDialog);
                  }),
            );
          }
        });
  }

  /// Return the text which signalize that user have no files
  Widget emptyDocuments() {
    return Center(
      child: Text(
        HomePageStrings.emptyDocuments,
        style: TextStyle(
          fontSize: 20,
          color: Colors.grey[300],
        ),
      ),
    );
  }

  /// Show the loadingAlert dialog when file is decrypting
  void showLoadingAlertDialog() {
    loadingAlertDialog(context);
  }

  /// Close the loadingAlert dialog when file is decrypted
  void closeLoadingAlertDialog() {
    Navigator.of(context).pop();
  }

  void goToFacePage() {
    Navigator.pushReplacementNamed(context, "/face_page");
  }

  loadingAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(HomePageStrings.titleOfDialog),
            content: Image(
              image: AssetImage(HomePageStrings.pathToGif),
              height: 50,
              width: 50,
            ),
          );
        });
  }
}
