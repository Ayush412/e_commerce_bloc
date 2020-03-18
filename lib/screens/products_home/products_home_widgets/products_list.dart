import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/blocs/products_home_bloc/products_home_bloc.dart';
import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/screens/product_description/product_description.dart';
import 'package:e_commerce_bloc/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';

productsList(){
  return StreamBuilder(
    stream: productsHomeBloc.productsListOut,
    builder: (context, AsyncSnapshot<QuerySnapshot> snap){
      if(!snap.hasData){
          bloc.loadingStatusIn.add(true);
          return Center(child:circularProgressIndicator(context));
      }
      else{
        bloc.loadingStatusIn.add(false);
        return ListView.builder(
          itemCount: snap.data.documents.length,
          itemBuilder: (context, index){
            DocumentSnapshot product = snap.data.documents[index];
            return Container(
              height: 130,
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      ListTile(
                        onTap: () => navigate(context, ProductDescription(post: product, tag: product.documentID,)),
                          leading: Hero(
                            tag: '${product.documentID}',
                            child: Image.network(product.data['imgurl'],height: 100, width: 100)),
                              subtitle: Text('QR. ${product.data['ProdCost'].toString()}', style: TextStyle(color: Colors.grey)),
                              title: Text(product.data['ProdName'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                      ),
                      Positioned(
                        left:260,
                        top:45,
                        child: Row(
                          children: List.generate(5, (val) {
                            return Icon(
                              val < product.data['Rate'] ? Icons.star : Icons.star_border,
                              color: Colors.black,
                            );
                          }),
                        )
                      )
                    ]
                  ),
                )
              ),
            );
          }
        );
      }
    }
  );
}