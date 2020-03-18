import 'dart:io';
import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/repositories/products_details.dart';
import 'package:rxdart/subjects.dart';
import 'add_product_validator.dart';

class AddProductBloc with ValidateProductDetails implements BaseBloc{
  
  String name;
  String cost;
  String stock;
  String desc;
  String category;
  String subcategory;
  String imgurl;
  File image;
  List<String> labels = List<String>();

  AddProductBloc(){
    _prodNameController.stream.listen((val) {name=val;});
    _prodCostController.stream.listen((val) {cost=val;});
    _prodStockController.stream.listen((val) {stock=val;});
    _prodDescController.stream.listen((val) {desc=val; print(desc);});
    _prodCategoryController.stream.listen((val) {category=val;});
    _prodSubcategoryController.stream.listen((val) {subcategory=val;});
    _prodImageController.stream.listen((val) {image = val;});
    _prodLabelController.stream.listen((val) {labels.add(val); listIn.add(labels);});
  }

  //CONTROLLERS
  BehaviorSubject<String> _prodNameController = BehaviorSubject();
  BehaviorSubject<String> _prodCostController = BehaviorSubject();
  BehaviorSubject<String> _prodStockController = BehaviorSubject();
  BehaviorSubject<String> _prodDescController = BehaviorSubject();
  BehaviorSubject<String> _prodCategoryController = BehaviorSubject();
  BehaviorSubject<String> _prodSubcategoryController = BehaviorSubject();
  BehaviorSubject<String> _prodLabelController = BehaviorSubject();
  BehaviorSubject<File> _prodImageController = BehaviorSubject();
  BehaviorSubject<List> _listController = BehaviorSubject();

  //SINKS
  Function(String) get prodNameChanged => _prodNameController.sink.add;
  Function(String) get prodCostChanged => _prodCostController.sink.add;
  Function(String) get prodStockChanged => _prodStockController.sink.add;
  Function(String) get prodDescChanged => _prodDescController.sink.add;
  Sink<String> get prodCategoryIn => _prodCategoryController.sink;
  Sink<String> get prodSubcategoryIn => _prodSubcategoryController.sink;
  Sink<String> get prodLabelIn => _prodLabelController.sink;
  Sink<File> get prodImageIn => _prodImageController.sink;
  Sink<List> get listIn => _listController.sink;

  //STREAMS
  Stream<String> get prodNameCheck => _prodNameController.stream.transform(nameValidator);
  Stream<String> get prodCostCheck => _prodCostController.stream.transform(costValidator);
  Stream<String> get prodStockCheck => _prodStockController.stream.transform(stockValidator);
  Stream<String> get prodDescCheck => _prodDescController.stream.transform(descValidator);
  Stream<String> get prodCategoryOut => _prodCategoryController.stream;
  Stream<String> get prodSubcategoryOut => _prodSubcategoryController.stream;
  Stream<String> get prodLabelOut => _prodLabelController.stream;
  Stream<File> get prodImageOut => _prodImageController.stream;
  Stream<List> get listOut => _listController.stream;

  addProductData() async{
    imgurl = await productDetails.putImage(name, image);
    Map map = {
      "ProdName":name, 
      "ProdCost": cost, 
      "Stock": stock,
      "Category": category, 
      "SubCategory": subcategory, 
      "Description": desc, 
      "scan": labels,
      'imgurl': imgurl
    };
    productDetails.addProduct(map);
    clearAll();
  }

  check(){
    if(name==null || name=='' || cost==null || cost=='' || stock==null || stock=='' || desc==null || desc=='' ||category==null || category=='' || subcategory==null || subcategory=='' || image==null || labels==[])
      return false;
    else
      return true;
  }

  clearAll(){
    name = null;
    cost = null;
    stock = null;
    desc = '';
    category = null;
    subcategory = null;
    imgurl = null;
    image = null;
    labels = null;
  }

  @override
  void dispose() {
    _prodNameController.close();
    _prodCostController.close();
    _prodStockController.close();
    _prodDescController.close();
    _prodCategoryController.close();
    _prodSubcategoryController.close();
    _prodLabelController.close();
    _prodImageController.close();
    _listController.close();
  }
}

final addProductBloc = AddProductBloc();