import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../navigate.dart';

appBarBackArrow(BuildContext context, String text, dynamic className, dynamic refresh){
  return AppBar(
    elevation: 1.5,
    backgroundColor: Colors.white,
    centerTitle: true,
    title: Text(text, style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.black)),
    leading: IconButton(
      icon: Icon(Icons.arrow_back_ios,), 
      color: Colors.black,
      onPressed: ()=> className!=null? navigate(context, className) 
        : Navigator.of(context).pop()
    ),
    actions: refresh!=null ? [IconButton(icon: Icon(Icons.refresh),color: Colors.black, onPressed: ()=> refresh(),)]: null,
  );
}