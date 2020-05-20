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
        content: Row(
          children: <Widget>[
            Text('Remove object'),
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                padding: const EdgeInsets.all(10),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 6),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            )
          ],
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