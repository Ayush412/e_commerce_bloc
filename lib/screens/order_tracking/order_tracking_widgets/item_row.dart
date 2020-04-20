import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

itemRow(DocumentSnapshot dataMap, List items){
  return ListView.builder(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: items.length,
    itemBuilder: (context, index){
      print(items[index]);
      return Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(dataMap['Items'][items[index]]['imgurl'], height: 80, width: 80),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dataMap['Items'][items[index]]['ProdName'], 
                    style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800])
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                      child: Text('QR. ${dataMap['Items'][items[index]]['ProdCost']}',
                        style: GoogleFonts.sourceSansPro(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.grey[600])
                      ),
                  )
                ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60),
              child: Text('x ${dataMap['Items'][items[index]]['Quantity']}',
                style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold),
              ),
            )
          ]
        ),
      );
    },
  );
}