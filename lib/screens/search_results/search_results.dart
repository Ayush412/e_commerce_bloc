import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/blocs/products_home_bloc/products_home_bloc.dart';
import 'package:e_commerce_bloc/widgets/center_image.dart';
import 'package:e_commerce_bloc/widgets/circular_progress_indicator.dart';
import 'package:e_commerce_bloc/widgets/product_card.dart';
import 'package:e_commerce_bloc/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class SearchResults extends StatefulWidget {
  String text;
  final VoidCallback onPop;
  SearchResults({this.text, this.onPop});
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
              widget.onPop();
            },
          ),
          title: searchBar(context, controller, true, getSearchResults)
        ),
        body: StreamBuilder(
          stream: productsHomeBloc.productsListOut,
          builder: (context, AsyncSnapshot<QuerySnapshot> snap){
            if(snap.data==null){
              bloc.loadingStatusIn.add(true);
              return Center(child:circularProgressIndicator(context));
            }
            else if(snap.data.documents.length==0){
              bloc.loadingStatusIn.add(false);
              return Center(child: centerImage("No products found.", 'search.png'));
            }
            else{
              bloc.loadingStatusIn.add(false);
              return Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: GridView.builder(
                  itemCount: snap.data.documents.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 180/225
                  ),
                  itemBuilder: (context, index) => Card(
                    elevation: 0,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child:productCard(snap.data.documents[index])
                  )
                ),
              );
            }
          }
        )
      ),
    );
  }
}