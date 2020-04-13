import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/user_cart_bloc/user_cart_bloc.dart';
import 'package:e_commerce_bloc/screens/cart_screen/cart_screen_widgets/amount_row.dart';
import 'package:e_commerce_bloc/screens/cart_screen/cart_screen_widgets/product_card.dart';
import 'package:e_commerce_bloc/widgets/appBar.dart';
import 'package:e_commerce_bloc/widgets/circular_progress_indicator.dart';
import 'package:e_commerce_bloc/widgets/custom_drawer.dart';
import 'package:e_commerce_bloc/widgets/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
     userCartBloc.getCart();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showDialogBox(context, 'Warning', 'Do you want to delete this product?', () => Navigator.of(context).pop()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          drawer: customDrawer(context),
          appBar: appBar(context, scaffoldKey, false, null, null, null, 'My Cart'),
          body: StreamBuilder(
            stream: userCartBloc.cartOut,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              else{
                if(snapshot.data.documents.length==0){
                  return Center(
                    child: Stack(children: <Widget>[
                      Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, 
                            image: DecorationImage(
                              image: AssetImage('empty2.png'),
                              fit: BoxFit.cover)),
                        )
                      ),
                      Center(
                        child: Padding(padding: EdgeInsets.only(top:240),
                        child: Text("Your cart is empty!", style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),)),
                      )
                    ]),
                  );
                }
                else{
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        child:  Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 20),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (_, index){
                                DocumentSnapshot product = snapshot.data.documents[index];
                                return cartProductCard(product);
                              }
                            ),
                          ),
                          Divider(
                            thickness: 1.5,
                            indent: 10,
                            endIndent: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: StreamBuilder<Object>(
                              stream: userCartBloc.totalOut,
                              builder: (context, snapshot) {
                                return amountRow('Subtotal:', snapshot.data, Colors.black);
                              }
                            ),
                          ),
                          amountRow('Discount:', 5, Colors.green[300]),
                          amountRow('Shipping:', 10, Colors.grey),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: circularProgressIndicator(context),
                        ),
                      )
                    ],
                  );
                }
              }
            }
          )
        ),
      ),
    );
  }
}