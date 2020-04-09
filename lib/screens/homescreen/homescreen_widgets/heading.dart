import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

heading(String text, dynamic className){
  return Row(
    children: <Widget>[
      Text(text,
        style: GoogleFonts.sourceSansPro( textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
      ),
      Spacer(),
      GestureDetector(
        onTap: null,//TODO navigate
        child: Row(children: [
          Text('View more', style: GoogleFonts.sourceSansPro(fontSize: 16, color: Colors.blue)),
          Icon(Icons.arrow_forward, color: Colors.blue, size: 16,)
        ],)
      ),
    ],
  );
}