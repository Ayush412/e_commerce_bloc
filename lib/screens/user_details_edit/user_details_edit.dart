import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/blocs/user_details_bloc/user_details_bloc.dart';
import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';
import 'package:e_commerce_bloc/widgets/appBar.dart';
import 'package:e_commerce_bloc/widgets/circular_progress_indicator.dart';
import 'package:e_commerce_bloc/widgets/custom_drawer.dart';
import 'package:e_commerce_bloc/widgets/map_details.dart';
import 'package:e_commerce_bloc/widgets/show_snack.dart';
import 'package:e_commerce_bloc/widgets/textfield_with_controller.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

import '../../analytics.dart';

class UserDetailsEdit extends StatefulWidget {
  @override
  _UserDetailsEditState createState() => _UserDetailsEditState();
}

class _UserDetailsEditState extends State<UserDetailsEdit> {

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>(); 
  dynamic leading;
  TextEditingController fnameController;
  TextEditingController lnameController;
  TextEditingController mobcontroller;
  TextEditingController addresscontroller;

  @override
  void initState() {
    super.initState();
    fnameController = TextEditingController(text: loginBloc.userMap['FName']);
    lnameController = TextEditingController(text: loginBloc.userMap['LName']);
    mobcontroller = TextEditingController(text: loginBloc.userMap['Mob'].toString());
    addresscontroller = TextEditingController(text: loginBloc.userMap['Address']);
    userDetailsBloc.getPlace(loginBloc.userMap['Latitude'], loginBloc.userMap['Longitude']);
  }

  saveDetails() async{
    if(fnameController.text!='' && lnameController.text!='' && mobcontroller.text!='' && addresscontroller.text!=''){
      bloc.loadingStatusIn.add(true);
      await userDetailsBloc.updateUserData();
      bloc.loadingStatusIn.add(false);
      scaffoldKey.currentState.showSnackBar(ShowSnack('Details saved.', Colors.white, Colors.green));
    }
    else
     scaffoldKey.currentState.showSnackBar(ShowSnack('Check again for incomplete fields', Colors.black, Colors.orange));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analyticsService.analytics)],
      home: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        drawer: customDrawer(context),
        appBar: appBar(context, scaffoldKey, false, null, null, false, 'My Account'),
        body: SingleChildScrollView(
          child: Center(
            child: Column(children: <Widget>[
              Padding(
                    padding: const EdgeInsets.only(top:20),
                    child: Container(
                                width: 300,
                                padding: EdgeInsets.all(10.0),
                    child: textFieldWithController(
                      fnameController,
                      userDetailsBloc.fnameCheck, 
                      userDetailsBloc.fnameChanged, 
                      'First Name', 
                      Icon(Icons.person), 
                      TextInputType.text
                    )
                    ),
                  ),
              Padding(
                    padding: const EdgeInsets.only(top:30),
                    child: Container(
                                width: 300,
                                padding: EdgeInsets.all(10.0),
                    child: textFieldWithController(
                      lnameController,
                      userDetailsBloc.lnameCheck, 
                      userDetailsBloc.lnameChanged, 
                      'Surname', 
                      Icon(Icons.supervisor_account), 
                      TextInputType.text
                    )
                    ),
                  ),
              Padding(
                    padding: const EdgeInsets.only(top:30),
                    child: Container(
                                width: 300,
                                padding: EdgeInsets.all(10.0),
                    child: textFieldWithController(
                      mobcontroller,
                      userDetailsBloc.mobCheck, 
                      userDetailsBloc.mobChanged, 
                      'Mobile', 
                      Icon(Icons.call), 
                      TextInputType.number
                    )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:30),
                    child: Container(
                                width: 300,
                                padding: EdgeInsets.all(10.0),
                    child: textFieldWithController(
                      addresscontroller,
                      userDetailsBloc.addressCheck, 
                      userDetailsBloc.addressChanged, 
                      'Building and Flat no.', 
                      Icon(Icons.location_city), 
                      TextInputType.text
                    )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:30),
                    child: mapDetails.mapDetails(context, loginBloc.userMap['Latitude'], loginBloc.userMap['Longitude']),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: RaisedButton(
                      onPressed: () =>  saveDetails(),
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
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 60),
                  child: circularProgressIndicator(context)
                )
            ],
            )
          ),
        )
      ),
    );
  }
}