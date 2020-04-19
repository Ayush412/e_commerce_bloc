import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/blocs/scan_to_seaarch_bloc/scan_to_search_bloc.dart';
import 'package:e_commerce_bloc/screens/description_screen/description_screen.dart';
import 'package:e_commerce_bloc/widgets/center_image.dart';
import 'package:e_commerce_bloc/widgets/circular_progress_indicator.dart';
import 'package:e_commerce_bloc/widgets/product_card.dart';
import 'package:flutter/material.dart';
import '../../../navigate.dart';

matchedProductsList(){
  return StreamBuilder(
    stream: scanToSearchBloc.scannedListOut,
    builder: (context, AsyncSnapshot<QuerySnapshot> snap){
      if(snap.data.documents.length == 0){
        if(scanToSearchBloc.text == null){
          bloc.loadingStatusIn.add(true);
          return Center(child:circularProgressIndicator(context));
        }
        else
        return centerImage("Couldn't find relevant products\n[ Predicted: `${scanToSearchBloc.text}` ]", 'search.png');
      }
      else{
        bloc.loadingStatusIn.add(false);
          return Padding(
          padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
          child: GridView.builder(
            itemCount: snap.data.documents.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 180/225
            ),
            itemBuilder: (context, index) => Card(
              elevation: 0,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () => navigate(context, DescriptionScreen(post: snap.data.documents[index])),
                child: productCard(snap.data.documents[index]),
              ) 
            )
          ),
        );
      }
    }
  );
}