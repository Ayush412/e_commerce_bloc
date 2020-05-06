import 'dart:async';
import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/blocs/user_details_bloc/user_details_validator.dart';
import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';
import 'package:e_commerce_bloc/repositories/user_details_repo.dart';
import 'package:e_commerce_bloc/widgets/map_details.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class UserDetailsBloc with ValidateDetails implements BaseBloc{

  String fname;
  String lname;
  String mob;
  String address;
  double defaultlat=0;
  double defaultlng=0;
  double lat=0;
  double lng=0;
  Map<dynamic, dynamic> userMap = Map<dynamic, dynamic>();
  Map<dynamic, dynamic> userCoordinates = Map<dynamic, dynamic>();

  UserDetailsBloc(){
    _fnameController.stream.listen((event) {fname=event;});
    _lnameController.stream.listen((event) {lname=event;});
    _mobController.stream.listen((event) {mob=event;});
    _addressController.stream.listen((event) {address=event;});
  }
  //CONTROLLERS
  BehaviorSubject<Map> _userMapController = BehaviorSubject();
  BehaviorSubject<String> _fnameController = BehaviorSubject();
  BehaviorSubject<String> _lnameController = BehaviorSubject();
  BehaviorSubject<String> _mobController = BehaviorSubject();
  BehaviorSubject<String> _addressController = BehaviorSubject();
  BehaviorSubject<List> _mapController = BehaviorSubject();
  BehaviorSubject<String> _mapPlaceController = BehaviorSubject();

  //SINKS
  Function(String) get fnameChanged => _fnameController.sink.add;
  Function(String) get lnameChanged => _lnameController.sink.add;
  Function(String) get mobChanged => _mobController.sink.add;
  Function(String) get addressChanged => _addressController.sink.add;
  Sink get mapCoordinatesIn => _mapController.sink;
  Sink get mapPlaceIn => _mapPlaceController.sink;
  Sink get userMapIn => _userMapController.sink;

  //STREAMS
  Stream<String> get fnameCheck => _fnameController.stream.transform(fnameValidator);
  Stream<String> get lnameCheck => _lnameController.stream.transform(lnameValidator);
  Stream<String> get mobCheck => _mobController.stream.transform(mobValidator);
  Stream<String> get addressCheck => _addressController.stream.transform(addressValidator);
  Stream<List> get mapCoordinatesOut => _mapController.stream;
  Stream<String> get mapPlaceOut => _mapPlaceController.stream;
  Stream<bool> get credentialsCheck => Rx.combineLatest5(fnameCheck, lnameCheck, mobCheck, addressCheck, mapCoordinatesOut, (a, b, c, d, e) => true);
  Stream<Map> get userMapOut => _userMapController.stream;

  updateMap(double newlat, double newlng){
    lat=newlat;
    lng=newlng;
    mapCoordinatesIn.add([lat,lng]);
    getPlace(lat, lng);
    mapDetails.animate();
  }

  getPlace(double latitude, double longitude) async{
    String mylocation;
    List<Placemark> p = await Geolocator().placemarkFromCoordinates(latitude,longitude);
    Placemark place = p[0];
    mylocation="${place.name}, ${place.subLocality}, ${place.locality}, ${place.country}";
    mapPlaceIn.add(mylocation);
  }

  saveUserData() async{
    Map map = {"FName":fname, "LName":lname, "Mob":mob, "Address":address, "Latitude": lat, "Longitude": lng};
    await userDetails.saveUserData(map);
  }

  updateUserData() async{
    Map map = {
      "FName": fname==null? loginBloc.userMap['FName'] : fname, 
      "LName": lname==null? loginBloc.userMap['LName'] : lname,
      "Mob": mob==null? loginBloc.userMap['Mob'] : mob, 
      "Address": address==null? loginBloc.userMap['Address'] : address, 
      "Latitude": lat==0? loginBloc.userMap['Latitude'] : lat, 
      "Longitude": lng==0? loginBloc.userMap['Longitude'] : lng,
    };
    await userDetails.updateUserData(map);
  }
  
  @override
  void dispose() {
    _fnameController.close();
    _lnameController.close();
    _mobController.close();
    _addressController.close();
    _mapController.close();
    _mapPlaceController.close();
    _userMapController.close();
  }
}

final userDetailsBloc = UserDetailsBloc();