import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteMapScreen extends StatefulWidget {
  const RouteMapScreen({super.key});

  @override
  State<RouteMapScreen> createState() => _RouteMapScreenState();
}

class _RouteMapScreenState extends State<RouteMapScreen> {
  late GoogleMapController mapController;
  final LatLng origin = const LatLng(30.033333, 31.233334);
  final LatLng destination = const LatLng(30.0441152, 31.2360037);

  Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];

  final String polylineString =
      "m{hvDyfs}DeDu@{A[mAUcBUaDw@yH{AyA[kCe@oCg@aC_@kCi@qAWeD_@iG{@e@Bm@N";

  @override
  void initState() {
    super.initState();
    _decodePolyline();
  }

  void _decodePolyline() {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> result = polylinePoints.decodePolyline(polylineString);

    if (result.isNotEmpty) {
      setState(() {
        _polylineCoordinates = result
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        _polylines.add(
          Polyline(
            polylineId: PolylineId('best_route'),
            color: Colors.blue,
            width: 5,
            points: _polylineCoordinates,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Route Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: origin, zoom: 16),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        polylines: _polylines,
        markers: {
          Marker(markerId: MarkerId("origin"), position: origin),
          Marker(markerId: MarkerId("destination"), position: destination),
        },
      ),
    );
  }
}
