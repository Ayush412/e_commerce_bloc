import 'package:badges/badges.dart';
import 'package:e_commerce_bloc/blocs/products_home_bloc/products_home_bloc.dart';
import 'package:flutter/material.dart';

customBadge(IconData icon){
  return StreamBuilder(
    stream: productsHomeBloc.notificationOut,
    builder: (context, snapshot) {
      if(snapshot.data==0 || snapshot.data==null)
      return Icon(icon, color: Colors.black);
      else
      return Badge(
        position: BadgePosition.topRight(top: 1, right: 0),
        animationDuration: Duration(milliseconds: 300),
        animationType: BadgeAnimationType.slide,
        badgeContent: Text(snapshot.data.toString(),
          style: TextStyle(color: Colors.white, fontSize: 9.5),
        ),
        child: Icon(icon, color: Colors.black)
      );
    }
  );
}