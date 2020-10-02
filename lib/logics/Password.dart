import 'package:security_docs/logics/fileUtils.dart';
import 'dart:io';

class Password{
  String password;

  // Check if file with password exist in app folder
  Future<bool> checkIfPasswordExist() async{
    String localPath = await getLocalPath();

    return File(localPath + "/" + "password.txt").existsSync();
  }

  // Set password if it does not exist
  setPassword({String password, String path}){
    this.password = password;

    File(path + "/" + "password.txt").writeAsStringSync(this.password);
  }

  // Get password if it exist
  String getPassword({String path}){
    return File(path + "/" + "password.txt").readAsStringSync();
  }
}