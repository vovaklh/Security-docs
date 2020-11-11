import 'package:flutter/material.dart';
import 'package:security_docs/utils/fileUtils.dart';
import 'package:security_docs/logics/Password.dart';

enum MenuOption {addFace, addFile}


void choiceAction(MenuOption choice, BuildContext context){
  if (choice == MenuOption.addFace){
    Password().checkIfPasswordExist().then((passwordExist) {
      if(!passwordExist){
          Navigator.pushReplacementNamed(context, "/passwordpage");
      }
    });
  }
  else if(choice == MenuOption.addFile){
    Future<String> path = getOtherFilePath();
    path.then((value) {
      if (value != null) { // If user choose file
        moveFile(value);
        }
    });
  }
}

Widget popupButton(BuildContext context){
  return Container(
    height: 50,
    width: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blue,
    ),
    child: PopupMenuButton(
        onSelected: (choice) => choiceAction(choice, context),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
        icon: Icon(Icons.add, color: Colors.white, size: 30,),
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<MenuOption>>[
            buttonItem(MenuOption.addFace, "Add face", Icons.tag_faces),
            buttonItem(MenuOption.addFile, "Add file", Icons.insert_drive_file),
          ];
        }),
  );
}

Widget buttonItem(MenuOption name, String text, IconData icon){
  return PopupMenuItem(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, size: 35,),
        Container(
          padding: EdgeInsets.only(left: 5.0),
          child: Center(
            child: Text(text,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    ),
    value: name,);
}
