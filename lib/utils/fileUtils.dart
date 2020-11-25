import 'package:path_provider/path_provider.dart';
import 'package:security_docs/models/CustomFile.dart';
import 'dart:io' as io;
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart';
import 'package:aes_crypt/aes_crypt.dart';

Future<String> getExternalPath() async {
  var dir = await getExternalStorageDirectory();

  return dir.path;
}

Future<String> getLocalPath() async {
  var dir = await getApplicationDocumentsDirectory();

  return dir.path;
}

Future<void> getPermission() async {
  var permission = await Permission.storage.status;
  if (!permission.isGranted) {
    await Permission.storage.request();
  }
}

Future<String> getOtherFilePath() async {
  String path = await FilePicker.getFilePath();

  return path;
}

String getFileExtension(String path) {
  if (extension(path) == '.aes') {
    String newExtension = path.replaceAll('.aes', '');
    return extension(newExtension);
  } else {
    return "";
  }
}

String getFileName(String path) {
  String fileName = basename(path);
  if (fileName.contains('.aes')) {
    return fileName.replaceAll('.aes', '');
  }
  else {
    return fileName;
  }
}

Future<List<CustomFile>> loadFiles() async {
  await getPermission();

  List<CustomFile> files = List();

  String path = await getExternalPath();

  List<String> allFiles =
  io.Directory("$path").listSync().map((e) => e.path).toList();
  for (String i in allFiles) {
    files.add(CustomFile(
        filePath: i,
        fileName: getFileName(i),
        fileExtension: getFileExtension(i)));
  }
  files = files.where((file) => file.fileExtension != "").toList();

  return files;
}

Future<void> encryptFile(Map pathMap) {
  var crypt = AesCrypt('ubnkth');
  crypt.setOverwriteMode(AesCryptOwMode.on);
  crypt.encryptFileSync(pathMap['oldPath'], pathMap['newPath']);
}

Future<String> decryptFile(String path) async {
  var crypt = AesCrypt('ubnkth');
  crypt.setOverwriteMode(AesCryptOwMode.on);
  String newPath = crypt.decryptFileSync(path);

  return newPath;
}

Future<void> deleteAllEncrypted() async {
  String path = await getExternalPath();

  List<String> allFiles = io.Directory("$path").listSync().map((e) => e.path).toList();
  for (String i in allFiles) {
    if (extension(i) != '.aes' && extension(i) != "") io.File(i).delete();
  }
}

Future<void> deleteAllFiles() async {
  await getPermission();

  String path = await getExternalPath();

  List<String> allFiles = io.Directory("$path").listSync().map((e) => e.path).toList();
  for (String i in allFiles) {
    if (extension(i) != "") io.File(i).delete();
  }
}

