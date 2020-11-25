import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:security_docs/models/custom_file.dart';
import 'package:security_docs/utils/file_utils.dart';

class FileBloc extends BlocBase {
  StreamController _fileStreamController;
  List<CustomFile> _files;

  /// Give access to stream
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

  /// Load files from external storage and add them fo list.
  /// Then list is added to stream
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
