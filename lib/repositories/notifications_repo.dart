import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'cart_and_notification_count.dart';

class NotificationsRepo{
  String text;
  String title;
  String imgurl;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  listen(){
    _fcm.getToken().then((token) => print(token));
      _fcm.subscribeToTopic('e-commerce');
      _fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
        text=message['notification']['body'];
        title=message['notification']['title'];
        int i=0;
        imgurl='';
        while(text[i]!= ' '){
        imgurl+=text[i];
        i++;
        }
        text=text.substring(i+1, text.length);
        addNotification(text, title, imgurl);
        getCount();
    },
    onResume: (Map<String, dynamic> message) async {
        text=message['notification']['body'];
        title=message['notification']['title'];
        int i=0;
        imgurl='';
        while(text[i]!= ' '){
        imgurl+=text[i];
        i++;
        }
        text=text.substring(i+1, text.length);
        addNotification(text, title, imgurl);
        getCount();
    });
  }

  addNotification(String text, String title, String imgurl){
    this.text=text;
    this.title=title;
    this.imgurl=imgurl;
    add();
  }

  getNotifications() async{
    QuerySnapshot qs = await Firestore.instance.collection('/users/${loginBloc.userMap['emailID']}/Notifications').getDocuments();
    return qs;
  }

  add() async{
    await Firestore.instance.collection('users/${loginBloc.userMap['emailID']}/Notifications').document()
    .setData({
      'Title': title,
      'Text': text,
      'Date': DateTime.now(),
      'Read': 0,
      'imgurl': imgurl
    });
  }

  delete(DocumentSnapshot doc) async{
    await Firestore.instance.collection('users/${loginBloc.userMap['emailID']}/Notifications').document(doc.documentID).delete();
  }

  deleteAll() async{
     QuerySnapshot qs = await Firestore.instance.collection('users/${loginBloc.userMap['emailID']}/Notifications').getDocuments();
    qs.documents.forEach((f) => delete(f));
  }

  markAsRead(String docID) async{
  await Firestore.instance.collection('users/${loginBloc.userMap['emailID']}/Notifications').document(docID).updateData({
      'Read': 1
    });
  } 
  
}

final notificationsRepo = NotificationsRepo();