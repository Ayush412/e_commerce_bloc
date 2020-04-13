import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/user_cart_bloc/user_cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

cartProductCard(DocumentSnapshot product){
  return Padding(
    padding: const EdgeInsets.only(top: 30),
    child: Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          Image.network(product.data['imgurl'], height: 100, width: 100,),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  child: Text(product.data['ProdName'],
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600]
                    )
                  )
                ),
                Padding(padding: const EdgeInsets.only(top: 40),
                child: Text('QR. ${NumberFormat('#,###').format(product.data['ProdCost'])}',
                  style: GoogleFonts.sourceSansPro(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black
                  )
                  )
                )
              ]
            )
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.add),
                color: Colors.black,
                onPressed: () => userCartBloc.addVal(product.documentID),
              ),
              Text(product.data['Quantity'].toString(), 
              style: GoogleFonts.sourceSansPro(fontSize: 16, color: Colors.blue),),
                IconButton(
                icon: Icon(Icons.remove),
                color: Colors.black,
                onPressed: () => product.data['Quantity']>1 ? userCartBloc.remVal(product.documentID) : null,
              ),
          ],)
        ]),
      ),
    ),
  );
}