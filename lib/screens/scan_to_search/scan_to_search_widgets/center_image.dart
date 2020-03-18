import 'package:flutter/material.dart';

centerImage(String text, String img){
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(img, height:100, width: 100),
            ),
          )
        ),
        Center(
           child: Padding(padding: EdgeInsets.only(top:200),
            child: Text(text, textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)
            )
           ),
        )
      ],
    );
  }