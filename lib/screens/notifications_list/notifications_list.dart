import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/blocs/notifications_bloc/notifications_bloc.dart';
import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/screens/notification_description/notification_description.dart';
import 'package:e_commerce_bloc/screens/products_home/products_home.dart';
import 'package:e_commerce_bloc/widgets/app_bar.dart';
import 'package:e_commerce_bloc/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';

class NotificationList extends StatefulWidget {
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {

  dynamic leading;
  List<Widget> actions = List<Widget>();

  @override
  void initState() {
    super.initState();
    notificationsBloc.getData();
    actions = [
      FlatButton(
        onPressed: () => notificationsBloc.clearAll(),
      child: Text('Clear All', style: TextStyle(color: Colors.grey, fontSize: 16.4))
      )
    ];
    leading = IconButton(
      icon: Icon(Icons.arrow_back, ),
      onPressed: () => navigate(context, ProductsHome())
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: appBar('Notifications', leading, actions),
        body: Stack(
          children: <Widget>[
            Container(color: Colors.white,),
            Padding(
              padding: const EdgeInsets.only(top:10),
              child: Container(
                padding: const EdgeInsets.only(top:10),
                decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25) ),
                color: Colors.black),
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
                              decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xffffd89b), Color(0xffc4e0e5)]), borderRadius: BorderRadius.circular(25)),
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
                                        subtitle: Text('Read More', style: TextStyle(color: Colors.grey)),
                                        title: Text(product.data['Title'], style: TextStyle(fontSize: 20,
                                        fontWeight: product.data['Read']==0 ? FontWeight.bold : FontWeight.w300,
                                        color: product.data['Read']==0 ? Colors.black : Colors.grey)),
                                        ),
                                        Positioned(
                                          right:10, top: 50,
                                          child: Text(formatDate(product.data['Date'].toDate(), [dd, '/', 'mm', '/', yy]), style: TextStyle(color: Colors.grey),),
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
                        return Center(child: Text('No new notifications!', style: TextStyle(color: Colors.grey, fontSize: 20),),);
                      }
                    }
                  },
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Future addVal(DocumentSnapshot post, int quantity) async{
//     await Firestore.instance.collection('users/${widget.email}/Cart').document(post.documentID)
//     .updateData({
//       'Quantity': quantity+1,
//     });
//     setState(() {
//       data=getData();
//     });
//   }

//   Future remVal(DocumentSnapshot post, int quantity) async{
//     await Firestore.instance.collection('users/${widget.email}/Cart').document(post.documentID)
//     .updateData({
//       'Quantity': quantity-1,
//     });
//     setState(() {
//       data=getData();
//     });
//   }

//   Future delProd(DocumentSnapshot post) async{
//     await Firestore.instance.collection('users/${widget.email}/Cart').document(post.documentID).delete();
//     setState(() {
//       data=getData();
//     });