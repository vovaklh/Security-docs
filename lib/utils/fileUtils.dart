import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:security_docs/models/CustomFile.dart';
import 'dart:io' as io;
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart';

// Open file on device
Future<void> openFile({String filePath, String fileName}) async {
  await OpenFile.open(filePath + fileName);
}

// Return the path of external storage
Future<String> getExternalPath() async {
  var dir = await getExternalStorageDirectory();

  return dir.path;
}

// Return the path of local storage
Future<String> getLocalPath() async {
  var dir = await getApplicationDocumentsDirectory();

  return dir.path;
}

// Return list of files from external directory
Future<List<CustomFile>> loadFiles() async {
  var permission = await Permission.storage.status;
  if (!permission.isGranted) {
    await Permission.storage.request();
  }

  List<CustomFile> files = new List();

  String path = await getExternalPath();

  List<String> allFiles =
      io.Directory("$path").listSync().map((e) => e.path).toList();
  for (String i in allFiles) {
    files.add(CustomFile(
        filePath: path + "/",
        fileName: basename(i),
        fileExtension: extension(i)));
  }
  files = files.where((file) => file.fileExtension != "").toList();

  return files;
}

// Return the path of selected file
Future<String> getOtherFilePath() async {
  String path = await FilePicker.getFilePath();

  return path;
}

// Move file to app external file directory
Future<void> moveFile(String pathFrom) async {
  String pathTo = await getExternalPath(); // Path to our new file
  String fileName = basename(pathFrom); // Get file name

  io.File(pathFrom).copy(pathTo + "/" + fileName);
}
