import 'package:flutter/material.dart';
import 'package:maps/google_map_view.dart';

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
      appBar: AppBar(title: const Text('Home')),
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
