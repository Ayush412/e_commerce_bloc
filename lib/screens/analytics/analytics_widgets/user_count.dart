import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

userCount(){
  return Column(children: [
    Text('Total Users:', style: GoogleFonts.sourceSansPro(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500)),
    Padding(padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder(
        stream: Firestore.instance.collection('analytics').document('users').snapshots(),
        builder: (context, snap){
          return Text(snap.data['Total'].toString(), style: GoogleFonts.sourceSansPro(fontSize: 23, color: Colors.white),);
        }
      ),
    )
  ]);
}