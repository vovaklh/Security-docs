import 'package:flutter/material.dart';

enum MenuOption {addFace, addFile}

class PopUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.blue,
      ),
      child: PopupMenuButton(
      shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
          icon: Icon(Icons.add, color: Colors.white, size: 40,),
          itemBuilder: (BuildContext context){
            return <PopupMenuEntry<MenuOption>>[
              PopupMenuItem(
                child: Text("Add face"),
                value: MenuOption.addFace,),
              PopupMenuItem(
                child: Text("Add file"),
                value: MenuOption.addFile,)
            ];
      }),
    );
  }
}
