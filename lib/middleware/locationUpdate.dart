// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationUpdate with ChangeNotifier {
  String? position;
  final String? userId;
  final String? authToken;
  final String? serverIp;

  LocationUpdate(this.serverIp, this.userId, this.authToken);

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> updateLocation() async {
    var pos = await _determinePosition().then((result) {
      // print(result);
      return result;
    });
    position = pos.toString();

    var regEx = new RegExp(":|,");
    var ps = position!.split(regEx);
    var positionNumbers = [];
    positionNumbers.add(double.parse(ps[1]));
    positionNumbers.add(double.parse(ps[3]));

    final response = await http.patch(
        Uri.parse("$serverIp/api/task/salesperson/updateLocation"),
        body: {
          "sellerId": userId,
          "position": positionNumbers.toString(),
          "dateTime": DateTime.now().toIso8601String(),
        },
        headers: {
          "x-access-token": authToken as String
        });
    if (response.statusCode != 200) {
      throw Exception('Failed - Location Update Failed');
    }
  }

  Future<void> autoUpdate() async {
    Timer.periodic(Duration(seconds: 60), (timer) {
      updateLocation();
    });
  }
}
