import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/repositories/notifications_repo.dart';
import 'package:rxdart/subjects.dart';

class NotificationsBloc implements BaseBloc{

  //CONTROLLERS
  BehaviorSubject<QuerySnapshot> _notificationListController = BehaviorSubject();

  //SINKS
  Sink<QuerySnapshot> get notificationListIn => _notificationListController.sink;

  //STREAMS
  Stream<QuerySnapshot> get notificationListOut => _notificationListController.stream;

  getData() async{
    QuerySnapshot qs = await notificationsRepo.getNotifications();
    notificationListIn.add(qs);
  }

  deleteData(DocumentSnapshot doc) async{
    await notificationsRepo.delete(doc);
    getData();
  }

  clearAll() async{
    await notificationsRepo.deleteAll();
    getData();
  }

  @override
  void dispose() {
    _notificationListController.close();  
  }

}

final notificationsBloc = NotificationsBloc();