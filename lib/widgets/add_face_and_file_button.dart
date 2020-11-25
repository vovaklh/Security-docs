import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:security_docs/utils/file_utils.dart';
import 'package:security_docs/logics/face_verificator.dart';
import 'package:path/path.dart';

enum MenuOption { addFace, addFile }

/// Encrypt the chosen file and added it to stream
Future<void> moveAndAddFile(Function addFile) async {
  String pathTo = await getExternalPath();
  getPathOfNewFile().then((path) {
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

/// Function to controle user choice
void choiceAction(MenuOption choice, Function goToFacePage, Function addFile) {
  if (choice == MenuOption.addFace) {
    FaceVerificator faceVerificator = FaceVerificator();
    faceVerificator.checkIfFaceExist().then((faceExist) {
      if (!faceExist) goToFacePage();
    });
  } else if (choice == MenuOption.addFile) {
    moveAndAddFile(addFile);
  }
}

/// Button to add file or face
Widget addFaceAndFileButton(Function goToFacePage, Function addFile) {
  return Container(
    height: 50,
    width: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blue,
    ),
    child: PopupMenuButton(
        onSelected: (choice) => choiceAction(choice, goToFacePage, addFile),
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

/// Return item of popupbutton
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
