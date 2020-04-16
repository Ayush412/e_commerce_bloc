import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';
import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/screens/cart_screen/cart_screen.dart';
import 'package:e_commerce_bloc/screens/homescreen/homescreen.dart';
import 'package:e_commerce_bloc/screens/orders_screen/orders_screen.dart';
import 'package:e_commerce_bloc/screens/user_login/user_login.dart';
import 'package:e_commerce_bloc/widgets/custom_badge.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

customDrawer(BuildContext context){
  int admin = loginBloc.userMap['Admin'];
  return Drawer(
    elevation: 4,
    child: Column(
      children: <Widget>[
        Container(
          height: 90,
          width: MediaQuery.of(context).size.width,
          child: DrawerHeader(
            decoration: BoxDecoration(color: Colors.grey[300]),
            child: InkWell(
              onTap: () => null,//TODO myaccount
              child: 
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text('Hello, ${loginBloc.userMap['FName']}', style: GoogleFonts.sourceSansPro(fontSize: 20, fontWeight: FontWeight.bold),)
                )
            ),
          ),
        ),
        admin==1? Container()
        : drawerOptions(context, 'assets/icons/view.png', 'My Account', null, 10),
        admin==1 ? Container()
        : Padding(padding: const EdgeInsets.only(left: 13, top: 20, bottom: 10),
        child: Row(children: <Widget>[
          Container(
            height: 55, width: 40,
            child: customBadge(Icons.notifications),
          ),
          SizedBox(width: 29),
          Text('Notifications', style: GoogleFonts.sourceSansPro(fontSize: 20, fontWeight: FontWeight.w600),)
        ],),
        ),
        admin==1? Container() : Divider(),
        drawerOptions(context, 'assets/icons/home.png', 'Home', HomeScreen(), 30),
        drawerOptions(context, 'assets/icons/sale.png', 'Deals and Promotions', null, 30),
        admin==1? drawerOptions(context, 'assets/icons/package.png', 'Add Products', null, 30)
        : drawerOptions(context, 'assets/icons/cart.png', 'My Cart', CartScreen(), 30),
        admin==1? Container()
        : drawerOptions(context, 'assets/icons/delivery.png', 'Track Orders', OrdersScreen(), 30),
        admin==1? drawerOptions(context, 'assets/icons/analytics.jpg', 'Analytics', null, 30) : Container(),
        drawerOptions(context, 'assets/icons/barcode.png','Scan To Search', null, 30),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => logOut(context),
                child: Container(
                  height: 40,
                  child: Center(
                    child: Text('LOGOUT', style: GoogleFonts.sourceSansPro(fontSize: 20, fontWeight: FontWeight.bold),)
                  ),
                ),
              ),
            )
          ),
        )
      ]
    )
  );
}

drawerOptions(BuildContext context, String img, String text, dynamic className, double pad){
  return Padding(
    padding: EdgeInsets.only(left: 20, top: pad),
    child: InkWell(
      onTap: () => navigate(context, className),//TODO navigate
      child: Row(
        children: <Widget>[
          Image.asset(img, height:30, width:30),
          SizedBox(width: 30),
          Text(text, style: GoogleFonts.sourceSansPro(fontSize: 20, fontWeight: FontWeight.w600),)
        ],
      ),
    ),
  );
}

logOut(BuildContext context) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('email', null);
  navigate(context, login());
}