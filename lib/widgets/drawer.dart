import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';
import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/screens/add_product/add_product.dart';
import 'package:e_commerce_bloc/screens/analytics/analytics_screen.dart';
import 'package:e_commerce_bloc/screens/scan_to_search/scan_to_search.dart';
import 'package:e_commerce_bloc/screens/user_cart/user_cart.dart';
import 'package:e_commerce_bloc/screens/user_details_edit/user_details_edit.dart';
import 'package:e_commerce_bloc/screens/user_login/user_login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, dynamic> adminDrawerMap = Map<String, dynamic>();
Map<String, dynamic> userDrawerMap = Map<String, dynamic>();
BuildContext _context;

Widget drawer(BuildContext context, int admin){
  _context = context;

  return ClipRRect(
      borderRadius: BorderRadius.only(topRight: Radius.circular(80), bottomRight: Radius.circular(80)),
      child: Drawer(
        elevation: 4.5,
        child: Column(children: <Widget>[
          DrawerHeader(decoration: BoxDecoration(color: Colors.black),
            child: Center(
              child: Row(children: <Widget>[
                Padding(padding: EdgeInsets.all(8),
                child:Icon(Icons.account_circle, color: Colors.white),),
                Padding(padding: EdgeInsets.all(2),
                child: Text(loginBloc.userMap['Admin']==1? "${loginBloc.userMap['FName']} [ADMIN]" : "${loginBloc.userMap['FName']}", 
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)),
                )  
              ],),
            )
            ),
            admin == 1? drawerOptions("Add Products", AddProduct(), Icons.library_add ) 
            : drawerOptions("My Account",UserDetailsEdit(), Icons.person),
            admin == 1? drawerOptions("Analytics", AnalyticsScreen(), Icons.insert_chart) 
            : drawerOptions("Cart", UserCart(), Icons.shopping_cart),
            drawerOptions("Scan to Search", ScanToSearch(), Icons.camera_alt),
            Padding(
                padding:const EdgeInsets.only(top:180),
                child: Container(
                      alignment: Alignment.bottomCenter,
                      width:180,
                      height:50,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        splashColor: Colors.grey,
                        onTap: () => logOut(context),
                        child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      color: Colors.orange,
                      child: Center(child: Text('LOGOUT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),))
                      ),
                    ),
                 ),
               ) 
           ],
        )
      ) 
    );
}

drawerOptions(String text, dynamic className , IconData icon){
  return  Padding(
    padding: const EdgeInsets.only(top: 25.0),
    child: Container(
      width:250,
      height:60,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        splashColor: Colors.grey,
        onTap: () { navigate(_context, className);},
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              Center(child: Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),)),
              Positioned(
                left:17, top:14,
                child: Icon(icon, color: Colors.grey,),)
            ]
          )
        )
      )
    )
  );
}

logOut(BuildContext context) async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setString('email', null);
     navigate(context, login());
  }