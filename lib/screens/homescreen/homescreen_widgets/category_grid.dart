import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

showGrid(String img1, String text1, var nav1, String img2, String text2, var nav2){
  return  Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        categoryGrid(img1, text1, nav1),
        categoryGrid(img2, text2, nav2)
      ],
    )
  );
}

categoryGrid(String image, String text, var screen){
  return InkWell(
    onTap: () => screen,//add navigate()
      child: Container(
      child:Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: <Widget>[
            Image.asset(image, height: 100, width: 100),
            Container(
              height: 30, width: 130,
              child: Center(
                child: Text(text, style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.w600))
              ),
            )
          ],
        )
      ),
    ),
  );
}