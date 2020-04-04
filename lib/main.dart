import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';
import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/repositories/user_details_repo.dart';
import 'package:e_commerce_bloc/screens/user_login/user_login.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'screens/homescreen/homescreen.dart';

void main() {
  runApp(Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp()      
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String email;
  DocumentSnapshot ds;
  Timer _timer;

  Future afterSplash () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
    if(email==null)
      navigate(context, login());
    else{
      await userDetails.getUserData(email);
      print(loginBloc.userMap['emailID']);
      navigate(context, HomeScreen());
    }
  }

  @override
  void initState() {
    super.initState();
    _timer = new Timer(const Duration(seconds: 1), () {
      afterSplash();
    });
  }

  @override
   void dispose(){
     super.dispose();
     _timer.cancel();
   }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        color: Colors.white,
        child: Image.asset('assets/logo2(noName).png', height: 100,)
      ),
    );
  }
}
