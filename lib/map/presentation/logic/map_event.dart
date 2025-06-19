import 'package:flutter/widgets.dart';

abstract class MapEvent {}

class permissionEvent extends MapEvent {
  final BuildContext context;
  permissionEvent(this.context);
}
