import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/repositories/products_details.dart';
import 'package:rxdart/subjects.dart';

class ProductsHomeBloc extends BaseBloc{

  String category;
  String subcategory;

  ProductsHomeBloc() {
    _sortController.stream.listen((data) => filteredProductsList(data));
  }

  //CONTROLLERS
  BehaviorSubject<QuerySnapshot> _productsListController = BehaviorSubject();
  BehaviorSubject<QuerySnapshot> _productsCarouselController = BehaviorSubject();
  BehaviorSubject<List> _sortController = BehaviorSubject();
  BehaviorSubject<int> _notificationCountController = BehaviorSubject();
  BehaviorSubject<int> _cartCountController = BehaviorSubject();
  

  //SINKS
  Sink<QuerySnapshot> get productsListIn => _productsListController.sink;
  Sink<QuerySnapshot> get productsCarouselIn => _productsCarouselController.sink;
  Sink<List> get sortIn => _sortController.sink;
  Sink<int> get notificationIn => _notificationCountController.sink;
  Sink<int> get cartIn => _cartCountController.sink;

  //STREAMS
  Stream<QuerySnapshot> get productsListOut => _productsListController.stream;
  Stream<QuerySnapshot> get productsCarouselOut => _productsCarouselController.stream;
  Stream<int> get notificationOut => _notificationCountController.stream;
  Stream<int> get cartOut => _cartCountController.stream;

  getProductsList() async{
    QuerySnapshot qs = await productDetails.getProductsList();
    productsListIn.add(qs);
  }

  getProductsCarousel() async{
    QuerySnapshot qs = await productDetails.getProductsCarousel();
    productsCarouselIn.add(qs);
  }

  filteredProductsList(List data) async{
    QuerySnapshot qs = await productDetails.getProductListFiltered(data[0], data[1], data[2]);
    productsListIn.add(qs);
  }

  @override
  void dispose() {
    _productsCarouselController.close();
    _productsListController.close();
    _sortController.close();
    _notificationCountController.close();
    _cartCountController.close();
  }

}

final productsHomeBloc = ProductsHomeBloc();