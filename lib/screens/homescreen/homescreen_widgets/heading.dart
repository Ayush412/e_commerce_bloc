import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/screens/full_product_list/full_product_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

heading(BuildContext context, String text, String option){
  return Row(
    children: <Widget>[
      Text(text,
        style: GoogleFonts.sourceSansPro( textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
      ),
      Spacer(),
      GestureDetector(
        onTap: () => navigate(context, FullProductList(category: option)),
        child: Row(children: [
          Text('View more', style: GoogleFonts.sourceSansPro(fontSize: 16, color: Colors.blue)),
          Icon(Icons.arrow_forward, color: Colors.blue, size: 16,)
        ],)
      ),
    ],
  );
}