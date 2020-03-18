import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/blocs/product_description_bloc/product_description_bloc.dart';
import 'package:e_commerce_bloc/blocs/products_home_bloc/products_home_bloc.dart';
import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';
import 'package:e_commerce_bloc/repositories/cart_and_notification_count.dart';
import 'package:e_commerce_bloc/repositories/notifications_repo.dart';
import 'package:e_commerce_bloc/repositories/products_details.dart';
import 'package:e_commerce_bloc/screens/products_home/products_home_widgets/bottom_navigation.dart';
import 'package:e_commerce_bloc/screens/products_home/products_home_widgets/notification_badge.dart';
import 'package:e_commerce_bloc/screens/products_home/products_home_widgets/products_carousel.dart';
import 'package:e_commerce_bloc/screens/products_home/products_home_widgets/products_list.dart';
import 'package:e_commerce_bloc/screens/products_home/products_home_widgets/shopping_cart_badge.dart';
import 'package:e_commerce_bloc/widgets/app_bar.dart';
import 'package:e_commerce_bloc/widgets/circular_progress_indicator.dart';
import 'package:e_commerce_bloc/widgets/drawer.dart';
import 'package:e_commerce_bloc/widgets/show_dialog.dart';
import 'package:flutter/material.dart';

class ProductsHome extends StatefulWidget {
  @override
  _ProductsHomeState createState() => _ProductsHomeState();
}

class _ProductsHomeState extends State<ProductsHome> {
  
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  int rate1=0;
  int rate2=0;
  int rate3=0;
  int rate4=0;
  int rate5=0;
  int starRate=0;
  int totalVotes=0;
  int admin;
  double totalRate=0;
  List<Widget> actions = List<Widget>();
  dynamic leading;

  @override
  void initState() { 
    super.initState();
    notificationsRepo.listen();
    productDetails.getAllRatings();
    getCount();
    productsHomeBloc.getProductsCarousel();
    productsHomeBloc.getProductsList();
    admin = loginBloc.userMap['Admin'];
    leading = IconButton(
      icon: Icon(
        Icons.settings, 
        color: Colors.white),
        onPressed: () => scaffoldKey.currentState.openDrawer());
    actions = [
      IconButton(icon: Icon(Icons.refresh),
        onPressed: () => refresh()
      ),
      admin==1? Container() : notificationBadge(),
      admin==1? Container() : shoppingCartBadge()
    ]; 
  }

  refresh() async{
    getCount();
    bloc.containerHeightIn.add(60);
    bloc.loadingStatusIn.add(true);
    await productsHomeBloc.getProductsCarousel();
    await productsHomeBloc.getProductsList();
    bloc.loadingStatusIn.add(false);
    bloc.containerHeightIn.add(0);
    bottomNavigation.reset();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showDialogBox(context, 'Confirm exit', 'Do you wish to exit the app?', null),
        child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          appBar: appBar("Products", leading, actions),
          drawer: drawer(context, loginBloc.userMap['Admin']),
          body: Column(
            children: <Widget>[
              StreamBuilder(
                stream: bloc.containerHeightOut,
                builder: (context, height) => 
                AnimatedContainer(
                  height: height.data,
                  duration: Duration(milliseconds: 150),
                  child: Padding(
                    padding: const EdgeInsets.only(top:10, bottom:4),
                    child: Center(
                      child:circularProgressIndicator(context)
                    ),
                  ),
                )
              ),
              Expanded(
                child: Stack(
                          children: <Widget>[
                    Container(color: Colors.white),
                    Padding(
                      padding: const EdgeInsets.only(top:10),
                      child: Container( decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),)
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:51),
                      child: Container(
                        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('Fashion.jpg'), fit: BoxFit.cover), borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: productsCarousel()
                    ),
                    Positioned(
                      top: 17,
                      left: 15,
                      child: Text("Most Popular Items", style: TextStyle(color: Colors.white, fontSize:22, fontWeight: FontWeight.w400),)
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:280.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                        child: productsList(),
                      )
                    ),
                    Positioned(
                      left: 10, right: 10, bottom: 14,
                      child: bottomNavigation.bottomNavigationBar(context, scaffoldKey)
                    ),
                  ],
                ),
              ),
            ],
          )
        )
        
      ),
    );
  }
}