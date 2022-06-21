import 'dart:math' as math;
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ArMeasurementScreen extends StatefulWidget {
  @override
  _ArMeasurementScreenState createState() => _ArMeasurementScreenState();
}

class _ArMeasurementScreenState extends State<ArMeasurementScreen> {
  bool loading = false;
  ARKitController arkitController;
  ARKitPlane plane;
  ARKitNode node;
  String anchorId;
  vector.Vector3 lastPosition;
  Matrix4 transform;

  ARKitController get controller => null;
  var name = "";
  var chest = "";
  var shoulders = "";
  var waist = "";
  var shirt = "";
  var sleeve = "";
  var pant = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final nameController = TextEditingController();
  final chestController = TextEditingController();
  final shouldersController = TextEditingController();
  final waistController = TextEditingController();
  final shirtController = TextEditingController();
  final sleeveController = TextEditingController();
  final pantController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    chestController.dispose();
    shouldersController.dispose();
    waistController.dispose();
    shirtController.dispose();
    sleeveController.dispose();
    pantController.dispose();

    super.dispose();
  }

  clearText() {
    nameController.clear();
    chestController.clear();
    shouldersController.clear();
    waistController.clear();
    shirtController.clear();
    sleeveController.clear();
    pantController.clear();
  }

  // Adding Student
  CollectionReference sizes = FirebaseFirestore.instance.collection('sizes');

  Future<void> addUser() {
    return sizes
        .add({
          'name': name,
          'chest': chest,
          'shoulder': shoulders,
          'waist': waist,
          'shirt': shirt,
          'sleeve': sleeve,
          'pant': pant
        })
        .then((value) => print('User Added'))
        .catchError((error) => print('Failed to Add user: $error'));
  }

  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Colors.white,
          title: Text(
            "Sizes",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 45,
                    margin: EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                        onPressed: OnAdd,
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff1C1C1C),
                            onPrimary: Color(0xff1C1C1C),
                            onSurface: Colors.grey.shade50,
                            shadowColor: Colors.white,
                            padding: EdgeInsets.all(5),
                            elevation: 0),
                        child: loading
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                ))
                            : Text('Add',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500)))),
              ],
            ))
          ],
          elevation: 4,
        ),
        body: Container(
          child: ARKitSceneView(
            showFeaturePoints: true,
            planeDetection: ARPlaneDetection.horizontalAndVertical,
            onARKitViewCreated: onARKitViewCreated,
            enableTapRecognizer: true,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 2,
          onTap: onChangeNavigation,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add),
              label: 'Store Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.boy_sharp),
              label: 'Sizes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined),
              label: 'Details',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'Logout',
            ),
          ],
          selectedItemColor: Colors.blue,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: (() {
            lastPosition = null;
            onARKitViewCreated(arkitController);

            _onPlaneTapHandler(transform);
          }),
          
                            
          //tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onAddNodeForAnchor = _handleAddAnchor;
    this.arkitController.onUpdateNodeForAnchor = _handleUpdateAnchor;
    this.arkitController.onARTap = (List<ARKitTestResult> ar) {
      final planeTap = ar.firstWhere(
        (tap) => tap.type == ARKitHitTestResultType.existingPlaneUsingExtent,
        orElse: () => null,
      );
      if (planeTap != null) {
        _onPlaneTapHandler(planeTap.worldTransform);
      }
    };
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (!(anchor is ARKitPlaneAnchor)) {
      return;
    }
    _addPlane(arkitController, anchor);
  }

  void _handleUpdateAnchor(ARKitAnchor anchor) {
    if (anchor.identifier != anchorId) {
      return;
    }
    final ARKitPlaneAnchor planeAnchor = anchor;
    node.position =
        vector.Vector3(planeAnchor.center.x, 0, planeAnchor.center.z);
    plane.width.value = planeAnchor.extent.x;
    plane.height.value = planeAnchor.extent.z;
  }

  void _addPlane(ARKitController controller, ARKitPlaneAnchor anchor) {
    anchorId = anchor.identifier;
    plane = ARKitPlane(
      width: anchor.extent.x,
      height: anchor.extent.z,
      materials: [
        ARKitMaterial(
          transparency: 0.5,
          diffuse: ARKitMaterialProperty(color: Colors.white),
        )
      ],
    );

    node = ARKitNode(
      geometry: plane,
      position: vector.Vector3(anchor.center.x, 0, anchor.center.z),
      rotation: vector.Vector4(1, 0, 0, -math.pi / 2),
    );
    controller.add(node, parentNodeName: anchor.nodeName);
  }

  void _onPlaneTapHandler(Matrix4 transform) {
    final position = vector.Vector3(
      transform.getColumn(3).x,
      transform.getColumn(3).y,
      transform.getColumn(3).z,
    );
    final material = ARKitMaterial(
      lightingModelName: ARKitLightingModel.constant,
      diffuse: ARKitMaterialProperty(color: Colors.amber),
    );
    final sphere = ARKitSphere(
      radius: 0.003,
      materials: [material],
    );
    final node = ARKitNode(
      geometry: sphere,
      position: position,
    );

    arkitController.add(node);
    if (lastPosition != null) {
      final line = ARKitLine(
        fromVector: lastPosition,
        toVector: position,
      );
      final lineNode = ARKitNode(geometry: line);
      arkitController.add(lineNode);

      final distance = _calculateDistanceBetweenPoints(position, lastPosition);
      final point = _getMiddleVector(position, lastPosition);
      _drawText(distance, point);
    }
    lastPosition = position;
  }

  String _calculateDistanceBetweenPoints(vector.Vector3 A, vector.Vector3 B) {
    final length = A.distanceTo(B);
    return '${(length * 100).toStringAsFixed(2)} cm/${(length * 100 / 2.54).toStringAsFixed(2)} inch';
  }

  vector.Vector3 _getMiddleVector(vector.Vector3 A, vector.Vector3 B) {
    return vector.Vector3((A.x + B.x) / 2, (A.y + B.y) / 2, (A.z + B.z) / 2);
  }

  void _drawText(String text, vector.Vector3 point) {
    final textGeometry = ARKitText(
      text: text,
      extrusionDepth: 1,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty(color: Colors.amberAccent),
        )
      ],
    );
    const scale = 0.001;
    final vectorScale = vector.Vector3(scale, scale, scale);
    final node = ARKitNode(
      geometry: textGeometry,
      position: point,
      scale: vectorScale,
    );
    arkitController
        .getNodeBoundingBox(node)
        .then((List<vector.Vector3> result) {
      final minVector = result[0];
      final maxVector = result[1];
      final dx = (maxVector.x - minVector.x) / 2 * scale;
      final dy = (maxVector.y - minVector.y) / 2 * scale;
      final position = vector.Vector3(
        node.position.x - dx,
        node.position.y - dy,
        node.position.z,
      );
      node.position = position;
    });
    arkitController.add(node);
  }

  void onChangeNavigation(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/addService');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/details');
    } else if (index == 4) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void OnAdd() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 6),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(children: [
                TextField(
                  controller: nameController,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.blue, width: 2)),
                      contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      labelText: 'Name:',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2))),
                ),
                SizedBox(height: 6),
                TextField(
                  controller: chestController,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.blue, width: 2)),
                      contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      labelText: 'Chest:',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2))),
                ),
                SizedBox(height: 6),
                TextField(
                  controller: shouldersController,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.blue, width: 2)),
                      contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      labelText: 'Shoulders:',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2))),
                ),
                SizedBox(height: 6),
                TextField(
                  controller: waistController,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.blue, width: 2)),
                      contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      labelText: 'Waist:',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2))),
                ),
                SizedBox(height: 6),
                TextField(
                  controller: shirtController,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.blue, width: 2)),
                      contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      labelText: 'Shirt Length:',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2))),
                ),
                SizedBox(height: 6),
                TextField(
                  controller: sleeveController,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.blue, width: 2)),
                      contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      labelText: 'Sleeve Length:',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2))),
                ),
                SizedBox(height: 6),
                TextField(
                  controller: pantController,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.blue, width: 2)),
                      contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      labelText: 'Pant Length:',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2))),
                ),
                SizedBox(height: 5),
                ListTile(
                  onTap: () {
                    name = nameController.text;
                    chest = chestController.text;
                    shoulders = shirtController.text;
                    waist = waistController.text;
                    shirt = shirtController.text;
                    sleeve = sleeveController.text;
                    pant = pantController.text;
                    addUser();
                    clearText();
                  },
                  leading: Icon(Icons.save),
                  title: Text('Save'),
                  //onTap: (),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
