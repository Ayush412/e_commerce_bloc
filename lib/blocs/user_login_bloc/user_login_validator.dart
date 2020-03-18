import 'dart:async';
import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';

mixin ValidateCredentials{

  var emailValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink){
      if (!email.contains("@") && !email.contains(".") || email=='')
      sink.addError("Invalid email");
      else
        sink.add(email);
      loginBloc.emailID = email;
    }
  );

  var passValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink){
      if (password==null || password=='')
        sink.addError("Must be provided");
      else
        sink.add(password); 
      loginBloc.pass = password;
    }
  );
  getdata(){
  
  }
}