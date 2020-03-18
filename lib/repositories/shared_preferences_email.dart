import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference{
  saveData(String emailID) async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setString('email', emailID);
  }
  removeData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', null);
  }
}

final sharedPreference = SharedPreference();