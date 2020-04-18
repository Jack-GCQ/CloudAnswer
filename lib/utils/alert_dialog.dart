import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertDialogUtil {
  static Future showAlertDialog(
      BuildContext context, String content, List<String> actionsTitle, List<VoidCallback> actions) async {
    if (Platform.isIOS) {
      showCupertinoDialog<Null>(
          context: context, //BuildContext对象
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text(
                "提示",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              content: Text(content),
              actions: <Widget>[
                if (actionsTitle.length == 2)
                  CupertinoDialogAction(
                    child: Text(actionsTitle[1]),
                    onPressed: actions[1],
                  ),
                CupertinoDialogAction(
                  child: Text(actionsTitle[0]),
                  onPressed: actions[0],
                ),
              ],
            );
          });
      return true;
    }
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("提示"),
            content: Text(content),
            actions: <Widget>[
              new FlatButton(
                child: Text(actionsTitle[0]),
                onPressed: actions[0],
              ),
              if (actionsTitle.length == 2)
                new FlatButton(
                  child: Text(actionsTitle[1]),
                  onPressed: actions[1],
                ),
            ],
          );
        });
  }
}
