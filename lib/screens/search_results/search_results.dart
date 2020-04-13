import 'package:e_commerce_bloc/blocs/products_home_bloc/products_home_bloc.dart';
import 'package:e_commerce_bloc/widgets/appBar.dart';
import 'package:e_commerce_bloc/widgets/products_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchResults extends StatefulWidget {
  String text;
  final VoidCallback onPop;
  SearchResults({this.text, this.onPop});
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController controller = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    controller.text=widget.text;
    productsHomeBloc.productsListIn.add(null);
    productsHomeBloc.getSearchResults(widget.text);
  }

  getSearchResults(){
    productsHomeBloc.productsListIn.add(null);
    productsHomeBloc.getSearchResults(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        widget.onPop();
        Navigator.of(context).pop();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          key: scaffoldKey,
          backgroundColor: Colors.white,
          appBar: appBar(context, scaffoldKey, false, controller, widget.onPop, getSearchResults, null),
          body: Stack(children: [
            productsList(),
          ],)
        ),
      ),
    );
  }
}