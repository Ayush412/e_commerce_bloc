import 'package:e_commerce_bloc/blocs/products_home_bloc/products_home_bloc.dart';
import 'package:e_commerce_bloc/repositories/cart_and_notification_count.dart';
import 'package:e_commerce_bloc/repositories/notifications_repo.dart';
import 'package:e_commerce_bloc/screens/full_product_list/full_product_list.dart';
import 'package:e_commerce_bloc/screens/homescreen/homescreen_widgets/banners.dart';
import 'package:e_commerce_bloc/screens/homescreen/homescreen_widgets/category_grid.dart';
import 'package:e_commerce_bloc/screens/homescreen/homescreen_widgets/discounted.dart';
import 'package:e_commerce_bloc/screens/homescreen/homescreen_widgets/heading.dart';
import 'package:e_commerce_bloc/screens/homescreen/homescreen_widgets/top_rated.dart';
import 'package:e_commerce_bloc/widgets/appBar.dart';
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

  @override
  void initState() {
    super.initState();
    notificationsRepo.listen();
    productsHomeBloc.getTopRated(true);
    productsHomeBloc.getDiscounted(true);
    productsHomeBloc.getBanners();
    getCount();
  }

  onPop(){
    controller.text='';
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
          drawer:  customDrawer(context),
          appBar: appBar(context, scaffoldKey, true, controller, onPop, null, null),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                banners(),
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 30, bottom: 15, right: 20),
                  child: heading(context,'Featured Products', 'Featured Products')
                ),
                topRated(),
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 40, bottom: 15, right: 20),
                  child: heading(context,'On Sale', 'On Sale')
                ),
                discounted(),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text('Categories',
                      style: GoogleFonts.sourceSansPro( textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                showGrid(context, 'assets/mens.jpg', 'Mens Wear', FullProductList(category: 'Mens Wear'), 'assets/womens.jpg', 'Womens wear', FullProductList(category: 'Womens wear')),
                showGrid(context, 'assets/ps4.jpeg', 'Gaming', FullProductList(category: 'Gaming'), 'assets/dell.jpg', 'Laptops', FullProductList(category: 'Laptops')),
                showGrid(context, 'assets/phone.jpg', 'Smart Phones', FullProductList(category: 'Smart Phones'), 'assets/headphones.jpg', 'Audio', FullProductList(category: 'Audio'))
              ]
            ),
          )
        )
      )
    );
  }
}