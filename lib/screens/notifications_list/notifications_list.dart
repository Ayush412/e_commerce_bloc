import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/blocs/notifications_bloc/notifications_bloc.dart';
import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/screens/notification_description/notification_description.dart';
import 'package:e_commerce_bloc/widgets/circular_progress_indicator.dart';
import 'package:e_commerce_bloc/widgets/custom_drawer.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../analytics.dart';

class NotificationList extends StatefulWidget {
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  dynamic leading;
  List<Widget> actions = List<Widget>();

  @override
  void initState() {
    super.initState();
    notificationsBloc.getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analyticsService.analytics)],
      home: Scaffold(
        key: scaffoldKey,
        drawer: customDrawer(context),
        appBar: AppBar(
          elevation: 1.5,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text('Notifications', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.black),),
          leading: IconButton(
            onPressed: ()=> scaffoldKey.currentState.openDrawer(),
            icon: Icon(Icons.dehaze),color: Colors.black,),
        ),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:10),
              child: StreamBuilder(
                stream: notificationsBloc.notificationListOut,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                  bloc.loadingStatusIn.add(true);
                  if(snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: circularProgressIndicator(context));
                  else{
                    bloc.loadingStatusIn.add(false);
                    if(snapshot.data.documents.length>0){
                      return ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (_, index){
                          DocumentSnapshot product = snapshot.data.documents[index];
                          return Padding(
                            padding: const EdgeInsets.only(top:6.0),
                            child: Container(height: 250,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
                              child: GestureDetector(
                                onTap: () => navigate(context, NotificationDescription(ds: product)), 
                                  child: Card(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  child: Stack(
                                    children: <Widget>[
                                      Padding(
                                      padding: const EdgeInsets.only(top:70),
                                      child: Container(height: 200, decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)), 
                                      image: DecorationImage(image: NetworkImage(product.data['imgurl']), fit: BoxFit.cover)))
                                      ),
                                      ListTile(
                                        contentPadding: EdgeInsets.only(left:20, right:30),
                                      subtitle: Text('Read More', style: GoogleFonts.sourceSansPro(color: Colors.grey)),
                                      title: Text(product.data['Title'], style: GoogleFonts.sourceSansPro(fontSize: 20,
                                      fontWeight: product.data['Read']==0 ? FontWeight.bold : FontWeight.w300,
                                      color: product.data['Read']==0 ? Colors.black : Colors.grey)),
                                      ),
                                      Positioned(
                                        right:10, top: 50,
                                        child: Text(formatDate(product.data['Date'].toDate(), [dd, '/', 'mm', '/', yy]), style:GoogleFonts.sourceSansPro(color: Colors.grey),),
                                        ),
                                      Positioned(
                                        right:0, top:-2,
                                        child: IconButton(
                                          onPressed: () => notificationsBloc.deleteData(product),
                                          icon: Icon(Icons.clear, color: Colors.grey, size: 23,),
                                        ),
                                      )
                                    ]
                                  )
                                ),
                              )
                            )
                          );
                        }
                      );
                    }
                    else{
                      return Center(child: Text('No new notifications!', style: GoogleFonts.sourceSansPro(color: Colors.grey[600], fontSize: 21),),);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}