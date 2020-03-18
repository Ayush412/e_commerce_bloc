import 'dart:async';

import 'package:e_commerce_bloc/blocs/add_product_bloc/add_product_bloc.dart';

mixin ValidateProductDetails{

  var nameValidator = StreamTransformer<String , String>.fromHandlers(
    handleData: (name, sink){
      if(name=='' || name==null)
        sink.addError("Name can not be blank");
      else
        sink.add(name); 
      addProductBloc.name=name;
    }
  );

  var costValidator = StreamTransformer<String , String>.fromHandlers(
    handleData: (cost, sink){
      if(cost=='' || cost==null || cost=='0')
      sink.addError("Cost can not be 0 or blank");
      else
        sink.add(cost);
      addProductBloc.cost=cost;
    }
  );

  var stockValidator = StreamTransformer<String , String>.fromHandlers(
    handleData: (stock, sink){
      if(stock=='' || stock==null)
        sink.addError("Stock can not be blank");
      else
        sink.add(stock);
      addProductBloc.stock=stock;
    }
  );

  var descValidator = StreamTransformer<String , String>.fromHandlers(
    handleData: (desc, sink){
      if(desc=='' || desc==null)
        sink.addError("Description is required");
      else
        sink.add(desc);
      addProductBloc.desc=desc;
    }
  );
}