import 'package:flutter/material.dart';

optionCard(String text, dynamic onTap, String img){
  return InkWell(
    highlightColor: Colors.grey,
    onTap: () => onTap,
    child: Container(
      height: 220, width: 260,
      child: Card(
        color: Colors.black,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(text, style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),),
                )
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(color: Colors.white, 
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)
                    )
                  ),
                  child: Center(
                      child: Image.asset(img, height: 100, width: 100, color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        )
      ),
    ),
  );
}