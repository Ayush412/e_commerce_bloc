import 'package:e_commerce_bloc/blocs/user_cart_bloc/user_cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

codeTextField(BuildContext context, TextEditingController controller){
  return Container(
    height: 30,
    width: MediaQuery.of(context).size.width/2.2,
    child: Theme(
      data: ThemeData(primaryColor: Colors.grey[400]),
      child: Stack(
        children: [
          TextField( 
            controller: controller,
            textAlignVertical: TextAlignVertical.center,
            cursorColor: Colors.black,
            style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.w600, color: Colors.grey),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder()
            )
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.close, size: 18),
              onPressed: (){
                controller.text='';
                userCartBloc.resetCode();
              }
            ),
          )
        ],
      ),
    )
  );
}