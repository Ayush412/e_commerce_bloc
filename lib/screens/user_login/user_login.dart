import 'dart:async';
import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';
import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/repositories/shared_preferences_email.dart';
import 'package:e_commerce_bloc/screens/products_home/products_home.dart';
import 'package:e_commerce_bloc/screens/user_details/user_details.dart';
import 'package:e_commerce_bloc/screens/user_register/register.dart';
import 'package:e_commerce_bloc/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_bloc/widgets/show_snack.dart';
import 'package:e_commerce_bloc/widgets/textfield.dart';
import 'package:e_commerce_bloc/widgets/circular_progress_indicator.dart';
import 'package:e_commerce_bloc/widgets/show_dialog.dart';
import 'package:e_commerce_bloc/blocs/bloc.dart';

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>(); 
  Map<dynamic, dynamic> myMap = Map<dynamic, dynamic>();
  List<Widget> actions = List<Widget>();
  dynamic leading;

  @override
  void initState() { 
    super.initState();
    sharedPreference.removeData();
    leading = IconButton(
      icon: Icon(Icons.close),
      onPressed: () => showDialogBox(context, 'Warning', 'Exit app?', null)
    );

    actions = [
      IconButton(icon: Icon(Icons.info), color: Colors.white,
      onPressed: () => scaffoldKey.currentState.showSnackBar(ShowSnack('Enter user credentials', Colors.black, Colors.orange)))
    ];
  }

  Future checklogin() async{
    
    bool hasUser = true;
    bloc.loadingStatusIn.add(true);
    hasUser = await loginBloc.checkLogin();
    if(!hasUser)
      scaffoldKey.currentState.showSnackBar(ShowSnack('User not found', Colors.black, Colors.orange));
    else{
      if(loginBloc.userMap!=null){
        sharedPreference.saveData(loginBloc.emailID);
        navigate(context, ProductsHome());
      }
      else
        navigate(context, getUserDetails());
    }
    bloc.loadingStatusIn.add(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(   
      onWillPop: () => showDialogBox(context, 'Confirm exit', 'Do you wish tio exit the app?', null),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: appBar('Login', leading, actions),
        body: SingleChildScrollView(
            child: Center(
              child: Column(children: <Widget>[
                Padding(padding: const EdgeInsets.only(top:120.0),
                ),
                Container(
                            width: 300,
                            padding: EdgeInsets.all(10.0),
                child: textField(loginBloc.emailCheck, loginBloc.emailChanged, 'Email', 'Email', Icon(Icons.person), TextInputType.emailAddress, false)
                ),
                Padding(
                  padding: const EdgeInsets.only(top:30),
                  child: Container(
                              width: 300,
                              padding: EdgeInsets.all(10.0),
                  child: textField(loginBloc.passCheck, loginBloc.passChanged, 'Password', 'Password', Icon(Icons.lock), TextInputType.text, true)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50, bottom:20),
                  child: StreamBuilder(
                    stream: loginBloc.credentialsCheck,
                    builder: (context, snap) => RaisedButton(
                    onPressed: snap.hasData? (){checklogin();} : () => scaffoldKey.currentState.showSnackBar(ShowSnack('Check all fields', Colors.black, Colors.orange)),
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
                        child: const Text('LOGIN', style: TextStyle(fontSize: 20)
                        ),
                      ),
                    ),
                ),
                  ),
              ),
              circularProgressIndicator(context),
                Padding(
                  padding: const EdgeInsets.only(top:60),
                  child: GestureDetector(
                            onTap: (){
                              navigate(context, register());
                            },
                            child: Container(height:50,
                              child: Center(
                                child: Text('New user? Click here to register', 
                                  style: TextStyle(
                                    fontSize: 18.0, 
                                    color: Colors.black, 
                                    fontWeight: FontWeight.w400, 
                                    decoration: TextDecoration.underline
                                  )
                                )
                              )
                            )
                          ),
                ),
              ],
              ),
            )
          ),
        )
      )    
    );
  }
}

