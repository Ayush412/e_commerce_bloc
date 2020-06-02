import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/blocs/user_details_bloc/user_details_bloc.dart';
import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/screens/homescreen/homescreen.dart';
import 'package:e_commerce_bloc/screens/user_login/user_login.dart';
import 'package:e_commerce_bloc/widgets/circular_progress_indicator.dart';
import 'package:e_commerce_bloc/widgets/map_details.dart';
import 'package:e_commerce_bloc/widgets/show_snack.dart';
import 'package:e_commerce_bloc/widgets/textfield.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../analytics.dart';

class getUserDetails extends StatefulWidget {
  final String email;
  getUserDetails({this.email});
  @override
  _getUserDetailsState createState() => _getUserDetailsState();
}

class _getUserDetailsState extends State<getUserDetails> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>(); 
  dynamic leading;
  List<Widget> actions = List<Widget>();
  double lat=0;
  double lng=0;
  GoogleMap map;

  saveDetails() async{
    bloc.loadingStatusIn.add(true);
    await userDetailsBloc.saveUserData();
    bloc.loadingStatusIn.add(false);
    navigate(context, HomeScreen());
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(   
      onWillPop: () => navigate(context, login()),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analyticsService.analytics)],
      home: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 1.5,
          backgroundColor: Colors.white,
          leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.close,), 
            onPressed: ()=> navigate(context, login())
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
                  child: Center(
            child: Column(children: <Widget>[
              Padding(
                    padding: const EdgeInsets.only(top:20),
                    child: Container(
                                width: 300,
                                padding: EdgeInsets.all(10.0),
                    child: textField(
                      userDetailsBloc.fnameCheck, 
                      userDetailsBloc.fnameChanged, 
                      '', 
                      'First Name', 
                      Icon(Icons.person), 
                      TextInputType.text, 
                      false
                    )
                    ),
                  ),
              Padding(
                    padding: const EdgeInsets.only(top:30),
                    child: Container(
                                width: 300,
                                padding: EdgeInsets.all(10.0),
                    child: textField(
                      userDetailsBloc.lnameCheck, 
                      userDetailsBloc.lnameChanged, 
                      '', 
                      'Surname', 
                      Icon(Icons.supervisor_account), 
                      TextInputType.text, 
                      false
                    )
                    ),
                  ),
              Padding(
                    padding: const EdgeInsets.only(top:30),
                    child: Container(
                                width: 300,
                                padding: EdgeInsets.all(10.0),
                    child: textField(
                      userDetailsBloc.mobCheck, 
                      userDetailsBloc.mobChanged, 
                      '(+974)', 
                      'Mobile', 
                      Icon(Icons.call), 
                      TextInputType.number, 
                      false
                    )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:30),
                    child: Container(
                                width: 300,
                                padding: EdgeInsets.all(10.0),
                    child: textField(
                      userDetailsBloc.addressCheck, 
                      userDetailsBloc.addressChanged, 
                      'Address line', 
                      'Building and Flat no.', 
                      Icon(Icons.location_city), 
                      TextInputType.text, false
                    )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:30),
                    child: mapDetails.mapDetails(context, lat, lng),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom:30),
                    child: StreamBuilder(
                      stream: userDetailsBloc.credentialsCheck,
                      builder:(context, snap) => RaisedButton(
                      onPressed: () =>  snap.hasData? saveDetails() :  _scaffoldKey.currentState.showSnackBar(ShowSnack('Check again for incomplete fields', Colors.black, Colors.orange)),
                      textColor: Colors.white,
                      color: Colors.orange,
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: Container(
                        width: 250,
                        height: 55,
                        decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(80.0))
                        ),
                        child: Center(
                          child: const Text('Save details', style: TextStyle(fontSize: 20)
                          ),
                        ),
                      ),
                  ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 30),
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