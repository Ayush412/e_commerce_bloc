import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/screens/scan_to_search/scan_to_search.dart';
import 'package:e_commerce_bloc/screens/search_results/search_results.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

searchBar(BuildContext context, TextEditingController controller,  dynamic onPop, dynamic searchAgain){
  return Container(
    height: 40,
    width: MediaQuery.of(context).size.width/1.5,
    child: Theme(
      data: ThemeData(
        primaryColor: Colors.transparent,
      ),
      child: Stack(
        children: [
          TextField(
            controller: controller,
            style: GoogleFonts.sourceSansPro(),
            textAlignVertical: TextAlignVertical.bottom,
            textInputAction: TextInputAction.search,
            cursorColor: Colors.black,
            onSubmitted: (String text){
              print(text);
              if(searchAgain != null){
                searchAgain();
              }
              else
                if (text.length!=0)
                  navigate(context, SearchResults(text: text, onPop: onPop));
            },
            decoration: InputDecoration(
              filled: true,
              hintText: 'Search Products',
              prefixIcon: Icon(Icons.search, color: Colors.grey,),
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(MdiIcons.cubeScan),
              onPressed: () => navigate(context, ScanToSearch()),
            ),
          )
        ],
      ),
    ),
  );
}