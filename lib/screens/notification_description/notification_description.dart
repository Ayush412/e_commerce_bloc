import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/repositories/notifications_repo.dart';
import 'package:e_commerce_bloc/screens/notifications_list/notifications_list.dart';
import 'package:e_commerce_bloc/widgets/app_bar.dart';
import 'package:flutter/material.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    Container(
                    height:MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xffffd89b), Color(0xffc4e0e5)]))),
                    appBar('', leading, null),
                  Padding(
                    padding: const EdgeInsets.only(top:80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                       Center(
                         child: Padding(
                              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                              child: Container(height: 250, width:350,
                                decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10), 
                                image: DecorationImage(image: NetworkImage(imgurl), fit: BoxFit.cover)
                                )
                              )
                          ),
                       ),
                        Padding(
                            padding: const EdgeInsets.only(top:20, left:10),
                            child: Text(date, style: TextStyle(color: Color(0xff19547b), fontSize: 16))
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top:30, left:20, right:20),
                            child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top:40, left:20, right:20),
                            child: Text(text, style: TextStyle(fontSize: 18, color: Colors.black54))
                        ),
                      ],
              ),
                  ),
            ],
                      ),
          )
      ),
    );
  }
}