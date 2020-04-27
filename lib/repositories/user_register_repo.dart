import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'shared_preferences_email.dart';

class UserRegister{

  FirebaseAuth _auth = FirebaseAuth.instance;

  createLogin(String emailID, String pass) async{
    var user;
    try{
      user = await _auth.createUserWithEmailAndPassword(email: emailID, password: pass);
    }catch(e){print(e);}
    if(user!=null){
      sharedPreference.saveData(emailID);
      Firestore.instance.collection('analytics').document('users').updateData({
        'Total': FieldValue.increment(1)
      });
      return true;
    }
    else 
      return false;
  }
  
}

final userRegister = UserRegister();