import 'package:flutter/material.dart';

textField(Stream stream, Function onChanged, String hintText, String labelText, Icon icon, TextInputType keyboard, bool obscure) {
  return StreamBuilder(
    stream: stream,
    builder: (context, snapshot) => Theme(
      data: ThemeData(primaryColor: Colors.black),
      child: TextField(
        keyboardType: keyboard,
        onChanged: onChanged,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hintText,
          errorText: snapshot.error,
          labelText: labelText,
          prefixIcon: icon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
    )
  );
}