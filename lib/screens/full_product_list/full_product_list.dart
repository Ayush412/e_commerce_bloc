import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';
import 'package:e_commerce_bloc/widgets/appBar.dart';
import 'package:e_commerce_bloc/widgets/custom_drawer.dart';
import 'package:e_commerce_bloc/widgets/products_list.dart';
import 'package:flutter/material.dart';

class FullProductList extends StatefulWidget {
  dynamic stream;
  FullProductList({this.stream});
  @override
  _FullProductListState createState() => _FullProductListState();
}

class _FullProductListState extends State<FullProductList> {

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController controller = TextEditingController();
  dynamic leading;
  List<Widget> actions = List<Widget>();

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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
            ),
            productsList()
          ],
        ),
      ),
    );
  }
}