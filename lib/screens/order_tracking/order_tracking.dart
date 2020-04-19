import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/widgets/appBarBackArrow.dart';
import 'package:e_commerce_bloc/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class OrderTracking extends StatefulWidget {
  DocumentSnapshot order;
  OrderTracking({this.order});
  @override
  _OrderTrackingState createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking> {

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
 

  @override
  Widget build(BuildContext context) {

    int selectedStep = 0;
    int nbSteps = 5;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        drawer: customDrawer(context),
        appBar: appBarBackArrow(context, '', false),
        body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StepsIndicator(
              selectedStep: selectedStep,
              nbSteps: nbSteps,
              doneLineColor: Colors.green,
              doneStepColor: Colors.green,
              undoneLineColor: Colors.red,
              unselectedStepColor: Colors.red,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  color: Colors.red,
                  onPressed: () {
                    if(selectedStep > 0) {
                      setState(() {
                        selectedStep--;
                      });
                    }
                  },
                  child: Text('Prev'),
                ),
                MaterialButton(
                  color: Colors.green,
                  onPressed: () {
                    if(selectedStep < nbSteps) {
                      setState(() {
                        selectedStep++;
                      });
                    }
                  },
                  child: Text('Next'),
                )
              ],
            )
          ],
        )
      ),
      ),
    );
  }
}