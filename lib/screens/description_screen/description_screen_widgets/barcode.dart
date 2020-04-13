import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

generateBarcode(String docID){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      QrImage(
        size: 150,
        data: docID,
        version: QrVersions.auto,
      ),
      Container(
        width: 250,
        child: Expanded(
          child: Text("Scan this QR code on another device using our App to instantly view this product.", 
            textAlign: TextAlign.center,
            style: GoogleFonts.sourceSansPro(fontSize: 12),
          )
        )
      )
    ],
  );
}