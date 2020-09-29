import 'package:security_docs/logics/fileUtils.dart';
import 'dart:io';

class Password{
  String password;

  Future<bool> checkIfPasswordExist() async{
    String localPath = await getLocalPath();

    return File(localPath + "/" + "password.txt").existsSync();
  }

  setPassword({String password, String path}){
    this.password = password;

    File(path + "/" + "password.txt").writeAsStringSync(this.password);
  }

  String getPassword({String path}){
    return File(path + "/" + "password.txt").readAsStringSync();
  }
}