import 'package:flutter/material.dart';

navigate(BuildContext context, dynamic className){
  Navigator.push(context, MaterialPageRoute(builder: (context) => className));
}