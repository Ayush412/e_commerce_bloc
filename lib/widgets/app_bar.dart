import 'package:flutter/material.dart';

appBar(String title,dynamic leading, List<Widget> actions){
  return AppBar(
    toolbarOpacity: 0.5,
    elevation: 0.0,
    title: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    centerTitle: true,
    backgroundColor: Colors.black,
    leading: leading,
    actions: actions,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(25))),
  );
}