//import 'package:badges/badges.dart';
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
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GestureDetector(
                  child: Image.asset('assets/icons/cart.png', height: 20, width: 20,),
                  onTap: () => navigate(context, CartScreen())
                ),
              ),
              Positioned(
                top: 10,
                right: 5,
                child: Container(
                  height: 13, width: 13,
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
        else
          return Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12, right: 12),
            child: GestureDetector(
              child: Image.asset('assets/icons/cart.png', height: 10, width: 10,),
              onTap: () => navigate(context, CartScreen())
            ),
          );
      }
    );
  }
}
final ShoppingCart shoppingCart = ShoppingCart();