import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';
import 'package:e_commerce_bloc/repositories/cart_and_notification_count.dart';
import 'package:e_commerce_bloc/repositories/notifications_repo.dart';
import 'package:e_commerce_bloc/screens/homescreen/homescreen_widgets/category_grid.dart';
import 'package:e_commerce_bloc/screens/homescreen/homescreen_widgets/search_bar.dart';
import 'package:e_commerce_bloc/screens/homescreen/homescreen_widgets/shopping_cart.dart';
import 'package:e_commerce_bloc/widgets/custom_badge..dart';
import 'package:e_commerce_bloc/widgets/custom_drawer.dart';
import 'package:e_commerce_bloc/widgets/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController controller = TextEditingController();
  FocusNode node = FocusNode();
  int admin; 
  dynamic leading;
  List<Widget> actions = List<Widget>();

  @override
  void initState() { 
    super.initState();
    admin = loginBloc.userMap['Admin'];
    notificationsRepo.listen();
    getCount();
    leading = Padding(
      padding: const EdgeInsets.only(left:10),
      child: /*admin==1? 
      IconButton(
        icon: Icon(Icons.dehaze), 
        color: Colors.black,
        onPressed: () => scaffoldKey.currentState.openDrawer(),
      )
      :*/ InkWell(
        onTap: () => scaffoldKey.currentState.openDrawer(),
        child: customBadge(Icons.dehaze),
      )
    );
    actions = [
      admin==1? 
        Container()
      :  Padding(
          padding: const EdgeInsets.only(top: 20, right:20),
          child: admin==1? 
            Image.asset('assets/icons/cart.png', height:20, width: 20) 
            : shoppingCartBadge(),
        ) 
    ]; 
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showDialogBox(context, 'Confirm exit', 'Do you wish to exit the app?', null),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey,
          drawer:  customDrawer(context, admin),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: leading,
            actions: actions,
            title: searchBar(context, controller, node)
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Center(
                    child: Text('Browse Categories',
                      style: GoogleFonts.sourceSansPro( textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                showGrid('assets/mens.jpg', 'Mens Wear', null, 'assets/womens.jpg', 'Womens wear', null),
                showGrid('assets/ps4.jpeg', 'Gaming', null, 'assets/dell.jpg', 'Laptops', null),
                showGrid('assets/phone.jpg', 'Smart Phones', null, 'assets/headphones.jpg', 'Audio', null)
              ]
            ),
          )
        )
      )
    );
  }
}