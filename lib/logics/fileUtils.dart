import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:security_docs/logics/CustomFile.dart';
import 'dart:io' as io;
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> openFile({String filePath, String fileName}) async {
  await OpenFile.open(filePath + fileName);
}


Future<String> getExternalPath() async {
  var dir  = await getExternalStorageDirectory();

  return dir.path;
}

Future<String> getLocalPath() async{
  var dir = await getApplicationDocumentsDirectory();

  return dir.path;
}

Future<List<CustomFile>> loadFiles() async {
  // Create list of custom files
  List<CustomFile> files = new List();

  //Get path to file directory
  String path = await getExternalPath();

  // Create string list of all files
  List<String> allFiles = io.Directory("$path").listSync().map((e) => e.path).toList();
  //
  for (String i in allFiles){
    files.add(CustomFile(filePath: path + "/", fileName: i.split("/").last, fileExtension: i.split(".").last));
  }

  return files;
}

Future<String> getOtherFilePath() async{
  String path = await FilePicker.getFilePath();

  return path;
}

void moveFile(String pathFrom) async{
  String pathTo = await getExternalPath();
  String fileName = pathFrom.split("/").last;
  String fileExtension = pathFrom.split(".").last;

  var permission = await Permission.storage.status;

  if (!permission.isGranted){
    await Permission.storage.request();
  }

  try{
    await io.File(pathFrom).rename(pathTo+"/"+fileName);
  } on io.FileSystemException catch (e){
    var copy = await io.File(pathFrom).copy(pathTo + "/" + fileName);
    await io.File(pathFrom).delete();
  }

}