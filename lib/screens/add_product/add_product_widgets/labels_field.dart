import 'package:e_commerce_bloc/blocs/add_product_bloc/add_product_bloc.dart';
import 'package:flutter/material.dart';

TextEditingController controller = TextEditingController();

labelsField(){
  return Stack(
    children: <Widget>[
      Theme(
        data: ThemeData(primaryColor: Colors.black),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Image Labels',
            prefixIcon: Icon(Icons.image),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
        ),
      ),
      Positioned(
        right:5, top:3,
        child: IconButton(
          icon: Icon(Icons.add_circle_outline, size: 28,),
          onPressed: (){
            if(controller.text!='' || controller.text!=null)
              addProductBloc.prodLabelIn.add(controller.text);
          }
        )
      )
    ],
  );
}