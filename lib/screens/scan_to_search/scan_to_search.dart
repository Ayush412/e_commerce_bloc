import 'package:e_commerce_bloc/blocs/products_home_bloc/products_home_bloc.dart';
import 'package:e_commerce_bloc/blocs/scan_to_seaarch_bloc/scan_to_search_bloc.dart';
import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/screens/products_home/products_home.dart';
import 'package:e_commerce_bloc/screens/products_home/products_home_widgets/products_list.dart';
import 'package:e_commerce_bloc/screens/scan_to_search/scan_to_search_widgets/matched_product_list.dart';
import 'package:e_commerce_bloc/widgets/app_bar.dart';
import 'package:e_commerce_bloc/widgets/show_dialog.dart';
import 'package:flutter/material.dart';
import 'scan_to_search_widgets/center_image.dart';

class ScanToSearch extends StatefulWidget {
  @override
  _ScanToSearchState createState() => _ScanToSearchState();
}

class _ScanToSearchState extends State<ScanToSearch> {

  List<Widget> actions = List<Widget>();
  dynamic leading;
  

  @override
  void initState() {
    scanToSearchBloc.lablesIn.add(null);
    super.initState();
    actions = [
      IconButton(
        icon: Icon(Icons.info), 
        color: Colors.white,
        onPressed: () => showDialogBox(
          context, 
          'How it works', 'Click the camera icon below to take a picture of an object. Based on the best predictions made by the algorithm, you can find relevant products that match the category of the scanned object.', 
          1)
      )
    ];
    leading = IconButton(icon: Icon(Icons.arrow_back, color: Colors.white),onPressed: () => navigate(context, ProductsHome()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => navigate(context, ProductsHome()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            extendBody: true,
            backgroundColor: Colors.white,
            appBar: appBar('Scan to search', leading, actions),
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
                        color: Colors.orange,
                        child: Container(height: 40,),
                      )
                    ),
            floatingActionButton: FloatingActionButton(
              elevation: 0,
              onPressed: () => scanToSearchBloc.getImage(),
              child: Icon(Icons.camera_alt, color: Colors.black),
              backgroundColor: Colors.orange,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          )
        )
    );
  }
}