import 'package:e_commerce_bloc/blocs/add_product_bloc/add_product_bloc.dart';
import 'package:e_commerce_bloc/navigate.dart';
import 'package:e_commerce_bloc/repositories/scan_to_search_repo.dart';
import 'package:e_commerce_bloc/screens/add_product/add_product_widgets/category_dropdown_menu.dart';
import 'package:e_commerce_bloc/screens/add_product/add_product_widgets/description_field.dart';
import 'package:e_commerce_bloc/screens/add_product/add_product_widgets/labels_field.dart';
import 'package:e_commerce_bloc/screens/products_home/products_home.dart';
import 'package:e_commerce_bloc/widgets/app_bar.dart';
import 'package:e_commerce_bloc/widgets/show_dialog.dart';
import 'package:e_commerce_bloc/widgets/show_snack.dart';
import 'package:e_commerce_bloc/widgets/textfield_with_controller.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'add_product_widgets/image_picker.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProgressDialog pr;
  dynamic leading;
  List<Widget> actions = List<Widget>();
  TextEditingController nameController = TextEditingController();
  TextEditingController costController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() { 
    super.initState();
    leading = IconButton(icon: Icon(Icons.arrow_back), onPressed: (){addProductBloc.clearAll(); navigate(context, ProductsHome());});
    actions = [IconButton(icon: Icon(MdiIcons.qrcodeScan, color: Colors.white,), onPressed: () => scanQRCode())];
  }

  scanQRCode() async{
    List<String> list = List<String>();
    String text = await scanToSearchRepo.scanCode();
    list.add(text.splitMapJoin(
      RegExp(r'$', multiLine: true),
      onMatch: (_) => '\n',
      onNonMatch: (n){list.add(n.trim());},
    ));

    addProductBloc.name = nameController.text = list[0];

    addProductBloc.cost = costController.text = list[1];

    addProductBloc.stock = stockController.text = list[2];

    addProductBloc.desc = descController.text = list[3];

  }

  addData()async{
    Navigator.pop(context, true);
    pr.show();
    await addProductBloc.addProductData();
    pr.hide();
    return _scaffoldKey.currentState.showSnackBar(ShowSnack('Product added!', Colors.white, Colors.green));
  }

  check(){
    if(addProductBloc.check() == true)
      return showDialogBox(context, 'Confirm', 'Add data?', () => addData());
    else
      return _scaffoldKey.currentState.showSnackBar(ShowSnack('Check all fields', Colors.black, Colors.orange));
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(
          message: 'Adding product...',
          borderRadius: 10.0,
          backgroundColor: Colors.white,
          progressWidget: CircularProgressIndicator(),
          elevation: 10.0,
          insetAnimCurve: Curves.easeInOut,
          progressTextStyle: TextStyle(
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
        ); 
    return WillPopScope(
        onWillPop: (){addProductBloc.clearAll(); navigate(context, ProductsHome());},
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            key: _scaffoldKey,
            appBar: appBar('Add Product', leading, actions),
            body: SingleChildScrollView(
              child: Center(
                child: Stack(
                    children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top:45),
                          child: Container(
                            width: 300,
                            child: textFieldWithController(
                              nameController,
                              addProductBloc.prodNameCheck, 
                              addProductBloc.prodNameChanged, 
                              'Product Name', 
                              Icon(Icons.loyalty), 
                              TextInputType.text,
                            )
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:50),
                          child: Container(
                            width: 300,
                            child: textFieldWithController(
                              costController,
                              addProductBloc.prodCostCheck, 
                              addProductBloc.prodCostChanged,
                              'Cost', 
                              Icon(Icons.local_offer), 
                              TextInputType.number, 
                            )
                          ),
                        ),
                        categoryMenu.dropDownMenuCat(),
                        categoryMenu.dropDownMenuSub(),
                        Padding(
                          padding: const EdgeInsets.only(top:50),
                          child: Container(
                            width: 300,
                            child: textFieldWithController(
                              stockController,
                              addProductBloc.prodStockCheck, 
                              addProductBloc.prodStockChanged,
                              'Stock', 
                              Icon(Icons.exposure_plus_1), 
                              TextInputType.number,
                            )
                          ),
                        ),
                        descriptionField(descController),
                        imagePicker.selectImage(),
                        Padding(
                          padding: const EdgeInsets.only(top:15),
                          child: StreamBuilder(
                            stream: addProductBloc.listOut,
                            builder: (context, snapshot) {
                              return Text('Image Labels*: ${snapshot.data}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600));
                            }
                          )
                        ),
                        Padding(padding: const EdgeInsets.only(top:10),
                            child: Container(
                              height:75,
                              width: 300,
                              padding: EdgeInsets.all(10.0),
                              child: labelsField()
                            ),
                        ),
                        Text('*Required for scan to search prediction fields'),
                        Padding(padding: const EdgeInsets.only(top: 35, bottom: 45),
                          child: GestureDetector(
                            onTap: () => check(),
                            child: Container(
                              height: 60, width: 160,
                              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadiusDirectional.circular(15)),
                              child: Center(
                                child: Text('Add Product', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),),
                              ),
                            ),
                          )
                        )
                      ],
                    ),
                  ],
                ),
              )
            ),
          ),
        ),
    );
  }
}