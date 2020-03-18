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
      return true;
    }
    else 
      return false;
  }
  
}

final userRegister = UserRegister();