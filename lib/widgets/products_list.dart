import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/blocs/products_home_bloc/products_home_bloc.dart';
import 'package:flutter/material.dart';
import 'center_image.dart';
import 'circular_progress_indicator.dart';
import 'product_card.dart';

productsList(){
  return StreamBuilder(
    stream: productsHomeBloc.productsListOut,
    builder: (context, AsyncSnapshot<QuerySnapshot> snap){
      if(snap.data==null){
        bloc.loadingStatusIn.add(true);
        return Center(child:circularProgressIndicator(context));
      }
      else if(snap.data.documents.length==0){
        bloc.loadingStatusIn.add(false);
        return Center(child: centerImage("No products found.", 'search.png'));
      }
      else{
        bloc.loadingStatusIn.add(false);
        return Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: GridView.builder(
            itemCount: snap.data.documents.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 180/225
            ),
            itemBuilder: (context, index) => Card(
              elevation: 0,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: productCard(snap.data.documents[index])
            )
          ),
        );
      }
    }
  );
}