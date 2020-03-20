import 'package:e_commerce_bloc/blocs/add_product_bloc/add_product_bloc.dart';
import 'package:flutter/material.dart';

descriptionField(TextEditingController controller){
  return StreamBuilder(
    stream: addProductBloc.prodDescCheck,
    builder: (context, snapshot) {
      return Container(
          margin: EdgeInsets.all(40.0),
          padding: EdgeInsets.only(top: 10.0),
          child: Theme(
            data: ThemeData(primaryColor: Colors.black),
            child: Stack(
              children: <Widget>[
                TextField(
                  controller: controller,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  onChanged: addProductBloc.prodDescChanged,
                  decoration: new InputDecoration(
                  hintText: 'Product Description',
                  errorText: snapshot.error,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),
                  )
                  )
                ),
                (snapshot.data=='' || snapshot.data==null) ? Container() : Positioned(
                  right: 5, top: 3,
                  child: IconButton(
                    onPressed: () => FocusScope.of(context).requestFocus(FocusNode()),
                    icon: Icon(Icons.check, size:28),
                  ),
                )
              ],
            ),
          ),
        );
    }
  );
}