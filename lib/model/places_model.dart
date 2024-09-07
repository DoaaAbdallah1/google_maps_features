import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacesModel {
  final int id;
  final String name;
  final LatLng latLng;
  const PlacesModel({required this.latLng, required this.id, required this.name});
}

List placesModel=[
  PlacesModel(id: 1, name: 'Example Place 1', latLng: LatLng(28.968852621523254, 34.64577140674382)),
  PlacesModel(id: 2, name: 'Example Place 2', latLng: LatLng(28.99573200108729, 34.60697593813108)),
  PlacesModel(id: 3, name: 'Example Place 3', latLng: LatLng(28.966299468149074, 34.62997856111386)),
];