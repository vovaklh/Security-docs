import 'package:flutter/material.dart';
import 'package:security_docs/logics/fileUtils.dart';
import 'package:security_docs/pages/CustomIcons.dart';

class FileWidget extends StatelessWidget {
  String filePath;
  String fileName;
  String fileExtension;
  Image icon;

  FileWidget({String filePath, String fileName, String fileExtension}){
    this.filePath = filePath;
    this.fileName = fileName;
    this.fileExtension = fileExtension;
    this.icon = icons[fileExtension] ?? icons["other"];
  }


  @override
  Widget build(BuildContext context) {
    return Column(
        children: [Row(
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
                    "$fileName",
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
                    padding: EdgeInsets.all(5.0),
                    onPressed: () {openFile(filePath: filePath, fileName: fileName);},
                    child: Text("Open"),
                    color: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
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
