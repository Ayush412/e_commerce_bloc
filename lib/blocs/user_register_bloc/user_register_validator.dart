import 'dart:async';
import 'package:e_commerce_bloc/blocs/user_register_bloc/user_register_bloc.dart';

mixin ValidateCredentials{

  var emailValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink){
      if (email.contains("@") && email.contains("."))
        sink.add(email);
      else
        sink.addError("Invalid email");
      registerBloc.emailID = email;
    }
  );

  var pass1Validator = StreamTransformer<String, String>.fromHandlers(
    handleData: (password1, sink){
      if (password1.length>5)
        sink.add(password1);
      else
        sink.addError("Must be at least 6 characters");
      registerBloc.pass = password1;
    }
  );

  var pass2Validator = StreamTransformer<String, String>.fromHandlers(
    handleData: (password2, sink){
      if (password2==registerBloc.pass)
        sink.add(password2);
      else
        sink.addError("Passwords don't match");
    }
  );

}