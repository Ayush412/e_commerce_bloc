import 'package:e_commerce_bloc/screens/scan_barcode/scan_barcode.dart';
import 'package:e_commerce_bloc/screens/scan_object/scan_object.dart';
import 'package:e_commerce_bloc/screens/scan_to_search/scan_to_search_widgets/option_card.dart';
import 'package:e_commerce_bloc/widgets/custom_drawer.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../analytics.dart';

class ScanToSearch extends StatefulWidget {
  @override
  _ScanToSearchState createState() => _ScanToSearchState();
}

class _ScanToSearchState extends State<ScanToSearch> {

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analyticsService.analytics)],
      home: Scaffold(
        key: scaffoldKey,
        drawer: customDrawer(context),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1.5,
          centerTitle: true,
          title: Text('Scan To Search', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, color: Colors.black)),
          leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.dehaze),
            onPressed: () => scaffoldKey.currentState.openDrawer(),
          ),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              optionCard(context, 'Scan an Object', ScanObject(), 'object.png'),
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: optionCard(context, 'Scan a QR Code', ScanQRCode(), 'barcode.png')
              )
            ],
          ),
        ),
      ),
    );
  }
}