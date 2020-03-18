import 'package:e_commerce_bloc/blocs/analytics_bloc/analytics_bloc.dart';
import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/screens/analytics/piechart_widget.dart';
import 'package:e_commerce_bloc/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProgressDialog pr;

  @override
  void initState() { 
    super.initState();
    getPieData();
  }

  getPieData() async{
    bloc.containerHeightIn.add(60);
    bloc.loadingStatusIn.add(true);
    await analyticsBloc.getPieData();
    bloc.loadingStatusIn.add(false);
    bloc.containerHeightIn.add(0);
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(
      message: 'Loading...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        extendBody: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Product Analytics', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
            color: Colors.grey,
          ),
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius:
              BorderRadius.vertical(bottom: Radius.circular(25))
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              color: Colors.grey,
              onPressed: () => getPieData(),
            )
          ],
        ),
        body: Column(
          children: <Widget>[
             StreamBuilder(
                stream: bloc.containerHeightOut,
                builder: (context, height) => 
                AnimatedContainer(
                  height: height.data,
                  duration: Duration(milliseconds: 150),
                  child: Padding(
                    padding: const EdgeInsets.only(top:10),
                    child: Center(
                      child:circularProgressIndicator(context)
                    ),
                  ),
                )
              ),
            Expanded(
                          child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)))
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                              child: Text('Total View Count', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)
                            )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:40),
                          child: Align(child: Text('Category', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),)),
                        ),
                        pieChart(analyticsBloc.categoryOut),
                        Divider(
                          height: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 80),
                          child: Align(child: Text('Fashion', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),)),
                        ),
                        pieChart(analyticsBloc.fashionOut),
                        Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Align(child: Text('Electronics', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),)),
                        ),
                        pieChart(analyticsBloc.electronicsOut),
                        SizedBox(height: 50)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}