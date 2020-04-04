import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

searchBar(BuildContext context, TextEditingController controller, FocusNode node){
  return Container(
    height: 40,
    width: MediaQuery.of(context).size.width/1.5,
    child: Theme(
      data: ThemeData(
        primaryColor: Colors.transparent,
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.sourceSansPro(),
        focusNode: node,
        textAlignVertical: TextAlignVertical.bottom,
        textInputAction: TextInputAction.search,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          filled: true,
          hintText: 'Search Products',
          prefixIcon: Icon(Icons.search, color: Colors.grey,),
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
        ),
      ),
    ),
  );
}