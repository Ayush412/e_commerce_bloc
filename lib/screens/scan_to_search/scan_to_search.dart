import 'package:e_commerce_bloc/screens/scan_barcode/scan_barcode.dart';
import 'package:e_commerce_bloc/screens/scan_object/scan_object.dart';
import 'package:e_commerce_bloc/screens/scan_to_search/scan_to_search_widgets/option_card.dart';
import 'package:e_commerce_bloc/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class ScanToSearch extends StatefulWidget {
  @override
  _ScanToSearchState createState() => _ScanToSearchState();
}

class _ScanToSearchState extends State<ScanToSearch> {

  dynamic leading;

  @override
  void initState() {
    super.initState();
    leading = IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: appBar('Scan To Search', leading, null),
        backgroundColor: Colors.white,
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