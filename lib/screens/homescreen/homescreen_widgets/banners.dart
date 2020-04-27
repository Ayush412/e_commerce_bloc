import 'package:flutter_banner_swiper/flutter_banner_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/blocs/products_home_bloc/products_home_bloc.dart';
import 'package:e_commerce_bloc/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';

banners(){
  return StreamBuilder(
    stream: productsHomeBloc.bannerOut,
    builder: (context, AsyncSnapshot<QuerySnapshot> snap){
      if(!snap.hasData){
        bloc.loadingStatusIn.add(true);
        return Center(child:circularProgressIndicator(context));
      }
      else{
        bloc.loadingStatusIn.add(false);
        return BannerSwiper(
          width: MediaQuery.of(context).size.width~/1.2, 
          height: 1000,
          length: snap.data.documents.length,
          getwidget: (count){
            return GestureDetector(
              child: Image.network(
                snap.data.documents[count%snap.data.documents.length].data['imgurl'],
                fit: BoxFit.fill,
              ),
              onTap: () => null 
            );
          }
        );
      }
    }
  );
}