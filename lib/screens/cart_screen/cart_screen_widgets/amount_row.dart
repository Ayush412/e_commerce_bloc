import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
amountRow(String text, String amount, Color color){
  return Padding(
    padding: const EdgeInsets.only(top: 20, left: 40, right: 40, ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text(text, 
            style: GoogleFonts.sourceSansPro(color: Colors.grey[600], fontWeight: FontWeight.w600, fontSize: 20)
          ),
        ),
        Text(amount, 
          style: GoogleFonts.sourceSansPro(color: color, fontWeight: FontWeight.bold, fontSize: 20)
        ),
      ]
    ),
  );
}