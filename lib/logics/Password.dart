import 'file:///D:/Android_projects/security_docs/lib/utils/fileUtils.dart';
import 'dart:io';

class Password{
  String _password;

  // Return true if file with password exists in directory
  Future<bool> checkIfPasswordExist() async{
    String localPath = await getLocalPath();

    return File(localPath + "/" + "password.txt").existsSync();
  }

  // Set password if it does not exist
  setPassword({String password}) async{
    String path =  await getLocalPath();
    this._password = password.hashCode.toString();

    File(path + "/" + "password.txt").writeAsStringSync(this._password);
  }

  // Return the password
  Future<String> getPassword() async {
    String path = await getLocalPath();

    return File(path + "/" + "password.txt").readAsStringSync();
  }
}