import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

productCard(DocumentSnapshot product){
  int disc = product.data['Discount'];
  int newVal = product.data['ProdCost']-((product.data['ProdCost']*disc/100)).round();
  return Container(
    width: 180,
    height: 225,
    child: Card(
      elevation: 2.2,
      shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Center(child: Image.network(product.data['imgurl'], height: 100, width: 100)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 5, right: 5),
                child: Expanded(
                    child: Text(product.data['ProdName'],
                    style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Expanded(
                child: Align(alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('QR. ${product.data['ProdCost']}', style: GoogleFonts.sourceSansPro(
                          fontSize: 15, 
                          fontWeight: FontWeight.w700, 
                          decoration: disc != 0 ? TextDecoration.lineThrough : null,
                          decorationThickness: 1.7,
                          decorationColor: Colors.red
                        )),
                        Row(
                          children: List.generate(5, (val) {
                            return Icon(
                              val < product.data['Rate'] ? Icons.star : Icons.star_border,
                              color: Colors.black,
                              size: 12,
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ]
          ),
          disc != 0 ? Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 5, top: 3),
              child: Text('$disc% off', style: GoogleFonts.sourceSansPro(fontSize: 13, color: Colors.green)),
            ),
          ) : Container(),
          disc != 0 ? Positioned(
            bottom: 25,
            left: 8,
            child: Text('QR. $newVal', style: GoogleFonts.sourceSansPro(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.green)
          )
          ) : Container()
        ]
      )
    ),
  );
}