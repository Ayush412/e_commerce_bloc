import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/product_description_bloc/product_description_bloc.dart';
import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';
import 'package:e_commerce_bloc/repositories/products_details.dart';
import 'package:e_commerce_bloc/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class DescriptionScreen extends StatefulWidget {
  DocumentSnapshot post;
  DescriptionScreen({this.post});
  @override
  _DescriptionScreenState createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>(); 
  dynamic leading;
  TextEditingController controller1 = TextEditingController();
  ScrollController controller2 = ScrollController();
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
    controller2.addListener(() {
      double maxScroll = controller2.position.maxScrollExtent;
      double currentScroll = controller2.position.pixels;
      double delta = MediaQuery.of(context).size.height*0.25;
      if(maxScroll - currentScroll <= delta){
        productDescBloc.getNextReviews(widget.post.documentID);
      }
    });
    if(!productDescBloc.viewedList.contains(widget.post.documentID) &&
      loginBloc.userMap['Admin'] != 1){ productDescBloc.addView(widget.post.documentID);}
  }

  @override
  Widget build(BuildContext context) {
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
          child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: appBar(context, scaffoldKey, false, controller1, null, null),
        ),
      ),
    );
  }
}