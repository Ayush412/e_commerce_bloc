import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/blocs/user_register_bloc/user_register_bloc.dart';
import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/screens/user_details/user_details.dart';
import 'package:e_commerce_bloc/widgets/appBarBackArrow.dart';
import 'package:e_commerce_bloc/widgets/circular_progress_indicator.dart';
import 'package:e_commerce_bloc/widgets/show_snack.dart';
import 'package:e_commerce_bloc/widgets/textfield.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

import '../../analytics.dart';

class register extends StatefulWidget {
  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {
  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>(); 
  List<Widget> actions = List<Widget>();
  dynamic leading;

  @override
  void initState() { 
    super.initState();
    leading = IconButton(icon: Icon(Icons.arrow_back),onPressed: () => Navigator.of(context).pop());
    actions = [
      IconButton(icon: Icon(Icons.info), color: Colors.white,
      onPressed: () => _scaffoldKey.currentState.showSnackBar(ShowSnack('Enter login credentials', Colors.black, Colors.orange)))
    ];
  }

  checkogin() async{
    bool user;
    bloc.loadingStatusIn.add(true);
    user = await registerBloc.createLogin();
    if(user){
      analyticsService.analytics.logSignUp(signUpMethod: 'email');
      navigate(context, getUserDetails());
    }
    else
      _scaffoldKey.currentState.showSnackBar(ShowSnack('User already exists', Colors.black, Colors.orange));
    bloc.loadingStatusIn.add(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(   
      onWillPop: (){Navigator.of(context).pop();},
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analyticsService.analytics)],
      home: Scaffold(
        key: _scaffoldKey,
        appBar: appBarBackArrow(context, 'Sign up', null, null),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
                  child: Center(
            child: Column(children: <Widget>[
              Padding(
                    padding: const EdgeInsets.only(top:80),
                    child: Container(
                                width: 300,
                                padding: EdgeInsets.all(10.0),
                    child: textField(registerBloc.emailCheck, registerBloc.emailChanged, 'Email', 'Email (Username)', Icon(Icons.person), TextInputType.emailAddress ,false)
                    ),
                  ),
              Padding(
                    padding: const EdgeInsets.only(top:30),
                    child: Container(
                                width: 300,
                                padding: EdgeInsets.all(10.0),
                    child: textField(registerBloc.pass1Check, registerBloc.pass1Changed, 'Password', 'Password', Icon(Icons.lock_outline), TextInputType.text, true)
                    ),
                  ),
              Padding(
                    padding: const EdgeInsets.only(top:30),
                    child: Container(
                                width: 300,
                                padding: EdgeInsets.all(10.0),
                    child: textField(registerBloc.pass2Check, registerBloc.pass2Changed, 'Re-type password', 'Re-type Password', Icon(Icons.lock), TextInputType.text, true)
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: StreamBuilder(
                      stream: registerBloc.credentialsCheck,
                      builder: (context, snapshot) => RaisedButton(
                      onPressed: () => snapshot.hasData? checkogin() : ShowSnack("Check all fields", Colors.black, Colors.orange),
                      textColor: Colors.white,
                      color: Colors.black,
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: Container(
                        width: 250,
                        height: 55,
                        decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(80.0))
                        ),
                        child: Center(
                          child: const Text('Register', style: TextStyle(fontSize: 20)
                          ),
                        ),
                      ),
                  ),
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 20),
                  child: circularProgressIndicator(context)
                )
            ],
            )
          ),
        )
      )  
    )   
    );
  }
}