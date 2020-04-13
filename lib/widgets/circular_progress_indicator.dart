import 'package:flutter/material.dart';
import 'package:e_commerce_bloc/blocs/bloc.dart';

circularProgressIndicator(BuildContext context){
  return StreamBuilder(
    stream: bloc.loadingStatusOut,
    builder: (context, snapshot){
      if(snapshot.hasData && snapshot.data==true)
        return Container(
          height: 25, width: 25,
          child: CircularProgressIndicator()
        );
      else if(!snapshot.hasData || snapshot.data==false)
        return SizedBox(height: 30, width: 30);
    },
  );
}