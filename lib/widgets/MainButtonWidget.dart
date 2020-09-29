import 'package:flutter/material.dart';
import 'package:security_docs/logics/fileUtils.dart';

enum MenuOption {addFace, addFile}

void choiceAction(MenuOption action){
  if (action == MenuOption.addFace){
    print("Add face");
  }
  else if(action == MenuOption.addFile){
    Future<String> path = getOtherFilePath();
    path.then((value) {
      moveFile(value);
    });
  }
}

Widget PopUpButton () {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.blue,
      ),
      child: PopupMenuButton(
          onSelected: choiceAction,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
          icon: Icon(Icons.add, color: Colors.white, size: 30,),
          itemBuilder: (BuildContext context){
            return <PopupMenuEntry<MenuOption>>[
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.tag_faces, size: 35,),
                    Container(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Center(
                        child: Text("Add face",
                        style: TextStyle(
                          fontSize: 16,
                        ),),
                      ),
                    )
                  ],
                ),
                value: MenuOption.addFace,),
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.insert_drive_file, size: 35,),
                    Container(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Center(
                        child: Text("Add file",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        ),
                      ),
                    ),
                  ],
                ),
                value: MenuOption.addFile,)
            ];
      }),
    );
}
