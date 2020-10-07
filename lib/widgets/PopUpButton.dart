import 'package:flutter/material.dart';
import 'package:security_docs/logics/fileUtils.dart';
import 'package:security_docs/logics/Password.dart';

enum MenuOption {addFace, addFile, test}

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

  else if (choice == MenuOption.test){
    Navigator.pushReplacementNamed(context, "/facepage");
  }
}

class PopUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                value: MenuOption.addFile,),
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.camera, size: 35,),
                    Container(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Center(
                        child: Text("Test",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                value: MenuOption.test,)
            ];
          }),
    );
  }
}
