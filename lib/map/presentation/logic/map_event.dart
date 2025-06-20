import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

abstract class MapEvent {}

class PermissionEvent extends MapEvent {}

class CurrenttLocationEvent extends MapEvent {}

class StreamPositionEvent extends MapEvent {}

class LocationChangedEvent extends MapEvent {
  final Position position;

  LocationChangedEvent(this.position);
}
