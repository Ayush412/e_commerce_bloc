import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'stars.dart';

ratings(DocumentSnapshot data){
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
        padding: const EdgeInsets.only(
          top: 10, left: 10),
          child: Column(
            children: <Widget>[
              Text(
                totalVotes == 0 ? 'None'
                  : totalRate.toStringAsFixed(1),
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 34)
              ),
              Text(
                totalVotes == 0 ? ''
                  : 'out of 5',
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 16)
              ),
            ],
          )
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 5),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: stars(15, 5, 5, Colors.white),
                  ),
                  progress(rate5, totalVotes)
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: stars(15, 4, 4, Colors.white),
                  ),
                  progress(rate4, totalVotes)
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 45),
                    child: stars(15, 3, 3, Colors.white),
                  ),
                  progress(rate3, totalVotes)
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 60),
                    child: stars(15, 2, 2, Colors.white),
                  ),
                  progress(rate2, totalVotes)
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 75),
                    child: stars(15, 1, 1, Colors.white),
                  ),
                  progress(rate1, totalVotes)
                ],
              ),
            ],
          )),
    ],
  );
}

progress(int rate, int totalVotes) {
  double per = totalVotes == 0 ? 0 : (rate * 100) / totalVotes;
  return Padding(
    padding: EdgeInsets.only(top: 10, left: 15),
    child: Row(
      children: <Widget>[
        LinearPercentIndicator(
          width: 220,
          percent: totalVotes == 0 ? 0 : (rate / totalVotes),
          backgroundColor: Colors.grey,
          progressColor: Colors.grey[50],
        ),
        Text(
          '${per.toStringAsFixed(0)}%',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        )
      ],
    ),
  );
}