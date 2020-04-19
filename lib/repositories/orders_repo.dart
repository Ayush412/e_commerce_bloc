import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';

class OrdersRepo{

  getOrders() async{
    QuerySnapshot qs = await Firestore.instance.collection('users/${loginBloc.userMap['emailID']}/Orders').orderBy('Date', descending: true).getDocuments();
    return qs;
  }

}

final OrdersRepo ordersRepo = OrdersRepo();