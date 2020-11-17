import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:security_docs/models/CustomFile.dart';
import 'package:security_docs/utils/fileUtils.dart';

class FileBloc extends BlocBase {
  StreamController _fileStreamController;
  List<CustomFile> _files;

  Stream get fileStream => _fileStreamController.stream;

  FileBloc() {
    _fileStreamController = StreamController();
    _files = List<CustomFile>();
    _fileStreamController.add(_files);
  }

  @override
  void dispose() {
    _fileStreamController.close();
    super.dispose();
  }

  Future<void> addFile() async {
    List<CustomFile> newFiles = await loadFiles();
    if (newFiles.length > _files.length) {
      for (int i = 0; i < newFiles.length; i++) {
        CustomFile newFile = newFiles[i];
        if (_files.where((el) => el == newFile).toList().length == 0) {
          _files.add(newFile);
        }
      }
      _fileStreamController.add(_files);
    }
  }
}
