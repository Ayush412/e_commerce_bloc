import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

viewCount(DocumentSnapshot snap){
  return Container(
    height: 30,
    child: Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Container(
          height: 25,
          decoration: BoxDecoration(
              color: Color(0xffffc966),
              borderRadius:
                  BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10, right: 10, top: 3),
            child: Text(
              snap.data['Views'] == 0 ? 'No views'
                : snap.data['Views'] == 1 ? "1 view"
                  : '${snap.data['Views']} views',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black
              )
            ),
          ),
        )
      )
    )
  );
}