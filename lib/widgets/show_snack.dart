import 'package:flutter/material.dart';

ShowSnack(String text, Color textColor, Color backgroundColor){
  return  SnackBar(content: Text(text, 
    style: TextStyle(color: textColor)), 
    backgroundColor: backgroundColor, 
    duration: Duration(milliseconds: 1500),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
    )
  ); 
}