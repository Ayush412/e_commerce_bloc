import 'package:e_commerce_bloc/screens/notifications_list/notifications_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../navigate.dart';

appBarBackArrow(BuildContext context, String text, bool isNotifs){
  return AppBar(
    elevation: 1.5,
    backgroundColor: Colors.white,
    centerTitle: true,
    title: Text(text, style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.black)),
    leading: IconButton(
      icon: Icon(Icons.arrow_back_ios,), 
      color: Colors.black,
      onPressed: ()=> isNotifs? navigate(context, NotificationList()): Navigator.of(context).pop()),
  );
}