import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/repositories/analytics_repo.dart';
import 'package:rxdart/subjects.dart';

class AnalyticsBloc implements BaseBloc{

  //CONTROLLERS
  BehaviorSubject<List> _categoryChartController = BehaviorSubject();
  BehaviorSubject<List> _fashionChartController = BehaviorSubject();
  BehaviorSubject<List> _electronicsChartController = BehaviorSubject();

  //SINKS
  Sink<List> get categoryIn => _categoryChartController.sink;
  Sink<List> get fashionIn => _fashionChartController.sink;
  Sink<List> get electronicsIn => _electronicsChartController.sink;

  //STREAMS
  Stream<List> get categoryOut => _categoryChartController.stream;
  Stream<List> get fashionOut => _fashionChartController.stream;
  Stream<List> get electronicsOut => _electronicsChartController.stream;

  getPieData() async{
    await analyticsRepo.getPieCount();
  }

  @override
  void dispose() {
    _categoryChartController.close();
    _fashionChartController.close();
    _electronicsChartController.close();
  }

}

final analyticsBloc = AnalyticsBloc();