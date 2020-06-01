//import 'package:badges/badges.dart';
import 'package:e_commerce_bloc/blocs/products_home_bloc/products_home_bloc.dart';
import 'package:flutter/material.dart';

customBadge(IconData icon, bool isAppBar, double top, double right, double height, double width){
  return StreamBuilder(
    stream: productsHomeBloc.notificationOut,
    builder: (context, snapshot) {
      if(snapshot.data==0 || snapshot.data==null)
      return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Icon(icon, color: Colors.black),
      );
      else
      return Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: isAppBar? 10:15),
            child: Icon(icon, color: Colors.black),
          ),
          Positioned(
            top: top,
            right: right,
            child: Container(
              height: height, 
              width: width,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(snapshot.data.toString(),
                   style: TextStyle(color: Colors.white, fontSize: 9.5)
                ),
              ),
            ),
          )
        ],
      );
    }
  );
}