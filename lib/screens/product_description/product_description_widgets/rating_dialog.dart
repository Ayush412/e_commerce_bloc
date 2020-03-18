import 'package:e_commerce_bloc/blocs/product_description_bloc/product_description_bloc.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

giveRatingDialog(BuildContext context, double oldRate, double totalRate, int totalVotes, String docID){
  double newUserRate=0;
  bool enter = true;
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (c) => StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: Row(children: <Widget>[
          Text('Select rating'),
          Padding(
            padding: const EdgeInsets.only(left: 122),
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: (){enter = false; Navigator.pop(c, false);},
            ),
          )
        ]),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: Container(
          height: 40,
          width: 250,
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SmoothStarRating(
                    allowHalfRating: false,
                    onRatingChanged: (val) {
                      setState(() {
                        newUserRate = val;
                      });
                    },
                    starCount: 5,
                    rating: newUserRate,
                    size: 35,
                    color: Color(0xFFe8b430),
                    borderColor: Color(0xFFe8b430),
                    spacing: 1,
                  )
                ],
              ),
            ],
          )
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: (){
              Navigator.pop(c, false);
              if (enter) 
              oldRate!=0 ? productDescBloc.updateUserRating(oldRate.toInt(), newUserRate.toInt(), totalRate, totalVotes, docID)
              : productDescBloc.setUserRating(newUserRate.toInt(), totalRate, totalVotes, docID);
            }
          )
        ],
      );
    })
  );
}