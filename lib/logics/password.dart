import 'package:security_docs/utils/file_utils.dart';
import 'dart:io';

class Password {
  String _password;

  /// Check if file with password exist in local storage
  Future<bool> checkIfPasswordExist() async {
    String localPath = await getLocalPath();

    return File(localPath + "/" + "password.txt").existsSync();
  }

  /// Write the hash of new password to txt file
  Future<void> setPassword({String password}) async {
    String path = await getLocalPath();
    this._password = password.hashCode.toString();

    File(path + "/" + "password.txt").writeAsStringSync(this._password);
  }

  /// Return the hash of password
  Future<String> getPassword() async {
    String path = await getLocalPath();

    return File(path + "/" + "password.txt").readAsStringSync();
  }
}
