import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/screens/order_tracking/order_tracking.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ordersCard(BuildContext context, DocumentSnapshot order){
  return Padding(
    padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
    child: InkWell(
      onTap: () => navigate(context, OrderTracking(order: order)),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(children: [
              Text('Order No. :', style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),),
              Padding(padding: const EdgeInsets.only(left: 10),
              child: Text(order.documentID, style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),),
              )
            ]),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(children: [
                Text('Amount :', style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),),
                Padding(padding: const EdgeInsets.only(left: 10),
                child: Text('QR. ${order.data['Amount']}', style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey))
                )
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                children: [
                Text('Date :', style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),),
                Padding(padding: const EdgeInsets.only(left: 10),
                child: Text(order.data['Date'], style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey))
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 60),
                  child: Text(order.data['Status'], style: GoogleFonts.sourceSansPro(fontSize: 17, fontWeight: FontWeight.bold, 
                    color: order.data['Status']=='Delivered'? Colors.green : Colors.blue[400]
                  )),
                ),
              ]),
            ),
          ])
        ),
      ),
    )
  );
}