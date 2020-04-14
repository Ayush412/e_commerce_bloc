import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

applyButton(){
  return Container(
    height: 30,
    width: 80,
    decoration: BoxDecoration(
      color: Colors.blue[400],
      borderRadius: BorderRadius.circular(5)
    ),
    child: Center(
      child: Text('APPLY', style: GoogleFonts.sourceSansPro(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
    ),
  );
}