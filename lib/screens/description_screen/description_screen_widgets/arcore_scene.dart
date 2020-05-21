import 'dart:async';

import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';

class ARScreen extends StatefulWidget {
  String id;
  String url;
  ARScreen({this.id, this.url});
  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {

  ArCoreController arCoreController;

  @override
  void initState() {
    super.initState();
    Timer.run(() => instructionsDialog());
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onNodeTap = (name) => onTapHandler(name);
    arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    _addObject(hit);
  }

  void _addObject(ArCoreHitTestResult plane) {
    final toucanNode = ArCoreReferenceNode(
      name: widget.id,
      objectUrl: widget.url,
      position: plane.pose.translation,
      rotation: plane.pose.rotation
    );
    arCoreController.addArCoreNodeWithAnchor(toucanNode);
  }

  void onTapHandler(String name) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        content: Row(
          children: <Widget>[
            Text('Remove object?'),
            IconButton(
                icon: Icon(
                  Icons.delete,
                ),
                onPressed: () {
                  arCoreController.removeNode(nodeName: name);
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }

  instructionsDialog(){
    return showDialog(
      context: context,
      builder: (c)=> AlertDialog(
        title: Text('Instructions (BETA)', style: TextStyle(fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        actions: [
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.pop(c, false),
          )
        ],
        content: Text('Move the phone around till the camera detects a flat surface. White dots will be displayed upon detection. Tap once on the dotted area of the screen and wait for a few seconds till the object loads'),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){Navigator.of(context).pop();},
          child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Stack(
            children: [
              ArCoreView(
                onArCoreViewCreated: _onArCoreViewCreated,
                enableTapRecognizer: true
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left:10, top: 20),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 35),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose(){
    arCoreController.dispose();
    super.dispose();
  }
}