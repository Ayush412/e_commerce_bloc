import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/repositories/user_cart_repo.dart';
import 'package:e_commerce_bloc/widgets/appBar.dart';
import 'package:e_commerce_bloc/blocs/product_description_bloc/product_description_bloc.dart';
import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';
import 'package:e_commerce_bloc/repositories/products_details.dart';
import 'package:e_commerce_bloc/widgets/custom_drawer.dart';
import 'package:e_commerce_bloc/widgets/show_dialog.dart';
import 'package:e_commerce_bloc/widgets/show_snack.dart';
import 'description_screen_widgets/barcode.dart';
import 'description_screen_widgets/ratings.dart';
import 'description_screen_widgets/reviews.dart';
import 'description_screen_widgets/view_count.dart';
import 'description_screen_widgets/description.dart';
import 'description_screen_widgets/graph.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class DescriptionScreen extends StatefulWidget {
  final DocumentSnapshot post;
  DescriptionScreen({this.post});
  @override
  _DescriptionScreenState createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  dynamic leading;
  ScrollController controller = ScrollController();
  ProgressDialog pr;
  int newVal;

  @override
  void initState() {
    super.initState();
    newVal = widget.post.data['ProdCost']-((widget.post.data['ProdCost']*widget.post.data['Discount']/100)).round();
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
    await userCartRepo.addToCart(widget.post, newVal);
    scaffoldKey.currentState.showSnackBar(ShowSnack('Item added!', Colors.white, Colors.green));
  }

  deleteItem() async{
    Navigator.pop(context, true);
    pr.show();
    await productDetails.deleteItem(widget.post);
    pr.hide();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(
      message: 'Deleting...',
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
      onWillPop: (){Navigator.of(context).pop();},
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey,
          drawer: customDrawer(context),
          appBar: appBar(context, scaffoldKey, false, null, null, null, ''),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Center(
                    child: Image.network(widget.post.data['imgurl'], height: 300, width: 300)
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
                        description(context, widget.post),
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
                    width: 280,
                    height: 40,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5),
                      splashColor: Colors.grey,
                      onTap: () => loginBloc.userMap['Admin'] == 1
                        ? showDialogBox(context, 'Warning', 'Do you want to delete this product?', () => deleteItem())
                        : widget.post.data['Stock'] > 0
                          ? addItem()
                          : ShowSnack('Out of stock! Check back later.', Colors.black, Colors.orange),
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          color: loginBloc.userMap['Admin'] == 1
                              ? Colors.red
                              : widget.post.data['Stock'] > 0 ? Colors.blue[400] : Colors.orange,
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
            ),
          ),
        ),
      ),
    );
  }
}