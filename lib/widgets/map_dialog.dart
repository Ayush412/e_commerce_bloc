import 'dart:async';
import 'package:e_commerce_bloc/blocs/user_details_bloc/user_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

double newlat=0;
double newlng=0;

mapDialog(BuildContext context, double lat, double lng){
  Completer<GoogleMapController> _controller = Completer();
  return showDialog(
    context: context,
    builder: (c) {
      return AlertDialog(
        title: Text('Select Delivery Location'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: Container(
          height: 400, width: 300,
          child: Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: (GoogleMapController controller){
                  _controller.complete(controller);
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onCameraMove: onCameraMove,
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat, lng),
                  zoom: 18.0
                ),
              ),
              Align(
                alignment: Alignment.topCenter,    
                child: Padding(
                  padding: const EdgeInsets.only(top: 165), 
                  child: Icon(Icons.location_on, size:38)
                ),
              )
            ],
          )
        ),
        actions: <Widget>[
          FlatButton(child: Text('OK', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)), onPressed: () => updateMap(context, newlat, newlng)),
          FlatButton(child: Text('Cancel', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)), onPressed: () => onCancel(context))
        ],
     );
    }
  );
}

updateMap(BuildContext context, double lat, double lng){
  Navigator.pop(context);
  userDetailsBloc.updateMap(lat, lng);
}

onCameraMove(CameraPosition position){
  CameraPosition newPosition = CameraPosition(target: position.target);
  newlat=newPosition.target.latitude;
  newlng=newPosition.target.longitude;
  print(newlat);
  print(newlng);
}

onCancel(BuildContext context){
  Navigator.pop(context);
  newlat=0;
  newlng=0;
}

