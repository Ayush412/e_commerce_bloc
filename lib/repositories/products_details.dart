import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:e_commerce_bloc/blocs/product_description_bloc/product_description_bloc.dart';
import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ProductDetails{
  StorageReference storageRef;
  List<DocumentSnapshot> products = [];
  DocumentSnapshot lastDoc;
  bool moreLoading = false;
  bool moreDocsLeft = true;
  
  //SCAN TO SEARCH SCREEN FUNCTION...
  getImage() async{
    File newFile;
    newFile =  await ImagePicker.pickImage(source: ImageSource.gallery);
    if(newFile!=null)
      return newFile;
  }

  //ADD PRODUCT SCREEN FUNCTIONS...

  putImage(String name, File imageFile) async{
    storageRef = FirebaseStorage.instance.ref().child('product images/$name ${Random().nextInt(10000)}-${Random().nextInt(10000)}.jpg');
    StorageUploadTask upload = storageRef.putFile(imageFile);
    StorageTaskSnapshot downloadUrl = await upload.onComplete;
    return await downloadUrl.ref.getDownloadURL();
  }

   addProduct(Map map) async{
    await Firestore.instance.collection('products').document().setData({
      '1 Star': 0,
      '2 Star': 0,
      '3 Star': 0,
      '4 Star': 0,
      '5 Star': 0,
      'Rate': 0,
      'Views': 0,
      'ProdName': map['ProdName'],
      'Category': map['Category'],
      'SubCategory': map['SubCategory'],
      'Stock': int.parse(map['Stock']),
      'ProdCost': int.parse(map['ProdCost']),
      'Description': map['Description'],
      'imgurl': map['imgurl'],
      'scan': map['labels'],
    });
  }

  //PRODUCTS HOME SCREEN FUNCTIONS...

  getProductsList() async{
    QuerySnapshot qs =  await Firestore.instance.collection('products').getDocuments();
    return qs;
  }

  getToprated(bool limited) async{
    if(limited)
      return await Firestore.instance.collection('products').where('Rate', isGreaterThanOrEqualTo: 4).limit(8).getDocuments();
    else
      return await Firestore.instance.collection('products').where('Rate', isGreaterThanOrEqualTo: 4).getDocuments();
  }

  getDiscounted(bool limited) async{
    if(limited)
      return await Firestore.instance.collection('products').where('Discount', isGreaterThan: 5).limit(8).getDocuments();
    else
      return await Firestore.instance.collection('products').where('Discount', isGreaterThan: 5).getDocuments();
  }

  getBanners() async{
    return await Firestore.instance.collection('banners').getDocuments();
  }

  getProductListFiltered(List sort, String category, String subcategory) async{
    print('$sort $category $subcategory');
    if(sort==null)
    {
      if(subcategory==null)
        return await Firestore.instance.collection('products').where("Category", isEqualTo: category).getDocuments();
      else
        return await Firestore.instance.collection('products').where("SubCategory", isEqualTo: subcategory).getDocuments();
    }
    else{
      if(category==null && subcategory==null)
        return await Firestore.instance.collection('products')
          .orderBy(sort[0], descending: sort[1])
          .getDocuments();
      else if(subcategory==null)
        return await Firestore.instance.collection('products')
          .where("Category", isEqualTo: category)
          .orderBy(sort[0], descending: sort[1])
          .getDocuments();
      else
      return await Firestore.instance.collection('products')
        .where("SubCategory", isEqualTo: subcategory)
        .orderBy(sort[0], descending: sort[1])
        .getDocuments();
    }
  }

  
  //PRODUCT DESCRIPTION SCREEN FUNCTIONS...

  addView(String docID) async {
    await Firestore.instance
        .collection('users/${loginBloc.userMap['emailID']}/Visited')
        .document(docID)
        .setData({});
    await Firestore.instance
        .collection('products')
        .document(docID)
        .updateData({'Views': FieldValue.increment(1)});
  } 

  getAllRatings() async{
    QuerySnapshot qs = await Firestore.instance.collection('users/${loginBloc.userMap['emailID']}/Visited').getDocuments();
    qs.documents.forEach((f){ 
      if(!productDescBloc.viewedList.contains(f.documentID))
      productDescBloc.viewedList.add(f.documentID);
      if(f.data['Rate']!=null)
      productDescBloc.rateMap['${f.documentID}']=f.data['Rate'].toDouble();
      }
    );
  }

  getReviews(String docID) async{
    QuerySnapshot qs = await Firestore.instance.collection('products/$docID/Reviews').orderBy('Date', descending: true).limit(3).getDocuments();
    products = qs.documents;
    if(products.length == 0){
      return null;
    }
    lastDoc = qs.documents[qs.documentChanges.length-1];
    print(products.length);
    productDescBloc.reviewIn.add(products);
    productDescBloc.heightIn.add(170);
  }

  getNextReviews(String docID) async{
    if(moreDocsLeft == false){
      return;
    }
    if(moreLoading == true){
      return;
    }
    moreLoading = true;
    QuerySnapshot qs = await Firestore.instance.collection('products/$docID/Reviews').orderBy('Date', descending: true).startAfter([lastDoc.data['Date']]).limit(2).getDocuments();
    if(qs.documents.length == 0){
      moreDocsLeft = false;
      return;
    }
    products.addAll(qs.documents);
    lastDoc = qs.documents[qs.documents.length-1];
    moreLoading = false;
    productDescBloc.heightIn.add(240);
    productDescBloc.reviewIn.add(products);
  }

  addRating(String text, double userRate, String docID) async{
    String date = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    await Firestore.instance.collection('products/$docID/Reviews').document(loginBloc.emailID).setData({
      'Name': '${loginBloc.userMap['FName']} ${loginBloc.userMap['LName']}',
      'Date': date,
      'Rate': userRate,
      'Text': text
    });
  }

  getUserRating(String docID) async{
    await Firestore.instance
        .collection('/users/${loginBloc.userMap['emailID']}/Visited')
        .document(docID)
        .get()
        .then((DocumentSnapshot snap) {
      if (snap.data['Rate']!=null)
        productDescBloc.userRatingIn.add(snap.data['Rate'].toDouble());
      else
        productDescBloc.userRatingIn.add(0);
    });
  }

  setUserRating(int rate, double totalRate, int totalVotes, String docID) async{
    await Firestore.instance
      .collection('products')
      .document(docID)
      .updateData({
        '$rate Star': FieldValue.increment(1),
        'Rate': (((totalRate * totalVotes) + rate) / (totalVotes + 1)).round()
      });
    await Firestore.instance
      .collection('users/${loginBloc.userMap['emailID']}/Visited')
      .document(docID)
      .setData({'Rate': rate});
  }

  updateUserRating(int oldRate, int newRate, double totalRate, int totalVotes, String docID) async{
    await Firestore.instance
      .collection('products')
      .document(docID)
      .updateData({
        '$newRate Star': FieldValue.increment(1),
        'Rate': (((totalRate * (totalVotes - 1)) + newRate) / (totalVotes)).round()
      });
    await Firestore.instance
      .collection('users/${loginBloc.userMap['emailID']}/Visited')
      .document(docID)
      .updateData({'Rate': newRate});
    await Firestore.instance
      .collection('products')
      .document(docID)
      .updateData({
        '${oldRate.toStringAsFixed(0)} Star': FieldValue.increment(-1)
      });
  }

   deleteItem(DocumentSnapshot data) async {
    await Firestore.instance
      .collection('products')
      .document(data.documentID)
      .delete();
    await deleteImage(data.data['imgurl']);
  }

  deleteImage(String url) async {
    StorageReference storageRef;
    storageRef = await FirebaseStorage.instance.getReferenceFromUrl(url);
    await storageRef.delete();
  }

  getViewsAndAdds(String docID) async {
    List<int> visitCount = List<int>();
    List<int> addCount = List<int>();
    List<ProductData> productData = List<ProductData>();
    List<String> labels = List<String>();
    List<charts.Series<ProductData, String>> series = List<charts.Series<ProductData, String>>();
    Map<dynamic, dynamic> myMap = Map<dynamic, dynamic>();
    String date = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    var keys = [];

    DocumentSnapshot ds = await Firestore.instance
        .collection('products')
        .document(docID)
        .get();
    if (ds.data['Map'] == null) {
      myMap[date] = [0, 0];
      addViewsAndPurchases(myMap, docID);
    } else {
      myMap = ds.data['Map'];
      if (myMap[date] == null) {
        myMap[date] = [0, 0];
        addViewsAndPurchases(myMap, docID);
      }
    }
    if (loginBloc.userMap['Admin'] != 1) {
      myMap[date][0] += 1;
      addViewsAndPurchases(myMap, docID);
    }
    keys = myMap.keys.toList()..sort();
    for (int i = 0; i < keys.length; i++) {
      visitCount.add((myMap[keys[i]][0]));
      addCount.add((myMap[keys[i]][1]));
      labels.add(
          (formatDate(DateTime.parse('${keys[i]} 00:00:00'), [dd, ' ', M, yy]))
              .toString());
      productData.add(ProductData(labels[i], visitCount[i], addCount[i]));
    }
    series = [
      charts.Series(
          id: 'Views',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (ProductData visits, _) => visits.date,
          measureFn: (ProductData visits, _) => visits.visits,
          data: productData),
      charts.Series(
          id: 'Purchases',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (ProductData adds, _) => adds.date,
          measureFn: (ProductData adds, _) => adds.adds,
          data: productData),
    ];
    return [labels, series];
  }
  
  addViewsAndPurchases(Map myMap, String docID) async {
    await Firestore.instance
        .collection('products')
        .document(docID)
        .updateData({'Map': myMap});
  }

}
final productDetails = ProductDetails();

class ProductData {
  String date;
  int visits;
  int adds;
  ProductData(this.date, this.visits, this.adds);
}