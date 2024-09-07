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
  late bool isMapLoaded;

  @override
  void initState() {
    initialPosition = const CameraPosition(
      target: LatLng(28.9759860985685, 34.655899477464075),
      zoom: 10,
    );
    initialMarker();
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
          markers: markers,
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
    var iconCustomer =  BitmapDescriptor.fromBytes(imageBytes);
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
    setState(() {
      
    });
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
}
