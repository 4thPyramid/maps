import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps/map/presentation/logic/map_event.dart';
import 'package:maps/map/presentation/logic/map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(InitialMapState()) {
    on<MapEvent>(MapEvent event, Emitter<MapState> emit) {}
  }

  getPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('')));
    }
  }
}
