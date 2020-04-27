import 'package:e_commerce_bloc/blocs/analytics_bloc/analytics_bloc.dart';
import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/screens/analytics/analytics_widgets/user_count.dart';
import 'package:e_commerce_bloc/screens/homescreen/homescreen.dart';
import 'package:e_commerce_bloc/widgets/appBarBackArrow.dart';
import 'package:e_commerce_bloc/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'analytics_widgets/piechart_widget.dart';

class AnalyticsScreen extends StatefulWidget  {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>  with SingleTickerProviderStateMixin {

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double opacity;

  @override
  void initState() { 
    super.initState();
    opacity=0;
    analyticsBloc.hasAnalyticsIn.add(false);
    getPieData();
  }

  getPieData() async{
    bloc.loadingStatusIn.add(true);
    await analyticsBloc.getPieData();
    bloc.loadingStatusIn.add(false);
    analyticsBloc.hasAnalyticsIn.add(true);
    setState(() {
      opacity=1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        extendBody: true,
        appBar: appBarBackArrow(context, 'Analytics', HomeScreen(), getPieData),
        body: Stack(
          children: [
          StreamBuilder<Object>(
            stream: analyticsBloc.hasAnalyticsOut,
            builder: (context, data) {
              if(data.data==false){
                return Center(child: circularProgressIndicator(context));
              }
              else{
                return   SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: userCount(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
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
                );
              }
            }
          ),
            Opacity(
              opacity: opacity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: circularProgressIndicator(context)
                ),
              ),
            )
          ],
        )
      )
    );
  }
}