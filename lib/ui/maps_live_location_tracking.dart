import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapsLiveLocationTracking extends StatefulWidget {
  const MapsLiveLocationTracking({super.key});

  @override
  State<MapsLiveLocationTracking> createState() =>
      _MapsLiveLocationTrackingState();
}

class _MapsLiveLocationTrackingState extends State<MapsLiveLocationTracking> {
  GoogleMapController? googleMapController;
  late CameraPosition initialPosition;
  late Location location;

  @override
  void initState() {
    location = Location();
    initialPosition = const CameraPosition(
      target: LatLng(28.9759860985685, 34.655899477464075),
      zoom: 10,
    );
    updateLocationService();
    super.initState();
  }

  @override
  void dispose() {
    googleMapController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: initialPosition,
        mapType: MapType.hybrid,
        onMapCreated: (controller) {
          googleMapController = controller;
        },
        zoomControlsEnabled: false,
      ),
    );
  }

  Future<void> checkRequestLocationService() async {
    bool serviceEnabled;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
  }

  Future<bool> checkRequestLocationPermission() async {
    PermissionStatus permissionGranted;

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.deniedForever) {
      return false;
    }
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      } 
    }
    return true;
  }

  void getLocationData() {
    location.onLocationChanged.listen(
      (locationData) {
        
          googleMapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(locationData.latitude!, locationData.longitude!),
                zoom: 15,
              ),
            ),
          );
        
      },
    );
  }

  Future<void> updateLocationService() async {
    await checkRequestLocationService();
    var hasPermission = await checkRequestLocationPermission();
    if (hasPermission) {
      getLocationData();
    }
  }
}
