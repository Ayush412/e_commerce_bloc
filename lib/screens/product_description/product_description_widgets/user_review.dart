import 'package:e_commerce_bloc/blocs/product_description_bloc/product_description_bloc.dart';
import 'package:flutter/material.dart';

userReview(){
  return StreamBuilder(
    stream: productDescBloc.userReviewOut,
    builder: (context, snap){
      if(snap.data==null)
        return Center(child: CircularProgressIndicator());
      else{
        TextEditingController controller = TextEditingController(text: snap.data);
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(snap.data==''? 'Write a review' : 'Your review - ', style: TextStyle(color: Colors.grey[400], fontSize: 18)),
                StreamBuilder(
                  stream: productDescBloc.editOut,
                  builder: (context, edit){
                    if (edit.data==true)
                      return Container();
                    else
                      return Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: IconButton(
                          icon: Icon(Icons.edit, color: Colors.grey),
                          onPressed: () => setReview(),
                        ),
                      );
                  }
                )
              ]
            ),
            snap.data.length>0? Padding(
              padding: const EdgeInsets.only(top: 10),
              child: StreamBuilder<Object>(
                stream: productDescBloc.editOut,
                builder: (context, edit) {
                  return TextField(
                    controller: controller,
                    enabled: edit.data,
                    autocorrect: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.white),
                    onEditingComplete: () => FocusScope.of(context).requestFocus(new FocusNode()),
                    decoration: InputDecoration(
                      hintText: 'Type Here',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      fillColor: Colors.grey[900],
                      filled: true
                    )
                  );
                }
              ),
            ) : Container(),
            snap.data.length>0? Padding(
              padding: const EdgeInsets.only(top: 5),
              child: FlatButton(
                onPressed: () => null,//deleteReview(),
                child: Text('Delete', style: TextStyle(color: Colors.red, fontSize: 16))
                )
            ) : Container(),
            StreamBuilder<Object>(
              stream: productDescBloc.editOut,
              builder: (context, edit) {
                return Align(
                  alignment: Alignment.bottomRight,
                  child: edit.data? FlatButton(
                    child: Text('Submit', style: TextStyle(color: Colors.blue, fontSize: 16),),
                    onPressed: () => submit(controller.text),
                  ) : Container()
                );
              }
            )
          ]
        );
      }
    }
  );
}

setReview(){
  productDescBloc.editIn.add(true);
}

submit(String review){
  productDescBloc.editIn.add(false);
  
}