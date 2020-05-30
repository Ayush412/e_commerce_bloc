import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';
import 'package:intl/intl.dart';
import 'cart_and_notification_count.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class UserCartRepo{
  String date = DateFormat.yMMMMd().format(DateTime.now());
  Map<String, String> dateMap = Map<String, String>();
  FirebaseAnalytics analytics = FirebaseAnalytics();

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
        await delProd(element);
      });
    });
    analytics.logBeginCheckout();
    analytics.logEcommercePurchase(
      currency: 'QAR', 
      value: subTotal.toDouble(), 
      shipping: shipping.toDouble()
    );
  }

  getCart()async{
    int total=0;
    QuerySnapshot qs = await Firestore.instance.collection('/users/${loginBloc.userMap['emailID']}/Cart').getDocuments();
    qs.documents.forEach((f) => {
      total = total+(f.data['Quantity']*f.data['ProdCost'])
    });
    return [total,qs];
  }

  Future addVal(DocumentSnapshot product) async{
    await Firestore.instance.collection('users/${loginBloc.userMap['emailID']}/Cart').document(product.documentID)
    .updateData({
      'Quantity': FieldValue.increment(1),
    });
    analytics.logAddToCart(
      itemId: product.documentID, 
      itemName: product.data['ProdName'], 
      itemCategory: product.data['Category'], 
      quantity: 1, 
      price: product.data['ProdCost'],
      currency: 'QAR'
    );

  }

  remVal(DocumentSnapshot product) async{
    await Firestore.instance.collection('users/${loginBloc.userMap['emailID']}/Cart').document(product.documentID)
    .updateData({
      'Quantity': FieldValue.increment(-1),
    });
    analytics.logRemoveFromCart(
      itemId: product.documentID, 
      itemName: product.data['ProdName'], 
      itemCategory: product.data['Category'], 
      quantity: 1,
      price: product.data['ProdCost'],
      currency: 'QAR'
    );
  }

  delProd(DocumentSnapshot product) async{
    await Firestore.instance.collection('users/${loginBloc.userMap['emailID']}/Cart').document(product.documentID).delete();
    analytics.logRemoveFromCart(
      itemId: product.documentID, 
      itemName: product.data['ProdName'], 
      itemCategory: product.data['Category'], 
      quantity: 0, price: product.data['ProdCost'],
      currency: 'QAR'
    );
    getCount();
  }

  addToCart(DocumentSnapshot product, int newVal) async{
    await Firestore.instance.collection('/users/${loginBloc.userMap['emailID']}/Cart')
    .document(product.documentID)
    .get()
    .then((DocumentSnapshot snap){
       snap.exists ?  addVal(product) : addNew(product, newVal);
    });
    analytics.logAddToCart(
      itemId: product.documentID, 
      itemName: product.data['ProdName'], 
      itemCategory: product.data['Category'], 
      quantity: 1, 
      price: product.data['ProdCost'],
      currency: 'QAR'
    );
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
      'imgurl': product.data['images'][0],
    });
  }
}

final userCartRepo = UserCartRepo();