import 'package:flutter/material.dart';
import 'package:security_docs/views/CustomIcons.dart';

class FileWidget extends StatelessWidget {
  String fileName;
  String fileExtension;
  Image icon;

  FileWidget({String fileName, String fileExtension}){
    this.fileName = fileName;
    this.fileExtension = fileExtension;
    this.icon = icons[fileExtension] ?? icons["other"];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                child: this.icon,
                height: 50,
              ),
            ),
            Expanded(
                flex: 6,
                child: Container(
                  child: Text(
                    "$fileExtension",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  height: 50,
                )
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: Center(
                  child: RaisedButton(
                    onPressed: (){print("Pressed");},
                    child: Text("Open"),
                    color: Colors.grey[100],
                  ),
                ),
                height: 50,
                padding: EdgeInsets.only(right: 5.0),
              ),
            )
          ],
        ),
          Divider(
            color: Colors.grey[500],
            indent: 20,
            endIndent: 5,
          )
        ]
    );
  }
}
