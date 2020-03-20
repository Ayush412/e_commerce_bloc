import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/product_description_bloc/product_description_bloc.dart';
import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';
import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/repositories/products_details.dart';
import 'package:e_commerce_bloc/repositories/user_cart_repo.dart';
import 'package:e_commerce_bloc/screens/product_description/product_description_widgets/barcode.dart';
import 'package:e_commerce_bloc/screens/product_description/product_description_widgets/description.dart';
import 'package:e_commerce_bloc/screens/product_description/product_description_widgets/graph.dart';
import 'package:e_commerce_bloc/screens/product_description/product_description_widgets/ratings.dart';
import 'package:e_commerce_bloc/screens/product_description/product_description_widgets/reviews.dart';
import 'package:e_commerce_bloc/screens/product_description/product_description_widgets/view_count.dart';
import 'package:e_commerce_bloc/screens/products_home/products_home.dart';
import 'package:e_commerce_bloc/widgets/app_bar.dart';
import 'package:e_commerce_bloc/widgets/show_dialog.dart';
import 'package:e_commerce_bloc/widgets/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ProductDescription extends StatefulWidget {
  DocumentSnapshot post;
  String tag;
  ProductDescription({this.post, this.tag});
  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>(); 
  dynamic leading;
  ScrollController controller = ScrollController();
  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    productDetails.moreLoading = false;
    productDetails.moreDocsLeft = true;
    productDescBloc.reviewIn.add(null);
    productDescBloc.userRatingIn.add(null);
    if(loginBloc.userMap['Admin'] != 1){
      productDescBloc.getUserRating(widget.post.documentID);
      productDescBloc.getReviews(widget.post.documentID);
    }
    else{
      productDescBloc.getChartData(widget.post.documentID);
    }
    leading = IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop());
    controller.addListener(() {
      double maxScroll = controller.position.maxScrollExtent;
      double currentScroll = controller.position.pixels;
      double delta = MediaQuery.of(context).size.height*0.25;
      if(maxScroll - currentScroll <= delta){
        productDescBloc.getNextReviews(widget.post.documentID);
      }
    });
    if(!productDescBloc.viewedList.contains(widget.post.documentID) &&
      loginBloc.userMap['Admin'] != 1){ productDescBloc.addView(widget.post.documentID);}
  }

  addItem() async{
    await userCartRepo.addToCart(widget.post);
    scaffoldKey.currentState.showSnackBar(ShowSnack('Item added!', Colors.white, Colors.green));
  }

  deleteItem() async{
    Navigator.pop(context, true);
    pr.show();
    await productDetails.deleteItem(widget.post);
    pr.hide();
    navigate(context, ProductsHome());
  }

  @override
  Widget build(BuildContext build) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(
      message: 'Deleting..',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    return WillPopScope(
      onWillPop: () { Navigator.of(context).pop();},
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          key: scaffoldKey,
          extendBodyBehindAppBar: true,
          appBar: appBar(widget.post.data['ProdName'], leading, null),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 100, bottom: 10),
                  child: Center(
                    child: Hero(
                      tag: widget.tag.contains('card') ? 'card${widget.post.documentID}'
                        : '${widget.post.documentID}',
                      child: Image.network(widget.post.data['imgurl'], height: 300, width: 300)
                    ),
                  ),
                ),
                viewCount(widget.post),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Container(
                    width: 380,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        description(build, widget.post),
                        Padding(
                          padding: const EdgeInsets.only( top: 30, left: 10, right: 10),
                          child: Divider(
                            height: 0.2,
                            color: Colors.grey,
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 35, left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Rating:',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 23
                              )
                            ),
                          )
                        ),
                        ratings(widget.post),
                        Padding(
                          padding:const EdgeInsets.only(top: 30, left: 10),
                          child: Text('Reviews:',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 23
                            )
                          )
                        ),
                        reviews(controller)
                      ],
                    )
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: generateBarcode(widget.post.documentID), 
                ),
                loginBloc.userMap['Admin']==1 ? Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    width:MediaQuery.of(context).size.width / 1.05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Container(
                            height: 40,
                            width: 300,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:BorderRadius.circular(20)),
                            child: Center(
                              child: Text('Views and Purchase Analytics',
                                style: TextStyle(fontSize: 20,color: Colors.black,fontWeight:FontWeight.w600)
                              )
                            )
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:20, bottom:20),
                          child: Container(
                            height: 280, width: 340,
                            child: lineChart()
                          )
                        )
                      ]
                    )
                  )
                ) : Container(),
                Padding(
                  padding: const EdgeInsets.only(top:30, bottom: 30),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    width: 260,
                    height: 60,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      splashColor: Colors.grey,
                      onTap: () => loginBloc.userMap['Admin'] == 1
                        ? showDialogBox(context, 'Warning', 'Do you want to delete this product?', () => deleteItem())
                        : widget.post.data['Stock'] > 0
                          ? addItem()
                          : ShowSnack('Out of stock! Check back later.', Colors.black, Colors.orange),
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          color: loginBloc.userMap['Admin'] == 1
                              ? Colors.red
                              : widget.post.data['Stock'] > 0 ? Colors.green : Colors.orange,
                          child: Center(
                              child: Text(
                            loginBloc.userMap['Admin'] == 1
                                ? 'Delete Product'
                                : widget.post.data['Stock'] > 0
                                    ? 'Add To Cart'
                                    : 'Check back later',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 26),
                          ))),
                    ),
                  ),
                )
              ],
            )
          ),
        )
      ),
    );
  }
}
