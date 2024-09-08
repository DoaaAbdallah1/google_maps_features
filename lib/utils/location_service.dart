import 'package:location/location.dart';

class LocationService {
  Location location = Location();

  Future<void> checkRequestLocationService() async {
    bool serviceEnabled;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw LocationServiceNotEnabledException;
      }
    }
  }

  Future<void> checkRequestLocationPermission() async {
    PermissionStatus permissionGranted;

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.deniedForever) {
      throw LocationPermissionException();
    }
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();

      if (permissionGranted != PermissionStatus.granted) {
        throw LocationPermissionException();
      }
    }
  }

  Future<void> getRealTimeLocationData(
      void Function(LocationData)? onData) async {
    await checkRequestLocationService();
    await checkRequestLocationPermission();
    location.changeSettings(
      distanceFilter: 2.0, // in meters
    );

    location.onLocationChanged.listen(onData);
  }

  Future<LocationData> getLocation() async {
    await checkRequestLocationService();
    await checkRequestLocationPermission();
    return await location.getLocation();
  }
}

class LocationPermissionException implements Exception{
}

class LocationServiceNotEnabledException implements Exception {}
