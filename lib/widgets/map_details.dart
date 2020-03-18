import 'dart:async';
import 'package:e_commerce_bloc/blocs/user_details_bloc/user_details_bloc.dart';
import 'package:e_commerce_bloc/blocs/user_login_bloc/user_login_bloc.dart';
import 'package:e_commerce_bloc/widgets/map_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapDetails{
GoogleMap map;
Completer<GoogleMapController> controller1 = Completer();
  mapDetails(BuildContext context, double lat, double lng){
    Completer<GoogleMapController> controller2 = Completer();
    controller1 = controller2;
    return Column(
        children: <Widget>[
          Container(
            height: 200, width: 340,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  child: map = GoogleMap(
                    onMapCreated: (GoogleMapController _controller){
                      controller2.complete(_controller);
                    },
                    myLocationEnabled: false,
                    myLocationButtonEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(lat,lng),
                      zoom: 18.5
                    ),
                  )
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Icon(Icons.location_on, size: 40),
                  )
                ),
                Container(
                  color: Colors.transparent
                ),
                Positioned(
                  right: 7,
                  child: IconButton(icon: Icon(Icons.edit, size: 25,),  
                    color: Colors.black,
                    onPressed: () => mapDialog(context, loginBloc.userMap['Latitude'], loginBloc.userMap['Longitude']))
                ), 
                Positioned(
                  top: 40, right:20,
                  child: Text('EDIT', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600),)
                ),
              ],
            )
          ),
          Container(
            width: 340,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: StreamBuilder(
                stream: userDetailsBloc.mapPlaceOut,
                builder:(context, snap) => Text(snap.hasData? snap.data : 'Select map location', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)))
            )
          ),
        ],
      );
  }

  animate() async{
    GoogleMapController controller = await controller1.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng (newlat, newlng), 18.5));
  }
}

final mapDetails = MapDetails();