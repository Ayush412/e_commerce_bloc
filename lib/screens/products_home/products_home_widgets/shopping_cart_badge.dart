import 'package:badges/badges.dart';
import 'package:e_commerce_bloc/blocs/products_home_bloc/products_home_bloc.dart';
import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/screens/user_cart/user_cart.dart';
import 'package:flutter/material.dart';

shoppingCartBadge(){
  return StreamBuilder(
    stream: productsHomeBloc.cartOut,
    builder: (context, snapshot) {
      if(snapshot.data>0)
      return Badge(
        position: BadgePosition.topRight(top: 0, right: 3),
        animationDuration: Duration(milliseconds: 300),
        animationType: BadgeAnimationType.slide,
        badgeContent: Text(snapshot.data.toString(),
          style: TextStyle(color: Colors.white),
        ),
        child: IconButton(icon: Icon(Icons.shopping_cart), color: Colors.white,
        onPressed: () => navigate(context, UserCart())
        )
      );
      else
        return IconButton(icon: Icon(Icons.shopping_cart), color: Colors.white,
        onPressed: () => navigate(context, UserCart())
        );
    }
  );
}