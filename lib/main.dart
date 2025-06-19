import 'package:flutter/material.dart';
import 'package:maps/map/presentation/view/google_map_view.dart';
import 'package:maps/map/presentation/view/best_route_view.dart';

void main() {
  runApp(const MyGoogleMap());
}

class MyGoogleMap extends StatelessWidget {
  const MyGoogleMap({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Google Map Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Center(child: const HomeScreen()),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RouteMapScreen()),
              );
            },
            icon: const Icon(Icons.route),
          ),
        ],
      ),
      body: const Center(child: Text('Welcome to the Home Screen!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MapWidget()),
          );
        },
        child: const Icon(Icons.map),
      ),
    );
  }
}
