import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/orders_bloc/orders_bloc.dart';
import 'package:e_commerce_bloc/screens/homescreen/homescreen.dart';
import 'package:e_commerce_bloc/screens/orders_screen/order_screen_widgets/orders_card.dart';
import 'package:e_commerce_bloc/widgets/appBar.dart';
import 'package:e_commerce_bloc/widgets/appBarBackArrow.dart';
import 'package:e_commerce_bloc/widgets/center_image.dart';
import 'package:e_commerce_bloc/widgets/custom_drawer.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

import '../../analytics.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    ordersBloc.getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: [FirebaseAnalyticsObserver(analytics: analyticsService.analytics)],
        home: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          drawer: customDrawer(context),
          appBar: appBarBackArrow(context, 'Orders', HomeScreen(), null),
          body: StreamBuilder(
            stream: ordersBloc.ordersOut,
            builder: (context, AsyncSnapshot<QuerySnapshot> orders){
              if(!orders.hasData)
                return Center(child: CircularProgressIndicator());
              else{
                if(orders.data.documents.length==0)
                  return centerImage('No orders found.', 'assets/icons/delivery.png');
                else{
                  return ListView.builder(
                    itemCount: orders.data.documents.length,
                    itemBuilder: (_, index){
                      return ordersCard(context, orders.data.documents[index]);
                    }
                  );
                }
              }
            }
          ),
        ),
      ),
    );
  }
}