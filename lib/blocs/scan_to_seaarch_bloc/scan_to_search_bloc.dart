import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/blocs/products_home_bloc/products_home_bloc.dart';
import 'package:e_commerce_bloc/repositories/scan_to_search_repo.dart';
import 'package:rxdart/subjects.dart';

class ScanToSearchBloc extends BaseBloc{

  String text;

  //CONTROLLERS
  BehaviorSubject<List> _labelsController = BehaviorSubject();
  BehaviorSubject<QuerySnapshot> _scannedDataController = BehaviorSubject();

  //SINKS
  Sink<List> get lablesIn => _labelsController.sink;
  Sink<QuerySnapshot> get scannedListIn => _scannedDataController.sink;

  //STREAM
  Stream<List> get labelsOut => _labelsController.stream;
  Stream<QuerySnapshot> get scannedListOut => _scannedDataController.stream;

  getImage() async{
    text=null;
    List data = await scanToSearchRepo.getImage();
    text=data[0];
    scannedListIn.add(data[1]);
  }

  @override
  void dispose() {
    _labelsController.close();
    _scannedDataController.close();  
  }

}

final scanToSearchBloc = ScanToSearchBloc();