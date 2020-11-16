import 'package:flutter/material.dart';
import 'package:security_docs/utils/fileUtils.dart';
import 'package:security_docs/icons/CustomIcons.dart';

Widget fileWidget({String filePath, String fileName, String fileExtension}) {
  return Column(children: [
    Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            child: icons[fileExtension] ?? icons["other"],
            height: 50,
          ),
        ),
        Expanded(
            flex: 6,
            child: Container(
              child: Text(
                fileName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              height: 50,
            )),
        Expanded(
          flex: 2,
          child: Container(
            child: Center(
              child: RaisedButton(
                padding: EdgeInsets.all(5.0),
                onPressed: () {
                  openFile(filePath: filePath, fileName: fileName);
                },
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
  ]);
}
