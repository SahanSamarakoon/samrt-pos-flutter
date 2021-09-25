import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidegt extends StatefulWidget {
  final List<List> location;
  final double zoom;
  MapWidegt(this.location, this.zoom);
  @override
  _MapWidegtState createState() => _MapWidegtState();
}

class _MapWidegtState extends State<MapWidegt> {
  Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/shop.png');
  }

  @override
  void initState() {
    setCustomMapPin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<LatLng> pinPosition =
        widget.location.map((pair) => LatLng(pair[0], pair[1])).toList();
    CameraPosition initialLocation = CameraPosition(
        zoom: widget.zoom, bearing: 0, tilt: 0, target: pinPosition[0]);

    return GoogleMap(
        myLocationEnabled: true,
        markers: _markers,
        compassEnabled: true,
        tiltGesturesEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition: initialLocation,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          setState(() {
            pinPosition.forEach((pin) {
              _markers.add(Marker(
                  markerId: MarkerId(UniqueKey().toString()),
                  position: pin,
                  icon: pinLocationIcon));
            });
          });
        });
  }
}
