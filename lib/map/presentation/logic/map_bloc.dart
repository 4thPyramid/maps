import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps/map/presentation/logic/map_event.dart';
import 'package:maps/map/presentation/logic/map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(InitialMapState()) {
    on<PermissionEvent>(onPermission);
    on<CurrenttLocationEvent>(onCurrenttLocation);
    on<StreamPositionEvent>(streamPosition);
    on<LocationChangedEvent>((event, emit) {
      emit(CurrenttLocationState(event.position));
    });
  }

  Future<void> onPermission(
    PermissionEvent event,
    Emitter<MapState> emit,
  ) async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      Geolocator.requestPermission();
      emit(PermissionDeniedState());
    } else {
      emit(PermissionGrantedState());
    }
  }

  Future<void> onCurrenttLocation(
    CurrenttLocationEvent event,
    Emitter<MapState> emit,
  ) async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      add(PermissionEvent());
      emit(PermissionDeniedState());
    } else {
      final position = await Geolocator.getCurrentPosition();
      emit(CurrenttLocationState(position));
    }
  }

  Future<void> streamPosition(
    StreamPositionEvent event,
    Emitter<MapState> emit,
  ) async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      add(PermissionEvent());
      emit(PermissionDeniedState());
    } else {
      Geolocator.getPositionStream().listen((Position position) {
        add(LocationChangedEvent(position)); // ✅ استخدم add بدل emit
      });
    }
  }
}
