import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/repositories/user_cart_repo.dart';
import 'package:rxdart/rxdart.dart';

class UserCartBloc implements BaseBloc{

  //CONTROLLERS
  BehaviorSubject<QuerySnapshot> _cartController = BehaviorSubject();
  BehaviorSubject<int> _totalController = BehaviorSubject();

  //SINKS
  Sink<QuerySnapshot> get cartIn => _cartController.sink;
  Sink<int> get totalIn => _totalController.sink;

  //STREAMS
  Stream<QuerySnapshot> get cartOut => _cartController.stream;
  Stream<int> get totalOut => _totalController.stream;

  getCart() async{
    List data = await userCartRepo.getCart();
    totalIn.add(data[0]);
    cartIn.add(data[1]);
  }

  addVal(String doc) async{
    await userCartRepo.addVal(doc);
    getCart();
  }

  remVal(String doc) async{
    await userCartRepo.remVal(doc);
    getCart();
  }

  delProd(String doc) async{
    await userCartRepo.delProd(doc);
    getCart();
  }

  @override
  void dispose() {
    _cartController.close();
    _totalController.close();
  }

}

final userCartBloc = UserCartBloc();