import 'dart:io';
import 'package:flutter/material.dart';

showDialogBox(BuildContext context, String title, String content, dynamic confirm){
  return showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(title),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Text(content),
          actions: <Widget>[
            confirm == 1? Container() : FlatButton(child: Text('Confirm'), onPressed: confirm==null? () => exit(0) : () => confirm ),
            FlatButton(child: Text(confirm==1? 'Ok' : 'Cancel'), onPressed: () => Navigator.pop(c, false))
          ],
        )
      );
}