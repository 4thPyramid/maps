import 'package:geolocator/geolocator.dart';

abstract class MapState {}

class InitialMapState extends MapState {}

class PermissionDeniedState extends MapState {}

class PermissionGrantedState extends MapState {}

class CurrenttLocationState extends MapState {
  final Position position;

  CurrenttLocationState(this.position);
}
