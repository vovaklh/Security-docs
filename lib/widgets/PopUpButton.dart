import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:security_docs/utils/fileUtils.dart';
import 'package:security_docs/logics/Password.dart';
import 'package:path/path.dart';

enum MenuOption { addFace, addFile }

Future<void> moveAndAddFile(Function addFile) async {
  String pathTo = await getExternalPath();
  getOtherFilePath().then((path) {
    if (path != null) {
      String fileName = basename(path);
      String newPath = pathTo + "/" + fileName + '.aes';

      Map mapPath = Map();
      mapPath['oldPath'] = path;
      mapPath['newPath'] = newPath;

      compute(encryptFile, mapPath).then((value) => addFile());
    }
  });
}

void choiceAction(MenuOption choice, BuildContext context, Function addFile) {
  if (choice == MenuOption.addFace) {
    Password().checkIfPasswordExist().then((passwordExist) {
      if (!passwordExist) {
        Navigator.pushReplacementNamed(context, "/passwordSettingPage");
      }
    });
  } else if (choice == MenuOption.addFile) {
    moveAndAddFile(addFile);
  }
}

Widget popupButton(BuildContext context, Function function) {
  return Container(
    height: 50,
    width: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blue,
    ),
    child: PopupMenuButton(
        onSelected: (choice) => choiceAction(choice, context, function),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        icon: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<MenuOption>>[
            buttonItem(MenuOption.addFace, "Add face", Icons.tag_faces),
            buttonItem(MenuOption.addFile, "Add file", Icons.insert_drive_file),
          ];
        }),
  );
}

Widget buttonItem(MenuOption name, String text, IconData icon) {
  return PopupMenuItem(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 35,
        ),
        Container(
          padding: EdgeInsets.only(left: 5.0),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    ),
    value: name,
  );
}
