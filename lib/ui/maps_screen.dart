import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_features/model/places_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController controllerGoogleMaps;
  late CameraPosition initialPosition;
  Set<Marker> markers = {};
  Set<Polyline> polyLines = {};
  Set<Polygon> polygons = {};
  Set<Circle> circles = {};
  late bool isMapLoaded;

  @override
  void initState() {
    initialPosition = const CameraPosition(
      target: LatLng(28.9759860985685, 34.655899477464075),
      zoom: 10,
    );
    initialMarker();
    initialPolyLines();
    initialPolygons();
    initialCircles();
    super.initState();
  }

  @override
  void dispose() {
    controllerGoogleMaps.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        GoogleMap(
          circles: circles,
          markers: markers,
          zoomControlsEnabled: false,
          polylines: polyLines,
          polygons: polygons,
          initialCameraPosition: initialPosition,
          onMapCreated: (controller) {
            controllerGoogleMaps = controller;
            initialMapStyleJson();
          },
        ),
        Positioned(
            bottom: 30,
            right: 60,
            left: 60,
            child: ElevatedButton(
                onPressed: () {
                  controllerGoogleMaps.animateCamera(CameraUpdate.newLatLng(
                      LatLng(31.13054765382769, 33.81406431907617)));
                },
                child: Text("Change Location")))
      ],
    ));
  }

  Future<void> initialMapStyleJson() async {
    var nightStyle = await DefaultAssetBundle.of(context)
        .loadString("assets/google_maps_style.json");
    controllerGoogleMaps.setMapStyle(nightStyle);
  }

  Future<void> initialMarker() async {
    var imageBytes =
        await getUint8List("assets/image/location-marker-svgrepo-com.png", 70);
    var iconCustomer = BitmapDescriptor.fromBytes(imageBytes);
    var markersSet = placesModel
        .map(
          (placeModel) => Marker(
            icon: iconCustomer,
            markerId: MarkerId(placeModel.id.toString()),
            position: placeModel.latLng,
            infoWindow: InfoWindow(
              title: placeModel.name,
            ),
          ),
        )
        .toSet();
    markers.addAll(markersSet);
    setState(() {});
  }

  Future<Uint8List> getUint8List(String img, int width) async {
    var imageData = await rootBundle.load(img);
    var imageCodeC = await ui.instantiateImageCodec(
        imageData.buffer.asUint8List(),
        targetWidth: width);
    var imageFrame = await imageCodeC.getNextFrame();
    var frameBytes =
        await imageFrame.image.toByteData(format: ui.ImageByteFormat.png);
    return frameBytes!.buffer.asUint8List();
  }

  void initialPolyLines() {
    var myPolyLine = const Polyline(
        color: Colors.white54,
        width: 5,
        geodesic: true,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        visible: true,
        polylineId: PolylineId("1"),
        points: [
          LatLng(28.777943893349317, 34.56646385690122),
          LatLng(29.188787280282824, 35.122646681260846)
        ]);
    polyLines.add(myPolyLine);
  }

  void initialPolygons() {
    var myPolygon = const Polygon(
        fillColor: Colors.white12,
        strokeColor: Colors.blue,
        strokeWidth: 1,
        polygonId: PolygonId("2"),
        holes: [[
          LatLng(29.769794055754033, 36.19518836294033),
          LatLng(29.903215059092247, 36.64562778612542),
          LatLng(30.045968109572982, 36.82140902444154),
        ]],
        points: [
          LatLng(29.36966213549226, 34.96471931092338),
          LatLng(29.173200160122654, 36.07433837779394),
          LatLng(29.502418728526397, 36.50555172803819),
          LatLng(29.869876565406614, 36.74999751257156),
          LatLng(30.007920739120642, 37.49157461171774),
          LatLng(30.33559856180974, 37.66735589165766),
          LatLng(31.499582538735126, 36.99169675688004),
          
        ]);
        polygons.add(myPolygon);
  }
  
  void initialCircles() {
    var myCircle = const Circle(
        center: LatLng(28.51484568664886, 33.949849839561175),
        radius: 6000,
        fillColor: Colors.white24,
        strokeColor: Colors.red,
        strokeWidth: 1,
        visible: true,
        circleId: CircleId("3"),
    );
    circles.add(myCircle);
  }
}
