import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/screens/description_screen/description_screen_widgets/arcore_scene.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ARButton(BuildContext context, String id, String url){
  return Container(
    width: MediaQuery.of(context).size.width,
    alignment: Alignment.centerRight,
    child: GestureDetector(
      onTap: () => navigate(context, ARScreen(id: id, url: url)),
      child: Card(
        elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Wrap(
              children: [
                Text('AUGMENTED REALITY', style: GoogleFonts.sourceSansPro(fontSize: 16, fontWeight: FontWeight.w600)),
                SizedBox(width: 5),
                Image.asset('AR.png', height: 23, width: 23)
              ],
            ),
          ),
        ),
    ),
  );
}