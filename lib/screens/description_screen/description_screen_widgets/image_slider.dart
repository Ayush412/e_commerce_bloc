import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce_bloc/blocs/product_description_bloc/product_description_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutube/flutube.dart';

imageSlider(List images, String trailer){
  int count = images.length;
  if(trailer!=null)
    count++;
  return Column(
    children: [
      CarouselSlider.builder(
        enableInfiniteScroll: false,
        itemCount: count, 
        itemBuilder: (context, index){
          return Image.network(images[index], height: 300, width: 300);
        },
        onPageChanged: (index) => productDescBloc.pageIn.add(index),
      ),
      count > 1 ? StreamBuilder<Object>(
        stream: productDescBloc.pageOut,
        builder: (context, snapshot) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images.map((url) {
              int index = images.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: snapshot.data == index
                    ? Colors.blue[300]
                    : Colors.grey[200],
                ),
              );
            }).toList(),
          );
         }
       ) : Container()
    ],
  );
}