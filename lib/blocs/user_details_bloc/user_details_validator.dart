import 'dart:async';
import 'package:e_commerce_bloc/blocs/user_details_bloc/user_details_bloc.dart';

mixin ValidateDetails{

  var fnameValidator = StreamTransformer<String , String>.fromHandlers(
    handleData: (fname, sink){
      if(fname=='' || fname==null)
        sink.addError("Name can not left be blank");
      else
        sink.add(fname); 
      userDetailsBloc.fname = fname;
    }
  );

  var lnameValidator = StreamTransformer<String , String>.fromHandlers(
    handleData: (lname, sink){
      if(lname=='' || lname==null)
      sink.addError("Surname can not be left blank");
      else
        sink.add(lname);
      userDetailsBloc.lname = lname;
    }
  );

  var mobValidator = StreamTransformer<String , String>.fromHandlers(
    handleData: (mob, sink){
      if(mob.length == 8)
        sink.add(mob);
      else
        sink.addError('Must be 8 digits');
      userDetailsBloc.mob = mob;
    }
  );

  var addressValidator = StreamTransformer<String , String>.fromHandlers(
    handleData: (address, sink){
      if(address!='' || address!=null)
        sink.add(address);
      else
        sink.addError("Address can not left be blank");
      userDetailsBloc.address = address;
    }
  );
}