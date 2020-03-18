import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';
import 'package:e_commerce_bloc/repositories/shared_preferences_email.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDetails{

  bool hasData=false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Map<dynamic, dynamic> myMap = Map<dynamic, dynamic>();

  checkUserLogin(String emailID, String pass) async{
    var user;
    print(emailID);
    print(pass);
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
    await Firestore.instance.collection('users').document(loginBloc.emailID).setData({
      'FName': map['FName'],
      'LName': map['LName'],
      'Mob': map['Mob'],
      'Admin': 0,
      'Address': map['Address'],
      'Latitude': map['Latitude'],
      'Longitude': map['Longitude']
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
    getUserData(loginBloc.userMap['emailID']);
  }

}

final userDetails = UserDetails();