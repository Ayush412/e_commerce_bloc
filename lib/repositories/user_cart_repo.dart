import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';
import 'package:intl/intl.dart';
import 'cart_and_notification_count.dart';

class UserCartRepo{
  String date = DateFormat.yMMMMd().format(DateTime.now());
  Map<String, String> dateMap = Map<String, String>();

  confirmPurchase(Map map, int subTotal, int discount, int shipping, int total) async{
    dateMap['Order Confirmed'] = date;
    await Firestore.instance.collection('users/${loginBloc.userMap['emailID']}/Orders').document().setData({
      'Status Dates': dateMap,
      'Sub Total': subTotal,
      'Total': total,
      'Shipping': shipping,
      'Discount': discount,
      'Items': map,
      'Date': date,
    });
    Firestore.instance.collection('users/${loginBloc.userMap['emailID']}/Cart')..getDocuments().then((value) {
      value.documents.forEach((element) async {
        await delProd(element.documentID);
      });
    });
  }

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

  addToCart(DocumentSnapshot product, int newVal) async{
    await Firestore.instance.collection('/users/${loginBloc.userMap['emailID']}/Cart')
    .document(product.documentID)
    .get()
    .then((DocumentSnapshot snap){
       snap.exists ?  addVal(product.documentID) : addNew(product, newVal);
    });
    getCount();
  }

  getPromoCode(String code) async{
    DocumentSnapshot ds;
    await Firestore.instance.collection('promocodes').document(code).get().then((DocumentSnapshot snap){
      ds=snap;
    });
    if(ds.exists){
      if(DateTime.now().difference(DateTime.parse(ds.data['Start'])).inDays>=0 && DateTime.parse(ds.data['End']).difference(DateTime.now()).inDays>=0){
        if(await getUserPromoQuantity(ds) > 0)
          return ds;
        else
          return null;
      }    
      else
        return null;
    }
    else
      return null;
  }

  getUserPromoQuantity(DocumentSnapshot code) async{
    int quantity = code.data['Quantity'];
    await Firestore.instance.collection('users/${loginBloc.userMap['emailID']}/Promo Codes').document(code.documentID).get().then((DocumentSnapshot snap) async{
      if(snap.exists)
        quantity = snap.data['Quantity'];
      else{
        Firestore.instance.collection('users/${loginBloc.userMap['emailID']}/Promo Codes').document(code.documentID).setData({
          'Quantity' : quantity
        });
      }
    });
    return quantity;
  }

  usePromoCode(String code){
    Firestore.instance.collection('users/${loginBloc.userMap['emailID']}/Promo Codes').document(code).updateData({
      'Quantity': FieldValue.increment(-1)
    });
  }

  addNew(DocumentSnapshot product, int newVal) async{
    await Firestore.instance.collection('users/${loginBloc.userMap['emailID']}/Cart').document(product.documentID)
    .setData({
      'Quantity': 1,
      'ProdName': product.data['ProdName'],
      'ProdCost': newVal,
      'imgurl': product.data['imgurl'],
    });
  }
}

final userCartRepo = UserCartRepo();