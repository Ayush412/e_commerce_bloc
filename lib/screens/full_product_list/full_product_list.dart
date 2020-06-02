import 'package:e_commerce_bloc/blocs/products_home_bloc/products_home_bloc.dart';
import 'package:e_commerce_bloc/widgets/appBar.dart';
import 'package:e_commerce_bloc/widgets/custom_drawer.dart';
import 'package:e_commerce_bloc/widgets/products_list.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../analytics.dart';

class FullProductList extends StatefulWidget {
  String category;
  FullProductList({@required this.category});
  @override
  _FullProductListState createState() => _FullProductListState();
}

class _FullProductListState extends State<FullProductList> {

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    productsHomeBloc.productsListIn.add(null);
    productsHomeBloc.getFullList(widget.category);
  }

  onPop(){
    controller.text='';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analyticsService.analytics)],
      home: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        drawer:  customDrawer(context),
        appBar: appBar(context, scaffoldKey, false, controller, onPop, null, null),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 60),
              child: productsList(),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(widget.category, style: GoogleFonts.sourceSansPro(fontSize: 20, fontWeight: FontWeight.w600),)
                )
              )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}