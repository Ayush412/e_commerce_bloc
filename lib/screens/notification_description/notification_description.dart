import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/repositories/cart_and_notification_count.dart';
import 'package:e_commerce_bloc/repositories/notifications_repo.dart';
import 'package:e_commerce_bloc/screens/notifications_list/notifications_list.dart';
import 'package:e_commerce_bloc/widgets/appBarBackArrow.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

import '../../analytics.dart';

class NotificationDescription extends StatefulWidget {
  final DocumentSnapshot ds;
  NotificationDescription({this.ds});
  @override
  _NotificationDescriptionState createState() => _NotificationDescriptionState();
}

class _NotificationDescriptionState extends State<NotificationDescription> {

  dynamic leading;
  String text;
  String title;
  String imgurl;
  String date;

  @override
  void initState() {
    super.initState();
    leading = IconButton(icon: Icon(Icons.arrow_back), onPressed: () => navigate(context, NotificationList()));
    text = widget.ds.data['Text'];
    title = widget.ds.data['Title'];
    imgurl = widget.ds.data['imgurl'];
    date = formatDate(widget.ds.data['Date'].toDate(), [dd, '/', 'mm', '/', yy]);
    notificationsRepo.markAsRead(widget.ds.documentID);
    getCount();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => navigate(context, NotificationList()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: [FirebaseAnalyticsObserver(analytics: analyticsService.analytics)],
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: appBarBackArrow(context, '', NotificationList(), null),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                      child: Container(height: 250,
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), 
                        image: DecorationImage(image: NetworkImage(imgurl), fit: BoxFit.cover)
                        )
                      )
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top:30, left:10, bottom: 20),
                    child: Text(date, style: TextStyle(color: Colors.blue[400], fontSize: 16))
                ),
                Divider(
                  thickness: 1.5,
                  indent: 10,
                  endIndent: 10,
                ),
                Padding(
                    padding: const EdgeInsets.only(top:30, left:20, right:20),
                    child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
                ),
                Padding(
                    padding: const EdgeInsets.only(top:40, left:20, right:20, bottom: 30),
                    child: Text(text, style: TextStyle(fontWeight: FontWeight.w600,fontSize: 17, color: Colors.grey[600]))
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}