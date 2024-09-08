import 'package:flutter/material.dart';
import 'package:google_maps_features/utils/location_service.dart';
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
  late LocationService locationService;
  Set<Marker> markers = {};
  bool isFirstCall = true;

  @override
  void initState() {
    initialPosition = const CameraPosition(
      target: LatLng(28.9759860985685, 34.655899477464075),
      zoom: 1,
    );
    locationService = LocationService();
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
        markers: markers,
        initialCameraPosition: initialPosition,
        mapType: MapType.hybrid,
        onMapCreated: (controller) {
          googleMapController = controller;
        },
        zoomControlsEnabled: false,
      ),
    );
  }

  Future<void> updateLocationService() async {
    await locationService.checkRequestLocationService();
    var hasPermission = await locationService.checkRequestLocationPermission();

    if (hasPermission) {
      locationService.getRealTimeLocationData(
        (locationData) {
          var latLng = LatLng(locationData.latitude!, locationData.longitude!);
          addMarker(latLng);
          updateLocationCamera(latLng);
        },
      );
    }
  }

  void addMarker(LatLng latLng) {
    var myLocationMarker = Marker(markerId: MarkerId("1"), position: latLng);
    markers.add(myLocationMarker);
    setState(() {});
  }

  void updateLocationCamera(LatLng latLng) {
    if (isFirstCall) {
      isFirstCall = false;
      googleMapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: latLng,
        zoom: 17,
      )));

      // Uncomment the following line if you want to track the user's location continuously.
      // locationService.startLocationUpdates();
    } else {
      googleMapController?.animateCamera(
        CameraUpdate.newLatLng(latLng),
      );
    }
  }
}
