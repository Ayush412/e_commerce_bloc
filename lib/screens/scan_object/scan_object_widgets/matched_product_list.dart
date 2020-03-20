import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/blocs/scan_to_seaarch_bloc/scan_to_search_bloc.dart';
import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/screens/product_description/product_description.dart';
import 'package:e_commerce_bloc/widgets/center_image.dart';
import 'package:e_commerce_bloc/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';

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
                        onTap: () => navigate(context, ProductDescription(post: product, tag: product.documentID)),
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