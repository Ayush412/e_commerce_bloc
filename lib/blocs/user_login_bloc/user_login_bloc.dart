import 'dart:async';
import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/repositories/user_details_repo.dart';
import 'package:rxdart/rxdart.dart';
import 'user_login_validator.dart';

class LoginBloc with ValidateCredentials implements BaseBloc{

  String emailID;
  String pass;
  Map<dynamic, dynamic> userMap = Map<dynamic, dynamic>();
  Map<String, double> rateMap = Map<String, double>();
  List<String> viewedList = List<String>();

  //CONTROLLERS
  BehaviorSubject<String> _emailController = BehaviorSubject();
  BehaviorSubject<String> _passwordController = BehaviorSubject();
  BehaviorSubject<Map> _userDetailsController = BehaviorSubject();
  final _loadingController = BehaviorSubject<bool>();

  //SINKS
  Function(String) get emailChanged => _emailController.sink.add;
  Function(String) get passChanged => _passwordController.sink.add; 
  Sink<Map> get getDetails => _userDetailsController.sink;
  Sink<bool> get loadingStatusIn => _loadingController.sink;
  

  //STREAMS
  Stream<String> get emailCheck => _emailController.stream.transform(emailValidator);
  Stream<String> get passCheck => _passwordController.stream.transform(passValidator);
  Stream<bool> get credentialsCheck => Rx.combineLatest2(emailCheck, passCheck, (a, b) => true); 
  Stream<Map> get giveDetails => _userDetailsController.stream;
  Stream<bool> get loadingStatusOut => _loadingController.stream;

  checkLogin() async{
    return await userDetails.checkUserLogin(emailID, pass);
  }

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _userDetailsController.close();
    _loadingController.close();
  }
}

final loginBloc = LoginBloc();