import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapView extends StatelessWidget {
  const GoogleMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Map View')),
      body: Center(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(30.7749, 31.4194),
            zoom: 10,
          ),
          markers: {
            Marker(
              markerId: MarkerId('marker_1'),
              position: LatLng(30.7749, 31.4194),
              infoWindow: InfoWindow(
                title: 'Marker 1',
                snippet: 'This is marker 1',
              ),
            ),
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
              .then((Position position) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Current Position: ${position.latitude}, ${position.longitude}',
                    ),
                  ),
                );
              })
              .catchError((e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error getting location: $e')),
                );
              });
        },
        child: const Icon(Icons.map_outlined),
      ),
    );
  }
}
