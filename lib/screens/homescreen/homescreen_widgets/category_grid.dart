import 'package:e_commerce_bloc/navigate.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

showGrid(BuildContext context, String img1, String text1, dynamic nav1, String img2, String text2, dynamic nav2){
  return  Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        categoryGrid(context, img1, text1, nav1),
        categoryGrid(context, img2, text2, nav2)
      ],
    )
  );
}

categoryGrid(BuildContext context, String image, String text, dynamic screen){
  return InkWell(
    onTap: () => navigate(context, screen),
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