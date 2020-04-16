import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/widgets/appBar.dart';
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
  int current_step = 0;
  List<Step> steps = [
    Step(
      title: Text('Order Confirmed'),
      content: Text('Hello!'),
      isActive: true,
    ),
    Step(
      title: Text('Packed'),
      content: Text('World!'),
      isActive: true,
    ),
    Step(
      title: Text('Shipped'),
      content: Text('Hello World!'),
      isActive: true,
    ),
    Step(
      title: Text('Delivered'),
      content: Text('Hello World!'),
      state: StepState.indexed,
      isActive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        drawer: customDrawer(context),
        appBar: appBar(context, scaffoldKey, false, null, null, null, ''),
        body: Container(
        child: Stepper(
          currentStep: this.current_step,
          steps: steps,
          type: StepperType.vertical,
          onStepTapped: (step) {
            setState(() {
              current_step = step;
            });
          },
          onStepContinue: () {
            setState(() {
              if (current_step < steps.length - 1) {
                current_step = current_step + 1;
              } else {
                current_step = 0;
              }
            });
          },
          onStepCancel: () {
            setState(() {
              if (current_step > 0) {
                current_step = current_step - 1;
              } else {
                current_step = 0;
              }
            });
          },
        ),
      ),
      ),
    );
  }
}