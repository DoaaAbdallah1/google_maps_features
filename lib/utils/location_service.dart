import 'package:location/location.dart';

class LocationService {
  Location location=Location();

  
  Future<bool> checkRequestLocationService() async {
    bool serviceEnabled;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }
    return true;
  }
  
  Future<bool> checkRequestLocationPermission() async {
    PermissionStatus permissionGranted;

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.deniedForever) {
      return false;
    }
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    
        return   permissionGranted == PermissionStatus.granted;
      
    }
    return true;
  }

  void getRealTimeLocationData(void Function(LocationData)? onData){
      location.changeSettings(
      distanceFilter: 2.0, // in meters
    );
    location.onLocationChanged.listen(onData);
  }
  

  
}