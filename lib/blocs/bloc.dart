import 'package:rxdart/rxdart.dart';

abstract class BaseBloc{
  void dispose();
}

class Bloc implements BaseBloc{

  //CONTROLLERS
  final _progressIndicatorController = BehaviorSubject<bool>();
  final _containerHeightController = BehaviorSubject<double>();
  
  //SINKS
  Sink<bool> get loadingStatusIn => _progressIndicatorController.sink;
  Sink<double> get containerHeightIn => _containerHeightController.sink;
  
  //STREAMS
  Stream<bool> get loadingStatusOut => _progressIndicatorController.stream;
  Stream<double> get containerHeightOut => _containerHeightController.stream;

  @override
  void dispose() {
    _progressIndicatorController.close();
    _containerHeightController.close();
  }

}

final bloc = Bloc();