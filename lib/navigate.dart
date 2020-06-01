import 'package:flutter/material.dart';

navigate(BuildContext context, dynamic className){
  //print('${className.toString()}');
  Navigator.push(context, MaterialPageRoute(builder: (context) => className));
}