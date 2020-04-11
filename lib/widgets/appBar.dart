import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';
import 'package:flutter/material.dart';
import 'custom_badge.dart';
import 'search_bar.dart';
import 'shopping_cart.dart';

appBar(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey, bool isHomeScreen, TextEditingController controller, dynamic onPop, dynamic searchAgain){
  return AppBar(
    elevation: 0,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
    title: Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(right: isHomeScreen? 15: 0),
              child: loginBloc.userMap['Admin']==1? 
              IconButton(
                icon: Icon(Icons.dehaze), 
                color: Colors.black,
                onPressed: () => scaffoldKey.currentState.openDrawer(),
              )
              : InkWell(
                onTap: () => scaffoldKey.currentState.openDrawer(),
                child: customBadge(Icons.dehaze),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width/1.5,
            child: onPop!=null? searchBar(context, controller, onPop, searchAgain) : SizedBox()
            )
          ]
        ),
        isHomeScreen ? Container() :
        Positioned(
          left: -15,
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
            onPressed: (){
              if (onPop!=null)
                onPop();
              Navigator.of(context).pop();
            },
          )
        )
      ],
    ),
    actions: [
      Padding(
          padding: const EdgeInsets.only(top: 15, right: 15, bottom: 15),
          child: /*loginBloc.userMap['Admin']==1? 
            SizedBox(height: 20, width: 20,)
            :*/ shoppingCart.cartBadge()
        ) 
    ]
  );
}