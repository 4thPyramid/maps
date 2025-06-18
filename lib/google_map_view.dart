import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentLatLng;
  final Set<Marker> _markers = Set<Marker>();
  final Set<Polyline> _polylines = Set<Polyline>();
  StreamSubscription<Position>? _positionStream;
  MapType _mapType = MapType.normal;
  double the_distance = 0;
  final TextEditingController _searchController = TextEditingController();
  String googleApikey = "AIzaSyBRvxQVv7DEX_lklJnEDS4kTB7ehgXG8lU";
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndTrack();
  }

  Future<void> _checkPermissionAndTrack() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enable location services')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permissions are permanently denied, we cannot request permissions.',
          ),
        ),
      );
      return;
    }

    _startLocationTracking();
  }

  void _startLocationTracking() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 10,
    );

    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: locationSettings,
        ).listen((Position position) async {
          setState(() {
            _currentLatLng = LatLng(position.latitude, position.longitude);
          });
          final GoogleMapController mapController = await _controller.future;
          mapController.animateCamera(CameraUpdate.newLatLng(_currentLatLng!));
        });
  }

  calculateDistance(LatLng destination) {
    setState(() {
      if (_currentLatLng != null && _markers.isNotEmpty) {
        the_distance = Geolocator.distanceBetween(
          _currentLatLng!.latitude,
          _currentLatLng!.longitude,
          destination.latitude,
          destination.longitude,
        );
      }
    });
    print(the_distance);
    return the_distance;
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildGoogleMap(),
          Positioned(
            top: 40,
            left: 10,
            right: 10,
            child: Column(
              children: [
                _buildSearchBar(),
                const SizedBox(height: 10),
                MapTypeRow(
                  mapType: _mapType,
                  onMapTypeChanged: (type) {
                    setState(() {
                      _mapType = type;
                    });
                  },
                ),
                if (_currentLatLng != null)
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: DistanceWidget(distance: the_distance.toString()),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: _searchController,
        googleAPIKey: googleApikey,
        inputDecoration: const InputDecoration(
          hintText: "Search for a place...",
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          suffixIcon: Icon(Icons.search),
        ),
        debounceTime: 800,
        countries: const ["us", "eg"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (prediction) {
          _onPlaceSelected(prediction);
        },
        itemClick: (prediction) {
          _searchController.text = prediction.description ?? '';
          _searchController.selection = TextSelection.fromPosition(
            TextPosition(offset: _searchController.text.length),
          );
        },
        itemBuilder: (context, index, prediction) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Icon(Icons.location_on),
                const SizedBox(width: 7),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(prediction.description ?? "")],
                  ),
                ),
              ],
            ),
          );
        },
        isCrossBtnShown: true,
        // Remove the loadingWidget parameter as it's not supported
      ),
    );
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      mapType: _mapType,
      initialCameraPosition: CameraPosition(
        target:
            _currentLatLng ??
            const LatLng(30.0444, 31.2357), // Default to Cairo
        zoom: 15,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: _markers,
      polylines: _polylines,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      onTap: (LatLng position) {
        setState(() {
          _markers.removeWhere(
            (marker) => marker.markerId.value == 'tapped-location',
          );
          _markers.add(
            Marker(
              markerId: const MarkerId('tapped-location'),
              position: position,
              infoWindow: InfoWindow(
                title: 'Selected Location',
                snippet:
                    '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}',
              ),
            ),
          );
          _selectedLocation = position;
          calculateDistance(position);
        });
      },
    );
  }

  Future<void> _onPlaceSelected(Prediction prediction) async {
    if (prediction.lat == null || prediction.lng == null) return;

    final lat = double.tryParse(prediction.lat!);
    final lng = double.tryParse(prediction.lng!);

    if (lat == null || lng == null) return;

    _selectedLocation = LatLng(lat, lng);

    setState(() {
      // Remove any existing selected or tapped markers
      _markers.removeWhere(
        (marker) =>
            marker.markerId.value == 'selected-location' ||
            marker.markerId.value == 'tapped-location',
      );

      // Add new marker for the selected place
      _markers.add(
        Marker(
          markerId: const MarkerId('selected-location'),
          position: _selectedLocation!,
          infoWindow: InfoWindow(
            title: prediction.description ?? 'Selected Location',
            snippet:
                '${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
          ),
        ),
      );
    });

    // Move camera to the selected location
    final controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(_selectedLocation!, 15),
    );

    // Calculate distance if current location is available
    if (_currentLatLng != null) {
      calculateDistance(_selectedLocation!);
    }
  }
}

class MapTypeRow extends StatelessWidget {
  final MapType mapType;
  final ValueChanged<MapType> onMapTypeChanged;

  const MapTypeRow({
    super.key,
    required this.mapType,
    required this.onMapTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(child: Text("Map Type")),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => onMapTypeChanged(MapType.normal),
              child: const Text("Normal"),
            ),
            ElevatedButton(
              onPressed: () => onMapTypeChanged(MapType.hybrid),
              child: const Text("Hybrid"),
            ),
            ElevatedButton(
              onPressed: () => onMapTypeChanged(MapType.satellite),
              child: const Text("Satellite"),
            ),
            ElevatedButton(
              onPressed: () => onMapTypeChanged(MapType.terrain),
              child: const Text("Terrain"),
            ),
          ],
        ),
      ],
    );
  }
}

class DistanceWidget extends StatelessWidget {
  final String distance;
  const DistanceWidget({super.key, required this.distance});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "Distance: " + distance,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
