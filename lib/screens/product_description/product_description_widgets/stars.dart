import 'package:flutter/material.dart';

stars(double size, double rate, int count, Color color) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: List.generate(count, (val) {
      return Icon(
        val < rate ? Icons.star : Icons.star_border,
        color: color,
        size: size,
      );
    }),
  );
}