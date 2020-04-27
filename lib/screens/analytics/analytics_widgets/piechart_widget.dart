import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

pieChart(Stream stream){
  return StreamBuilder(
    stream: stream,
    builder: (context, snap) => Container(
      height: 200, 
      child: charts.PieChart(
        snap.data,
        animate: true,
        animationDuration: Duration(milliseconds: 600),
        defaultRenderer: charts.ArcRendererConfig(
          arcRendererDecorators: [
            charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.outside,
            )
          ]
        )
      ),
    )
  );
}