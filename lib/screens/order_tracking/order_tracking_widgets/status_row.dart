import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

statusRow(String status, String desc, dynamic date){
  return Padding(
    padding: EdgeInsets.only(left: 20, top: 15, bottom: status=='Delivered'? 0 : 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(status, style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.w600,fontSize: 20, color: date==null? Colors.grey[300]: status=='Delivered'? Colors.green : Colors.blue)),
        status=='Delivered' ? Container() : date!=null ? 
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 5),
          child: Text(desc, style: GoogleFonts.sourceSansPro(fontSize: 15)),
        ) : SizedBox(height: 60),
        date!=null ? Text('Date: $date', style: GoogleFonts.sourceSansPro(fontSize: 16, color: Colors.grey[600])) : Container()
      ],
    ),
  );
}