import 'package:e_commerce_bloc/blocs/scan_to_seaarch_bloc/scan_to_search_bloc.dart';
import 'package:e_commerce_bloc/widgets/appBarBackArrow.dart';
import 'package:e_commerce_bloc/widgets/center_image.dart';
import 'package:e_commerce_bloc/widgets/show_dialog.dart';
import 'package:flutter/material.dart';
import 'scan_object_widgets/matched_product_list.dart';

class ScanObject extends StatefulWidget {
  @override
  _ScanObjectState createState() => _ScanObjectState();
}

class _ScanObjectState extends State<ScanObject> {

  @override
  void initState() {
    scanToSearchBloc.lablesIn.add(null);
    super.initState();
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
            appBar: appBarBackArrow(context, 'Object Scan', false),
            body: Stack(
              children: <Widget>[
                StreamBuilder(
                  stream: scanToSearchBloc.labelsOut,
                  builder: (context, data){
                    if(data.data == null){
                      return Padding(
                        padding: const EdgeInsets.only(top:10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                          child: centerImage('Scan an object to begin search', 'scan.png')
                        )
                      );
                    }
                    else {
                      return Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top:10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                              child: Container(
                                child: matchedProductsList()
                              )
                            ),
                          ),
                        ],
                      );
                    }
                  }
                )
              ],
            ),
            bottomNavigationBar: ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      child: BottomAppBar(
                        shape: CircularNotchedRectangle(),
                        color: Colors.black,
                        child: Container(height: 40,),
                      )
                    ),
            floatingActionButton: FloatingActionButton(
              elevation: 0,
              onPressed: () => scanToSearchBloc.getImage(),
              child: Icon(Icons.camera_alt, color: Colors.white),
              backgroundColor: Colors.black,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          )
        )
    );
  }
}