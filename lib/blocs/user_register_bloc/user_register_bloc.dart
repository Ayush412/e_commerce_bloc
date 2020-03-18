import 'dart:async';
import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/repositories/user_register_repo.dart';
import 'package:rxdart/rxdart.dart';
import 'user_register_validator.dart';

class LoginBloc with ValidateCredentials implements BaseBloc{

  String emailID;
  String pass;
  bool hasData = false;
  Map<dynamic, dynamic> userMap = Map<dynamic, dynamic>();

  //CONTROLLERS
  BehaviorSubject<String> _emailController = BehaviorSubject();
  BehaviorSubject<String> _password1Controller = BehaviorSubject();
  BehaviorSubject<String> _password2Controller = BehaviorSubject();

  //SINKS
  Function(String) get emailChanged => _emailController.sink.add;
  Function(String) get pass1Changed => _password1Controller.sink.add; 
  Function(String) get pass2Changed => _password2Controller.sink.add; 

  //STREAMS
  Stream<String> get emailCheck => _emailController.stream.transform(emailValidator);
  Stream<String> get pass1Check => _password1Controller.stream.transform(pass1Validator);
  Stream<String> get pass2Check => _password2Controller.stream.transform(pass2Validator);
  Stream<bool> get credentialsCheck => Rx.combineLatest3(emailCheck, pass1Check, pass2Check, (a, b, c) => true); 

  createLogin() async{
    return await userRegister.createLogin(emailID, pass);
  }

  @override
  void dispose() {
    _emailController.close();
    _password1Controller.close();
    _password2Controller.close();
  }
}

final registerBloc = LoginBloc();