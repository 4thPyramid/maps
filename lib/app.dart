import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps/map/presentation/logic/map_bloc.dart';
import 'package:maps/map/presentation/logic/map_event.dart';
import 'package:maps/map/presentation/logic/map_state.dart';
import 'package:maps/map/presentation/view/best_route_view.dart';
import 'package:maps/map/presentation/view/google_map_view.dart';

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
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<MapBloc>().add(PermissionEvent());
              },
              child: Text('Google Map'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<MapBloc>().add(CurrenttLocationEvent());
              },
              child: Text('Current Location'),
            ),
            Text('Welcome to the Home Screen!'),
            Row(children: [Icon(Icons.map)]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (BuildContext context) {
                  return MapBloc()..add(StreamPositionEvent());
                },
                child: const GoogleMapView(),
              ),
            ),
          );
        },
        child: const Icon(Icons.map),
      ),
    );
  }
}
