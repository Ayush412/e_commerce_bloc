import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/user_cart_bloc/user_cart_bloc.dart';
import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/screens/products_home/products_home.dart';
import 'package:e_commerce_bloc/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class UserCart extends StatefulWidget {
  @override
  _UserCartState createState() => _UserCartState();
}

class _UserCartState extends State<UserCart> {

  dynamic leading;

  @override
  void initState() {
    super.initState();
    userCartBloc.getCart();
    leading = leading = IconButton(
      icon: Icon(Icons.arrow_back, ),
      onPressed: () => navigate(context, ProductsHome())
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: appBar('My Cart', leading, null),
        body: Stack(
                children: <Widget>[
                Container(color: Colors.white),
                Padding(
                padding: const EdgeInsets.only(top:10),
                child: Container( decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),)
              ),
               Padding(
                 padding: const EdgeInsets.only(top: 15, left: 5, right: 5),
                 child: Container(
                 child: StreamBuilder(
                  stream: userCartBloc.cartOut,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(!snapshot.hasData)
                      return Center(child: CircularProgressIndicator());
                    else{
                      if(snapshot.data.documents.length>0){
                        return Stack(
                          children: <Widget>[
                            ListView.builder(
                              padding: const EdgeInsets.all(4.0),
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (_, index){
                                DocumentSnapshot product = snapshot.data.documents[index];
                                return Container(height: 150,
                                  child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    child: Center(
                                      child: Stack(
                                        children: <Widget>[
                                          ListTile(
                                          leading: Image.network(product.data['imgurl'],height: 100, width: 100),
                                          title: Text(product.data['ProdName'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                          subtitle: Text('QR. ${product.data['ProdCost']}', style: TextStyle(fontSize: 16)),
                                          ),
                                          Positioned(
                                            left:252,
                                            top:21,
                                            child: IconButton(icon: Icon(Icons.remove_circle_outline),
                                            onPressed: () => product.data['Quantity']>1 ? userCartBloc.remVal(product.documentID) : null,
                                            ),
                                          ),
                                          Positioned(
                                            left:300,
                                            top:38,
                                            child: Text(product.data["Quantity"].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
                                          ),
                                          Positioned(
                                            left:311,
                                            top:21,
                                            child: IconButton(icon: Icon(Icons.add_circle_outline),
                                            onPressed: () => userCartBloc.addVal(product.documentID)
                                            ),
                                          ),
                                          Positioned(
                                            left:340,
                                            top:38,
                                            child: IconButton(icon: Icon(Icons.delete),
                                            onPressed: () => userCartBloc.delProd(product.documentID),
                                            color: Colors.red,
                                            ),
                                          )
                                        ]
                                      ),
                                    )
                                  ),
                                );
                              }
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom:10.0),
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  width:250,
                                  height:60,
                                  child: Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    color: Colors.green,
                                    child: Center(child: StreamBuilder<Object>(
                                      stream: userCartBloc.totalOut,
                                      builder: (context, snapshot) {
                                        return Text('TOTAL: QR. ${snapshot.data}', 
                                          style: TextStyle(
                                            color: Colors.white, 
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 22)
                                        );
                                      }
                                    ))
                                  )
                                ),
                              ),
                            )
                          ],
                        );
                      }
                      else{
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
                    }
                  },
                )
              ),
            ),
          ],
        )
      )
    );
  }
}