import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'custom_badge.dart';
import 'search_bar.dart';
import 'shopping_cart.dart';

appBar(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey, bool isHomeScreen, TextEditingController controller, dynamic onPop, dynamic searchAgain, dynamic titleText){
  return AppBar(
    elevation: 1.5,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
    title: Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: titleText=='Orders'? 60: isHomeScreen? 30: titleText!=null? 35: onPop!=null? 10 : 0),
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
              child: onPop!=null? searchBar(context, controller, onPop, searchAgain)
              : Padding(
                padding: const EdgeInsets.only(left: 65),
                child: Text(titleText, style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.black),),
              )
              )
            ]
          ),
          isHomeScreen ? Container() :
          Positioned(
            left: -18,
            top: controller==null? -12 : -5,
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
    ),
    actions: [
      titleText!=null ? Container()
      : Padding(
          padding: const EdgeInsets.only(top: 15, right: 15, bottom: 15),
          child: loginBloc.userMap['Admin']==1? 
            SizedBox(height: 20, width: 20,)
            : shoppingCart.cartBadge()
        )
    ]
  );
}