import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class RouteTracking extends StatefulWidget {
  const RouteTracking({super.key});

  @override
  State<RouteTracking> createState() => _RouteTrackingState();
}

class _RouteTrackingState extends State<RouteTracking> {
  late CameraPosition initialCameraPosition;
  late GoogleMapController mapController;
  late Location location;
  

  @override
  void initState() {
    initialCameraPosition = CameraPosition(
      target: LatLng(0, 0),
      zoom: 0,
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        zoomControlsEnabled: false,
        initialCameraPosition: initialCameraPosition,
        
        ),
    );
  }
}