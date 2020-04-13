import 'package:e_commerce_bloc/blocs/product_description_bloc/product_description_bloc.dart';
import 'package:flutter/material.dart';

reviews(ScrollController controller){
  return Padding(
    padding: const EdgeInsets.only(top: 15, left: 10, right:10, bottom: 15),
    child: StreamBuilder(
      stream: productDescBloc.reviewOut,
      builder: (context, snap) {
        if(snap.data==null){
          return Center(child: Text('No reviews', style: TextStyle(color: Colors.white)));
        }
        else{
          return StreamBuilder<Object>(
            stream: productDescBloc.heightOut,
            builder: (context, snapshot) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: snapshot.data,
                child: MediaQuery.removePadding(
                  context: context, 
                  removeTop: true,
                  child: Scrollbar(
                        child: ListView.builder(
                          shrinkWrap: true,
                          controller: controller,
                          itemCount: snap.data.length,
                          itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 5, right: 5),
                                child: Stack(
                                  children: <Widget>[
                                    Icon(Icons.account_circle, color: Colors.white,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 35),
                                      child: Text(snap.data[index].data['Name'], style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500))
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top:35, left: 5),
                                      child: stars(snap.data[index].data['Rate'].toDouble()),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 60),
                                      child: Text(snap.data[index].data['Text'], style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w300, wordSpacing: 2, height: 1.3))
                                    ),
                                    Positioned(right: 5, top: 5,
                                    child: Text(snap.data[index].data['Date'], style: TextStyle(color: Colors.grey),),
                                    )
                                  ],
                                ),
                              ), 
                              Divider(
                                height: 0.2,
                                color: Colors.grey,
                              ),
                            ],
                          );
                        },
                        ),
                      ),
                ),
              );
            }
          );
        }
      }
    )
  );
}

stars(double rate) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: List.generate(5, (val) {
      return Icon(
        val < rate ? Icons.star : Icons.star_border,
        color: Color(0xFFe8b430),
        size: 12,
      );
    }),
  );
}

