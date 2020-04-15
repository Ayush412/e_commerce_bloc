import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/repositories/orders_repo.dart';
import 'package:rxdart/rxdart.dart';

class OrdersBloc implements BaseBloc{

  //CONTROLLERS
  BehaviorSubject<QuerySnapshot> _ordersController = BehaviorSubject<QuerySnapshot>();

  //SINKS
  Sink<QuerySnapshot> get ordersIn => _ordersController.sink;

  //STREAMS
  Stream<QuerySnapshot> get ordersOut => _ordersController.stream;

  getOrders() async{
    ordersIn.add(await ordersRepo.getOrders());
  }

  @override
  void dispose() {
    _ordersController.close();
  }

}

final OrdersBloc ordersBloc = OrdersBloc();