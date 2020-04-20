import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/user_cart_bloc/user_cart_bloc.dart';
import 'package:e_commerce_bloc/widgets/amount_row.dart';
import 'package:e_commerce_bloc/screens/cart_screen/cart_screen_widgets/apply_button.dart';
import 'package:e_commerce_bloc/screens/cart_screen/cart_screen_widgets/discount.dart';
import 'package:e_commerce_bloc/screens/cart_screen/cart_screen_widgets/product_card.dart';
import 'package:e_commerce_bloc/screens/orders_screen/orders_screen.dart';
import 'package:e_commerce_bloc/widgets/appBar.dart';
import 'package:e_commerce_bloc/widgets/center_image.dart';
import 'package:e_commerce_bloc/widgets/circular_progress_indicator.dart';
import 'package:e_commerce_bloc/widgets/custom_drawer.dart';
import 'package:e_commerce_bloc/widgets/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../navigate.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController controller = TextEditingController();
  int subtotal;

  @override
  void initState() {
    userCartBloc.getCart();
    userCartBloc.discount = 0;
    userCartBloc.shipping = 10;
    userCartBloc.finalAmount = 0;
    controller.text='';
    userCartBloc.codeIn.add(null);
  }

  confirmPurchase() async{
    await userCartBloc.confirmPurchase();
    navigate(context, OrdersScreen());
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
                  return centerImage('Your acrt is empty', 'empty2.png');
                }
                else{
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        child:  Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 20),
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (_, index){
                                return cartProductCard(snapshot.data.documents[index]);
                              }
                            ),
                          ),
                          Divider(
                            thickness: 1.5,
                            indent: 10,
                            endIndent: 10,
                          ),
                          Container(width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20, left: 40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Promo Code?', style: GoogleFonts.sourceSansPro(fontSize: 14, color: Colors.grey)),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        codeTextField(context, controller),
                                        Padding(padding: const EdgeInsets.only(left: 20),
                                          child: InkWell(
                                            onTap: (){
                                              FocusScope.of(context).requestFocus(FocusNode());
                                              if(controller.text!='')
                                              userCartBloc.getPromoCode(controller.text);
                                            },
                                            child: applyButton()
                                          ),
                                        )
                                      ]
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: StreamBuilder(
                                      stream: userCartBloc.codeOut,
                                      builder: (context, AsyncSnapshot<DocumentSnapshot> code){
                                        return StreamBuilder(
                                          stream: userCartBloc.totalOut,
                                          builder: (context, snap){
                                            if(!code.hasData){
                                              if(controller.text=='')
                                                return Container(height: 19);
                                              else{
                                                userCartBloc.resetCode();
                                                return Text('Inavild code', style: GoogleFonts.sourceSansPro(fontSize: 15, color: Colors.red));
                                              }
                                            }
                                            else{
                                              if(code.data['Limit']>snap.data)
                                                return Text("This code can't be applied", style: GoogleFonts.sourceSansPro(fontSize: 15, color: Colors.red));
                                              else{
                                                userCartBloc.codeIn.add(code.data);
                                                return Text("Code applied", style: GoogleFonts.sourceSansPro(fontSize: 15, color: Colors.green));
                                              }
                                            }
                                          }
                                        );
                                      }
                                    )
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 20),
                            child: StreamBuilder<Object>(
                              stream: userCartBloc.totalOut,
                              builder: (context, snapshot) {
                                return StreamBuilder(
                                  stream: userCartBloc.codeOut,
                                  builder: (context, AsyncSnapshot<DocumentSnapshot> code){
                                    String text1='Discount'; String amount1='QR. 0'; Color color1=Colors.grey;
                                    String text2='Shipping'; String amount2='QR. 10'; Color color2=Colors.grey;
                                    if(code.data!=null && code.data['Type']=='Cart'){
                                      if(code.data['Amount']!=null)
                                        amount1 = 'QR. ${code.data['Amount']}';
                                      else
                                        amount1 = '${code.data['Percentage']}%';
                                      color1 = Colors.green;
                                      userCartBloc.getDiscount(code.data);
                                    }
                                    else if (code.data!=null && code.data['Type']=='Shipping'){
                                      amount2 = 'QR. ${code.data['Amount']}';
                                      color2 = Colors.green;
                                      userCartBloc.getShipping(code.data['Amount']);
                                    }
                                    return Column(children: [
                                      amountRow('Subtotal:', 'QR. ${NumberFormat('#,###').format(snapshot.data)}', Colors.black),
                                      amountRow(text1, amount1, color1),
                                      amountRow(text2, amount2, color2)
                                    ]);
                                  }
                                );
                              }
                            ),
                          ),
                          Divider(
                            thickness: 1.5,
                            indent: 10,
                            endIndent: 10,
                          ),
                          StreamBuilder(
                            stream: userCartBloc.finalAmountOut,
                            builder: (context, snapshot){
                              return amountRow('Total:','QR. ${NumberFormat('#,###').format(snapshot.data)}', Colors.blue);
                            },
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 30, left: 40),
                            width: MediaQuery.of(context).size.width,
                            child: Text('Cash On Delivery Only.',
                              style: GoogleFonts.sourceSansPro(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:30, bottom: 20, left: 40, right: 40),
                            child: InkWell(
                              onTap: () => confirmPurchase(),
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.blue[400],
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Center(
                                  child: Text('PLACE ORDER',
                                    style: GoogleFonts.sourceSansPro(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  
                                ),
                              ),
                            ),
                          )
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