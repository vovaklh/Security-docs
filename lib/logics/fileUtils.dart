import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:security_docs/logics/CustomFile.dart';
import 'dart:io' as io;


Future<void> openFile({String filePath, String fileName}) async {
  await OpenFile.open(filePath + fileName);
}

Future<String> getLocalPath() async {
  final dir = await getExternalStorageDirectory();

  return dir.path;
}

Future<List<CustomFile>> loadFiles() async {
  // Create list of custom files
  List<CustomFile> files = new List();

  //Get path to file directory
  String path = await getLocalPath();

  // Create string list of all files
  List<String> allFiles = io.Directory("$path").listSync().map((e) => e.path).toList();
  //
  for (String i in allFiles){
    files.add(CustomFile(filePath: path + "/", fileName: i.split("/").last, fileExtension: i.split(".").last));
  }

  return files;
}

List<CustomFile> convertList(){
  List<CustomFile> files = new List();

  Future<List<CustomFile>> futureFiles = loadFiles();

  futureFiles.then((value) {
    value.forEach((element) {
      files.add(CustomFile(filePath: element.filePath, fileName: element.fileName, fileExtension: element.fileExtension));
    }
      );
  });

  print(files.length);

  return files;
}