import 'dart:io';
import 'package:e_commerce_bloc/blocs/add_product_bloc/add_product_bloc.dart';
import 'package:e_commerce_bloc/repositories/products_details.dart';
import 'package:flutter/material.dart';

class SelectImage{
  File imageFile;

  selectImage(){
    return Padding(padding: const EdgeInsets.only(top:50, bottom:40),
      child: StreamBuilder<Object>(
        stream: addProductBloc.prodImageOut,
        builder: (context, snapshot) {
          if(snapshot.data!=null)
            imageFile = snapshot.data;
          return Container(
            height: 380, width: 340,
            decoration: BoxDecoration(color: Color(0xffe8f4f8), borderRadius: BorderRadiusDirectional.circular(20)),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: StreamBuilder<Object>(
                      stream: addProductBloc.prodImageOut,
                      builder: (context, snapshot) {
                        imageFile=snapshot.data;
                        return Container(
                          height:270, width:270,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageFile==null? AssetImage('upload.png') : FileImage(imageFile), 
                              fit: BoxFit.cover),
                              borderRadius: imageFile==null ? BorderRadius.circular(20) : null
                          ),
                        );
                      }
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: GestureDetector(
                      onTap: () => getImage(),
                      child: Container(
                        height: 35, width:110,
                        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadiusDirectional.circular(15)),
                        child: StreamBuilder(
                          stream: addProductBloc.prodImageOut,
                          builder: (context, snapshot) {
                            return Center(child: Text(snapshot.data==null? 'Upload Image' : 'Change Image', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900),));
                          }
                        )
                      ),
                    )
                  ),
                )
              ],
            ),
          );
        }
      )
    );
  }

  getImage() async{
    File image = await productDetails.getImage();
    if(image!=null)
      addProductBloc.prodImageIn.add(image);
  }

}

final imagePicker = SelectImage();