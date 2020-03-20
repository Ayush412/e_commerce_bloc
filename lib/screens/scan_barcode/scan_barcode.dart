import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/scan_to_seaarch_bloc/scan_to_search_bloc.dart';
import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/repositories/scan_to_search_repo.dart';
import 'package:e_commerce_bloc/screens/product_description/product_description.dart';
import 'package:e_commerce_bloc/widgets/app_bar.dart';
import 'package:e_commerce_bloc/widgets/center_image.dart';
import 'package:flutter/material.dart';

class ScanQRCode extends StatefulWidget {
  @override
  _ScanQRCodeState createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> {
  dynamic leading;

  @override
  void initState() { 
    super.initState();
    leading = IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop());
    scanToSearchBloc.qrCodeIn.add(null);
  }

  scanning() async{
     String qrCode = await scanToSearchRepo.scanCode();
     if(qrCode == null)
      scanToSearchBloc.qrCodeIn.add(null);
    else{
      scanToSearchBloc.qrCodeIn.add('Scanning');
      DocumentSnapshot ds = await scanToSearchRepo.getQRCodeData(qrCode);
      if(ds.data == null)
        scanToSearchBloc.qrCodeIn.add('Not found');
      else
        navigate(context, ProductDescription(post: ds, tag: ds.documentID));
    }
    scanToSearchBloc.qrCodeIn.add(null);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: (){Navigator.of(context).pop();},
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            extendBody: true,
            backgroundColor: Colors.white,
            appBar: appBar('Scan Object', leading, null),
            body: Stack(
              children: <Widget>[
                Container(color: Colors.white),
                Padding(
                  padding: const EdgeInsets.only(top:10),
                  child: Container( decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),)
                ),
                Padding(
                  padding: const EdgeInsets.only(top:51),
                  child: Container(
                   decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
                  )
                ),
                StreamBuilder(
                  stream: scanToSearchBloc.qrCodeOut,
                  builder: (context, scan){
                    if(scan.data == null){
                      return Padding(
                        padding: const EdgeInsets.only(top:10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                          child: centerImage('Scan a QR code to begin search', 'scan.png')
                        )
                      );
                    }
                    else if(scan.data == 'Scanning')
                      return Center(child: CircularProgressIndicator());
                    else if(scan.data == 'Not found')
                      return centerImage("Couldn't find relevant products", 'search.png');
                  }
                )
              ],
            ),
            bottomNavigationBar: ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      child: BottomAppBar(
                        shape: CircularNotchedRectangle(),
                        color: Colors.orange,
                        child: Container(height: 40,),
                      )
                    ),
            floatingActionButton: FloatingActionButton(
              elevation: 0,
              onPressed: () => scanning(),
              child: Icon(Icons.camera_alt, color: Colors.black),
              backgroundColor: Colors.orange,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          )
        )
    );
  }
}