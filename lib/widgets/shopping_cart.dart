import 'package:badges/badges.dart';
import 'package:e_commerce_bloc/blocs/products_home_bloc/products_home_bloc.dart';
import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/screens/cart_screen/cart_screen.dart';
import 'package:flutter/material.dart';

class ShoppingCart{
  cartBadge(){
    return StreamBuilder(
      stream: productsHomeBloc.cartOut,
      builder: (context, snapshot) {
        if(snapshot.data>0)
          return Badge(
            position: BadgePosition.topRight(top: -13, right: -10),
            animationDuration: Duration(milliseconds: 300),
            animationType: BadgeAnimationType.slide,
            badgeContent: Text(snapshot.data.toString(),
              style: TextStyle(color: Colors.white, fontSize: 9.5),
            ),
            child: GestureDetector(
              child: Image.asset('assets/icons/cart.png', height: 20, width: 20,),
              onTap: () => navigate(context, CartScreen())
            )
          );
        else
          return GestureDetector(
            child: Image.asset('assets/icons/cart.png', height: 20, width: 20,),
            onTap: () => navigate(context, CartScreen())
          );
      }
    );
  }
}
final ShoppingCart shoppingCart = ShoppingCart();