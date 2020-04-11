import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/blocs/products_home_bloc/products_home_bloc.dart';
import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/screens/description_screen/description_screen.dart';
import 'package:e_commerce_bloc/widgets/circular_progress_indicator.dart';
import 'package:e_commerce_bloc/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

topRated(){
  return StreamBuilder(
    stream: productsHomeBloc.productsCarouselOut,
    builder: (context, AsyncSnapshot<QuerySnapshot> snap){
      if(!snap.hasData){
        bloc.loadingStatusIn.add(true);
        return Center(child:circularProgressIndicator(context));
      }
      else{
        bloc.loadingStatusIn.add(false);
        return Container(
          height: 225,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snap.data.documents.length,
            itemBuilder: (context, index){
              DocumentSnapshot product = snap.data.documents[index];
              return Padding(
                padding: const EdgeInsets.only(left:20),
                child: GestureDetector(
                  onTap: () => navigate(context, DescriptionScreen(post: product)),
                  child: productCard(product)
                )
                
              );
            }
          ),
        );
      }
    }
  );
}