import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/user_details_bloc/user_details_bloc.dart';
import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';
import 'package:e_commerce_bloc/repositories/shared_preferences_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserDetails{

  bool hasData=false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Map<dynamic, dynamic> myMap = Map<dynamic, dynamic>();

  checkUserLogin(String emailID, String pass) async{
    var user;
    try{
      user = await _auth.signInWithEmailAndPassword(email: emailID, password: pass);
    }catch(e){print('Not found.');}
    if (user==null){
      return false;
    }
    else{
      await getUserData(emailID);
      await getUserRatings(emailID);
      return true;
    }
  }

  getUserData(String emailID) async{
    await Firestore.instance.collection('users').document(emailID).get().then((DocumentSnapshot snapshot){
      myMap = snapshot.data;
    });
    if(myMap==null)
      loginBloc.userMap = null;
    else{
      myMap.putIfAbsent('emailID', () => emailID);
      loginBloc.userMap = myMap;
      userDetailsBloc.userMapIn.add(myMap);
    }
    if(myMap['Subs']!=null){
      userSubscriptions();
    }
  }

  userSubscriptions() async{
    FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
    for(int i = 0; i < myMap['Subs'].length; i++){
      firebaseMessaging.subscribeToTopic(myMap['Subs'][i]);
    } 
  }

  unsubscribeTopics() async{
    FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
    for(int i = 0; i < myMap['Subs'].length; i++){
      firebaseMessaging.unsubscribeFromTopic(myMap['Subs'][i]);
    } 
  }

  subscribeTopics() async{
    FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
    Map<String, dynamic> map = Map<String, dynamic>();
    List<String> keys = List<String>();
    await Firestore.instance.collection('users')
    .document(loginBloc.userMap['emailID'])
    .get()
    .then((DocumentSnapshot snap){
      map.addAll(snap.data['Views']);
    });
    keys=map.keys.toList();
    for(int i = 0; i<keys.length; i++){
      if(map[keys[i]]>=250)
        firebaseMessaging.subscribeToTopic(keys[i].toLowerCase().replaceAll(' ', '_'));
    }
  }

  getUserRatings(String emailID) async{
    QuerySnapshot qs = await Firestore.instance.collection('users/$emailID/Visited').getDocuments();
    qs.documents.forEach((f){ 
      if(!loginBloc.viewedList.contains(f.documentID))
      loginBloc.viewedList.add(f.documentID);
      if(f.data['Rate']!=null)
      loginBloc.rateMap['${f.documentID}']=f.data['Rate'];
      }
    );
  }

  saveUserData(Map map) async{
    Map<String, int> views = {'Audio':0, 'Gaming':0, 'Laptops':0, 'Mens Wear':0, 'Womens Wear':0, 'Smart Phones':0};
    await Firestore.instance.collection('users').document(loginBloc.emailID).setData({
      'FName': map['FName'],
      'LName': map['LName'],
      'Mob': map['Mob'],
      'Admin': 0,
      'Address': map['Address'],
      'Latitude': map['Latitude'],
      'Longitude': map['Longitude'],
      'Views': views
    });
    sharedPreference.saveData(loginBloc.emailID);
  }
  updateUserData(Map map) async{
    await Firestore.instance.collection('users').document(loginBloc.userMap['emailID']).updateData({
      'FName': map['FName'],
      'LName': map['LName'],
      'Mob': map['Mob'],
      'Address': map['Address'],
      'Latitude': map['Latitude'],
      'Longitude': map['Longitude']
    });
    await getUserData(loginBloc.userMap['emailID']);
  }

}

final userDetails = UserDetails();