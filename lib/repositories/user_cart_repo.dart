import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'cart_and_notification_count.dart';

class UserCartRepo{

  getCart()async{
    int total=0;
    QuerySnapshot qs = await Firestore.instance.collection('/users/${loginBloc.userMap['emailID']}/Cart').getDocuments();
    qs.documents.forEach((f) => {
      total = total+(f.data['Quantity']*f.data['ProdCost'])
    });
    return [total,qs];
  }

  Future addVal(String docID) async{
    await Firestore.instance.collection('users/${loginBloc.userMap['emailID']}/Cart').document(docID)
    .updateData({
      'Quantity': FieldValue.increment(1),
    });
  }

  remVal(String docID) async{
    await Firestore.instance.collection('users/${loginBloc.userMap['emailID']}/Cart').document(docID)
    .updateData({
      'Quantity': FieldValue.increment(-1),
    });
  }

  delProd(String docID) async{
    await Firestore.instance.collection('users/${loginBloc.userMap['emailID']}/Cart').document(docID).delete();
    getCount();
  }

  addToCart(DocumentSnapshot product) async{
    await Firestore.instance.collection('/users/${loginBloc.userMap['emailID']}/Cart')
    .document(product.documentID)
    .get()
    .then((DocumentSnapshot snap){
       snap.exists ?  addVal(product.documentID) : addNew(product);
    });
  }

  addNew(DocumentSnapshot product) async{
    await Firestore.instance.collection('users/${loginBloc.userMap['emailID']}/Cart').document(product.documentID)
    .setData({
      'Quantity': 1,
      'ProdName': product.data['ProdName'],
      'ProdCost': product.data['ProdCost'],
      'imgurl': product.data['imgurl'],
    });
  }
}

final userCartRepo = UserCartRepo();