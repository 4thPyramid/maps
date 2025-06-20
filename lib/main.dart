import 'package:flutter/material.dart';
import 'package:maps/app.dart';

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
