import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/product_description_bloc/product_description_bloc.dart';
import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';
import 'package:e_commerce_bloc/screens/product_description/product_description_widgets/rating_dialog.dart';
import 'package:flutter/material.dart';
import 'stars.dart';

description(BuildContext build, DocumentSnapshot data){
  int stock = data.data['Stock'];
  int rate1 = data.data['1 Star'];
  int rate2 = data.data['2 Star'];
  int  rate3 = data.data['3 Star'];
  int  rate4 = data.data['4 Star'];
  int  rate5 = data.data['5 Star'];
  int  totalVotes = rate1 + rate2 + rate3 + rate4 + rate5;
  double totalRate;
    totalVotes == 0
      ? totalRate = 0
      : totalRate = (1 * rate1 + 2 * rate2 + 3 * rate3 + 4 * rate4 + 5 * rate5) / (totalVotes);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
        child: Text(data.data['Description'],
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 18
          )
        )
      ),
      Padding(
        padding: const EdgeInsets.only(
            top: 15, left: 10),
        child: Stack(
          children: <Widget>[
            Text('QR. ${data.data['ProdCost']}',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 34)
            ),
            Padding(
              padding: const EdgeInsets.only(left: 130.0, top: 5),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 90),
                    child: stars(25, totalRate.round().toDouble(),5,Color(0xFFe8b430)),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(
                                left: 65),
                        child: Text(
                            '$totalVotes ratings',
                            style: TextStyle(
                                color: Colors
                                    .white)),
                      ),
                      loginBloc.userMap['Admin'] == 1
                        ? Container()
                        : StreamBuilder(
                          stream: productDescBloc.userRatingOut,
                          builder: (context, rate){
                            if(rate.data==null)
                              return Container();
                            else if(rate.data==0)
                              return rateButton(build, totalRate, totalVotes, data.documentID);
                            else 
                              return showRate(build, rate.data, totalRate, totalVotes, data.documentID);
                          }
                        )
                ],
              ),
            ),
                              
          ],
        )    
      ),
      Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          stock > 0 ? 'In stock'
            : 'Out of stock!',
          style: TextStyle(
            color: stock > 0 ? Colors.green
              : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 18
          )
        ),
      ),
      loginBloc.userMap['Admin'] == 1 ? Padding(
        padding: const EdgeInsets.only(
          left: 15, top: 10
        ),
        child: Row(
          children: <Widget>[
            Text('Stock : $stock',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19
              )
            ),
          ],
        )
      )
        : Container(),
    ]
  );
}                

rateButton(BuildContext context, double totalRate, int totalVotes, String docID) {
  return Padding(
    padding: const EdgeInsets.only(top: 10, left: 65),
    child: GestureDetector(
      onTap: () => giveRatingDialog(context, 0, totalRate, totalVotes, docID),
      child: Container(
        height: 30,
        width: 100,
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Text(
          'Rate this item',
          style: TextStyle(color: Colors.white),
          )
        )
      )
    ),
  );
}

showRate(BuildContext build, double userRate, double totalRate, int totalVotes, String docID) {
  return Padding(
    padding: const EdgeInsets.only(left: 90),
    child: Row(
      children: <Widget>[
        Text('Your rating: ${userRate.toStringAsFixed(0)} /5',
            style: TextStyle(color: Colors.white)),
        IconButton(
          icon: Icon(Icons.edit, color: Colors.grey, size: 22),
          onPressed: () => giveRatingDialog(build, userRate, totalRate, totalVotes, docID)
        )
      ],
    )
  );
}