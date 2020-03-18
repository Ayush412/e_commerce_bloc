import 'package:flutter/material.dart';

textFieldWithController(TextEditingController controller, Stream stream, Function onChanged, String labelText, Icon icon, TextInputType keyboard){
  return StreamBuilder(
    stream: stream,
    builder: (context, snapshot) => Theme(
      data: ThemeData(primaryColor: Colors.black),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        onChanged: onChanged,
        decoration: InputDecoration(
          errorText: snapshot.error,
          labelText: labelText,
          prefixIcon: icon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      )
    )
  );
}