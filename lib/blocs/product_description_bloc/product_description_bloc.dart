import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/repositories/products_details.dart';
import 'package:rxdart/subjects.dart';

class ProductDescBloc implements BaseBloc{

  Map<dynamic, dynamic> dataMap = Map<dynamic, dynamic>();
  Map<String, double> rateMap = Map<String, double>();
  List<String> viewedList = List<String>();

  ProductDescBloc(){
    _productreviewController.stream.listen((event) {print(event.length);});
  }
  //CONTROLLERS
  BehaviorSubject<double> _userRatingController = BehaviorSubject();
  BehaviorSubject<String> _userReviewController  = BehaviorSubject();
  BehaviorSubject<List<DocumentSnapshot>> _productreviewController = BehaviorSubject();
  BehaviorSubject<double> _heightController = BehaviorSubject();
  BehaviorSubject<bool> _editController = BehaviorSubject();
  

  //SINKS
  Sink<String> get userReviewIn => _userReviewController.sink;
  Sink<double> get userRatingIn => _userRatingController.sink;
  Sink<List<DocumentSnapshot>> get reviewIn => _productreviewController.sink; 
  Sink<double> get heightIn => _heightController.sink;
  Sink<bool> get editIn => _editController.sink;

  //STREAMS
  Stream<String> get userReviewOut => _userReviewController.stream;
  Stream<double> get userRatingOut => _userRatingController.stream;
  Stream<List<DocumentSnapshot>> get reviewOut => _productreviewController.stream;
  Stream<double> get heightOut => _heightController.stream;
  Stream<bool> get editOut => _editController.stream;
  

  @override
  void dispose() {
    _userRatingController.close();
    _userReviewController.close();
    _productreviewController.close();
    _heightController.close();
    _editController.close();
  }

  addView(String docID){
    productDetails.addView(docID);
  }

  getReviews(String docID){
    productDetails.getReviews(docID);
  }

  getNextReviews(String docID){
    productDetails.getNextReviews(docID);
  }

  submitReview(String text) async{
    
  }

  getUserRating(String docID){
    productDetails.getUserRating(docID);
  }

  setUserRating(int rate, double totalRate, int totalVotes, String docID){
    userRatingIn.add(rate.toDouble());
    productDetails.setUserRating(rate, totalRate, totalVotes, docID);
  }

  updateUserRating(int oldRate, int newRate, double totalRate, int totalVotes, String docID){
    userRatingIn.add(newRate.toDouble());
    productDetails.updateUserRating(oldRate, newRate, totalRate, totalVotes, docID);
  }
}

final productDescBloc = ProductDescBloc();