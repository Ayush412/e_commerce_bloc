import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/products_home_bloc/products_home_bloc.dart';
import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';

getCount() async{
  QuerySnapshot _snap1 = await Firestore.instance.collection('/users/${loginBloc.userMap['emailID']}/Cart').getDocuments();
  List<DocumentSnapshot> _docCount1 = _snap1.documents;
  QuerySnapshot _snap2 = await Firestore.instance.collection('/users/${loginBloc.userMap['emailID']}/Notifications').where('Read', isEqualTo: 0).getDocuments();
  List<DocumentSnapshot> _docCount2 = _snap2.documents;
  productsHomeBloc.cartIn.add(_docCount1.length);
  productsHomeBloc.notificationIn.add(_docCount2.length);
}