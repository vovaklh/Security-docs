import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:security_docs/logics/CustomFile.dart';
import 'dart:io' as io;
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

// Open file on device
Future<void> openFile({String filePath, String fileName}) async {
  await OpenFile.open(filePath + fileName);
}

// Get path to external storage directory
Future<String> getExternalPath() async {
  var dir  = await getExternalStorageDirectory();

  return dir.path;
}

// Get path to local storage directory
Future<String> getLocalPath() async{
  var dir = await getApplicationDocumentsDirectory();

  return dir.path;
}

// Load files from external storage
Future<List<CustomFile>> loadFiles() async {
  // check permission
  var permission = await Permission.storage.status;

  //Request permission If app has not permission to read and write files
  if (!permission.isGranted){
    await Permission.storage.request();
  }

  // Create empty list of custom files
  List<CustomFile> files = new List();

  //Get path to external file directory
  String path = await getExternalPath();

  // Create list of type String with all path to files
  List<String> allFiles = io.Directory("$path").listSync().map((e) => e.path).toList();

  //Add to our CustomFile list by splitting "/" for getting file name and "." for getting file extension
  for (String i in allFiles){
    files.add(CustomFile(filePath: path + "/", fileName: i.split("/").last, fileExtension: i.split("/").last.split(".").last));
  }

  return files;
}

// Choose file on device to move to app file directory
Future<String> getOtherFilePath() async{
  String path = await FilePicker.getFilePath();

  return path;
}

// Move file to app external app file directory
void moveFile(String pathFrom) async{
  String pathTo = await getExternalPath(); // Path to our new file
  String fileName = pathFrom.split("/").last; // Get file name


  // Check permission status
  var permission = await Permission.storage.status;

  // Make request if app has not permission
  if (!permission.isGranted){
    await Permission.storage.request();
  }

  // Try just rename file with new destination folder
  try{
    await io.File(pathFrom).rename(pathTo+"/"+fileName);
  } on io.FileSystemException catch (e){ //Else make copy, write to app folder and remove old file
    var copy = await io.File(pathFrom).copy(pathTo + "/" + fileName);
    await io.File(pathFrom).delete();
  }

}