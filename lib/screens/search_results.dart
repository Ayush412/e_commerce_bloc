import 'package:e_commerce_bloc/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class SearchResults extends StatefulWidget {
  String text;
  SearchResults({this.text});
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {

  TextEditingController controller = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    controller.text=widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: searchBar(context, controller, true)
        ),
        body: Center(child: Text(widget.text),),
      ),
    );
  }
}