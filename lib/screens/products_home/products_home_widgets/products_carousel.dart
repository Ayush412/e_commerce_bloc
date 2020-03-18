import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/blocs/products_home_bloc/products_home_bloc.dart';
import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/screens/product_description/product_description.dart';
import 'package:e_commerce_bloc/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';

productsCarousel(){
  return StreamBuilder(
    stream: productsHomeBloc.productsCarouselOut,
    builder: (context, AsyncSnapshot<QuerySnapshot> snap){
      if(!snap.hasData){
        bloc.loadingStatusIn.add(true);
        return Center(child:circularProgressIndicator(context));
      }
      else{
        bloc.loadingStatusIn.add(false);
        return CarouselSlider.builder(
          autoPlay: false,
          itemCount: snap.data.documents.length,
          itemBuilder: (BuildContext context, index){
            DocumentSnapshot product = snap.data.documents[index];
            return Padding(
              padding: const EdgeInsets.only(top:30.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(20)),
                width: 320,
                child: GestureDetector(
                  onTap: () => navigate(context, ProductDescription(post: product, tag: 'card${product.documentID}',)), //TODO navigate to detail,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 5, left: 20,
                          child: Text(product.data['ProdName'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                        ),
                        Center(
                          child: Hero(
                            tag: 'card${product.documentID}',
                            child: Image.network(product.data['imgurl'], height:120, width:120)),
                        ),
                        Positioned(
                          top: 165, left:20,
                          child: Text('QR. ${product.data['ProdCost']}', style: TextStyle(fontSize: 18),)
                        ),
                        Positioned(
                          top:160,
                          right:20,
                          child: Container(
                            height:25,
                            width: 80,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.green),
                            child: Center(child: Text("Buy Now", style: TextStyle(color: Colors.white),))
                          )
                        ),
                      ],
                    )
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