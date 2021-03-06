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
    title: Container(
      height: 40,
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child:Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 40,
                  child: Padding(
                    padding: EdgeInsets.only(top: 6, right: isHomeScreen? 20: titleText!=null? 35: onPop!=null? 10 : 0),
                    child: loginBloc.userMap['Admin']==1? 
                    InkWell(
                      onTap: () => scaffoldKey.currentState.openDrawer(),
                      child: Icon(Icons.dehaze, color: Colors.black)
                    )
                    : InkWell(
                      onTap: () => scaffoldKey.currentState.openDrawer(),
                      child: Container(
                        height: 40,
                        width: 30,
                        padding: const EdgeInsets.only(bottom: 15),
                        child: customBadge(Icons.dehaze, true, 2, 0, 13, 13)
                      ),
                    )
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/1.5,
                child: onPop!=null? searchBar(context, controller, onPop, searchAgain)
                :Container(
                  padding: const EdgeInsets.only(right: 75),
                  child: Center(
                    child: Text(titleText, style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.black),),
                  ),
                )),
                
              ]
            ),
            isHomeScreen ? Container() :
            Positioned(
              left: -18,
              top: controller==null? 0 : -5,
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
    ),
    actions: [
      titleText!=null ? Container()
      : Padding(
            padding: const EdgeInsets.only(right: 3),
            child: loginBloc.userMap['Admin']==1? 
              SizedBox(height: 20, width: 20)
              : Container(
                width: 33,
                height: 30,
                child: shoppingCart.cartBadge()
              )
        )
    ]
  );
}