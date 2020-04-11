import 'package:e_commerce_bloc/blocs/products_home_bloc/products_home_bloc.dart';
import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';
import 'package:e_commerce_bloc/widgets/appBar.dart';
import 'package:e_commerce_bloc/widgets/custom_drawer.dart';
import 'package:e_commerce_bloc/widgets/products_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FullProductList extends StatefulWidget {
  String category;
  FullProductList({@required this.category});
  @override
  _FullProductListState createState() => _FullProductListState();
}

class _FullProductListState extends State<FullProductList> {

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController controller = TextEditingController();

  @override
  void initState() { 
    super.initState();
    productsHomeBloc.productsListIn.add(null);
    productsHomeBloc.getFullList(widget.category);
  }

  onPop(){
    controller.text='';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        drawer:  customDrawer(context, loginBloc.userMap['Admin']),
        appBar: appBar(context, scaffoldKey, false, controller, onPop, null),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: productsList(),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(widget.category, style: GoogleFonts.sourceSansPro(fontSize: 20, fontWeight: FontWeight.w600),)
                )
              )
            )
          ],
        ),
      ),
    );
  }
}