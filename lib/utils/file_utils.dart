import 'package:path_provider/path_provider.dart';
import 'package:security_docs/models/custom_file.dart';
import 'dart:io' as io;
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart';
import 'package:aes_crypt/aes_crypt.dart';

/// Return the path to external storage
Future<String> getExternalPath() async {
  var dir = await getExternalStorageDirectory();

  return dir.path;
}

/// Return the path to local storage
Future<String> getLocalPath() async {
  var dir = await getApplicationDocumentsDirectory();

  return dir.path;
}

/// Check permission to read and write files
/// and make request if permission is not granted
Future<void> getPermission() async {
  var permission = await Permission.storage.status;
  if (!permission.isGranted) {
    await Permission.storage.request();
  }
}

/// Open file provider to select new file to copy and return it's path
Future<String> getPathOfNewFile() async {
  String path = await FilePicker.getFilePath();

  return path;
}

/// Return the original file extension of file if it
/// is encrypted. Else return empty string
String getFileExtension(String path) {
  if (extension(path) == '.aes') {
    String newExtension = path.replaceAll('.aes', '');
    return extension(newExtension);
  } else {
    return "";
  }
}

/// Return the original file name if file is encrypted.
String getFileName(String path) {
  String fileName = basename(path);
  if (fileName.contains('.aes')) {
    return fileName.replaceAll('.aes', '');
  } else {
    return fileName;
  }
}

/// Load all file path from external storage
/// and return list of CustomFile class
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

/// Encrypt source file and create new encrypted file
Future<void> encryptFile(Map pathMap) {
  var crypt = AesCrypt('ubnkth');
  crypt.setOverwriteMode(AesCryptOwMode.on);
  crypt.encryptFileSync(pathMap['oldPath'], pathMap['newPath']);
}

/// Decrypt source file and create new decrypted file
Future<String> decryptFile(String path) async {
  var crypt = AesCrypt('ubnkth');
  crypt.setOverwriteMode(AesCryptOwMode.on);
  String newPath = crypt.decryptFileSync(path);

  return newPath;
}

/// Delete all decrypted files in the external storage
Future<void> deleteAllEncrypted() async {
  String path = await getExternalPath();

  List<String> allFiles =
      io.Directory("$path").listSync().map((e) => e.path).toList();
  for (String i in allFiles) {
    if (extension(i) != '.aes' && extension(i) != "") io.File(i).delete();
  }
}

/// Delete all files in the external storage
Future<void> deleteAllFiles() async {
  await getPermission();

  String path = await getExternalPath();

  List<String> allFiles =
      io.Directory("$path").listSync().map((e) => e.path).toList();
  for (String i in allFiles) {
    if (extension(i) != "") io.File(i).delete();
  }
}
