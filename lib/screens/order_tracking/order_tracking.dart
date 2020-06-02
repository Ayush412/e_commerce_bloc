import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/screens/order_tracking/order_tracking_widgets/item_row.dart';
import 'package:e_commerce_bloc/screens/order_tracking/order_tracking_widgets/status_row.dart';
import 'package:e_commerce_bloc/widgets/amount_row.dart';
import 'package:e_commerce_bloc/widgets/appBarBackArrow.dart';
import 'package:e_commerce_bloc/widgets/custom_drawer.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:steps_indicator/steps_indicator.dart';

import '../../analytics.dart';

class OrderTracking extends StatefulWidget {
  DocumentSnapshot order;
  OrderTracking({this.order});
  @override
  _OrderTrackingState createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking> {

  int step;
  List<String> items = List<String>();
  List<String> status = List<String>();
  List all = ['Order Confirmed', 'Packed', 'Shipped', 'Delivered'];
  @override
  void initState() {
    super.initState();
    items = widget.order.data['Items'].keys.toList();
    for(int i = 0; i<items.length; i++){
      if(i<=4){
        print(all[i]);
        print(widget.order.data['Status Dates'][all[i]]);
      }
    }
    step = widget.order.data['Status Dates'].keys.toList().length;
  }
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analyticsService.analytics)],
      home: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        drawer: customDrawer(context),
        appBar: appBarBackArrow(context, '', null, null),
        body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 430,
                    child: StepsIndicator(
                      lineLength: 100,
                      isHorizontal: false,
                      selectedStep: step,
                      nbSteps: 4,
                      unselectedStepSize: 15,
                      doneStepSize: 15,
                      selectedStepSize: 15,
                      selectedStepColorOut: Colors.grey,
                      doneLineColor: Colors.blue,
                      doneStepColor: Colors.blue,
                      undoneLineColor: Colors.grey,
                      unselectedStepColor: Colors.grey,
                      lineThickness: 1.5,
                    ),
                  ),
                  Container(
                    height: 430,
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        statusRow(all[0], 'Order has been placed and confirmed.' ,widget.order.data['Status Dates'][all[0]]),
                        statusRow(all[1], 'Items have been packed and are ready to ship.',widget.order.data['Status Dates'][all[1]]),
                        statusRow(all[2], 'Package has left the warehouse for delivery.',widget.order.data['Status Dates'][all[2]]),
                        statusRow(all[3], '',widget.order.data['Status Dates'][all[3]])
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1.5,
              indent: 10,
              endIndent: 10,
            ),
            Padding(
            padding: const EdgeInsets.all(20),
              child: Row(children: [
                Text('Order No :', style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),),
                Padding(padding: const EdgeInsets.only(left: 10),
                  child: Text(widget.order.documentID, style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),),
                )
              ])
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: itemRow(widget.order, items)
            ),
            Divider(
              thickness: 1.5,
              indent: 10,
              endIndent: 10,
            ),
            amountRow('Sub Total :', 'QR. ${widget.order.data['Sub Total'].toString()}', Colors.grey[600]),
            amountRow('Discount :', 'QR. ${widget.order.data['Discount'].toString()}', Colors.grey[600]),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: amountRow('Shipping : ', 'QR. ${widget.order.data['Shipping'].toString()}', Colors.grey[600])
            ),
            Divider(
              thickness: 1.5,
              indent: 10,
              endIndent: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child:amountRow('TOTAL :', 'QR. ${widget.order.data['Total'].toString()}', Colors.blue[400])
            )
          ],
        )
      ),
      ),
    );
  }
}