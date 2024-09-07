import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController controllerGoogleMaps;
  late CameraPosition initialPosition;
  late List<Marker> markers;
  late bool isMapLoaded;

  @override
  void initState() {
    initialPosition = const CameraPosition(
      target: LatLng(28.9759860985685, 34.655899477464075),
      zoom: 10,
    );
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
    var nightStyle = await DefaultAssetBundle.of(context).loadString("assets/google_maps_style.json");
    controllerGoogleMaps.setMapStyle(nightStyle);
  }
}
