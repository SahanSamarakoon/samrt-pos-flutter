import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidegt extends StatefulWidget {
  final List<double> location;
  final double zoom;
  MapWidegt(this.location, this.zoom);
  @override
  _MapWidegtState createState() => _MapWidegtState();
}

class _MapWidegtState extends State<MapWidegt> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.location[0], widget.location[1]),
        zoom: widget.zoom,
      ),
    );
  }
}
