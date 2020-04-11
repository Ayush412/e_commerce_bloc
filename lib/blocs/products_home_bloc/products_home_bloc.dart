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
  BehaviorSubject<QuerySnapshot> _discountController = BehaviorSubject();
  BehaviorSubject<QuerySnapshot> _bannerController = BehaviorSubject();
  BehaviorSubject<List> _sortController = BehaviorSubject();
  BehaviorSubject<int> _notificationCountController = BehaviorSubject();
  BehaviorSubject<int> _cartCountController = BehaviorSubject();
  
  //SINKS
  Sink<QuerySnapshot> get productsListIn => _productsListController.sink;
  Sink<QuerySnapshot> get productsCarouselIn => _productsCarouselController.sink;
  Sink<QuerySnapshot> get discountIn => _discountController.sink;
  Sink<List> get sortIn => _sortController.sink;
  Sink<int> get notificationIn => _notificationCountController.sink;
  Sink<int> get cartIn => _cartCountController.sink;
  Sink<QuerySnapshot> get bannerIn => _bannerController.sink;

  //STREAMS
  Stream<QuerySnapshot> get productsListOut => _productsListController.stream;
  Stream<QuerySnapshot> get productsCarouselOut => _productsCarouselController.stream;
  Stream<QuerySnapshot> get discountOut => _discountController.stream;
  Stream<int> get notificationOut => _notificationCountController.stream;
  Stream<int> get cartOut => _cartCountController.stream;
  Stream<QuerySnapshot> get bannerOut => _bannerController.stream;

  getProductsList(String option) async{
    QuerySnapshot qs = await productDetails.getProductsList(option);
    productsListIn.add(qs);
  }

  getTopRated(bool limited) async{
    QuerySnapshot qs = await productDetails.getToprated(limited);
    if(limited)
      productsCarouselIn.add(qs);
    else
      productsListIn.add(qs);
  }

  getDiscounted(bool limited) async{
    QuerySnapshot qs = await productDetails.getDiscounted(limited);
    if(limited)
      discountIn.add(qs);
    else
    productsListIn.add(qs);
  }

  getBanners() async{
    QuerySnapshot qs = await productDetails.getBanners();
    bannerIn.add(qs);
  }

  getSearchResults(String text) async{
    QuerySnapshot qs = await productDetails.getSearchResults(text);
    productsListIn.add(qs);
  }

  filteredProductsList(List data) async{
    QuerySnapshot qs = await productDetails.getProductListFiltered(data[0], data[1], data[2]);
    productsListIn.add(qs);
  }

  getFullList(String option){
    switch(option){
      case 'Featured Products': {
        getTopRated(false);
        break;
      }
      case 'On Sale': {
        getDiscounted(false);
        break;
      }
      default: {
        getProductsList(option);
        break;
      }
    }
  }

  @override
  void dispose() {
    _productsCarouselController.close();
    _productsListController.close();
    _sortController.close();
    _notificationCountController.close();
    _cartCountController.close();
    _discountController.close();
    _bannerController.close();
  }

}

final productsHomeBloc = ProductsHomeBloc();