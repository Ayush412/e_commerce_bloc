import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
        ),
      ),
    );
  }
}