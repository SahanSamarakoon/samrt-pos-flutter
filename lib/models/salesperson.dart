import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SalesPerson {
  final String id;
  final String firstName;
  final String lastName;
  final Map<String, dynamic> dailyRoute;
  final List<dynamic> dailyShops;
  final double dailySalesTarget;
  final double dailySalesProgression;
  final List<Map> dailySales;
  final List<dynamic> dailyInventory;

  SalesPerson({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dailyRoute,
    required this.dailyShops,
    required this.dailySalesTarget,
    required this.dailySalesProgression,
    required this.dailySales,
    required this.dailyInventory,
  });
}

class SalesPersonProvider with ChangeNotifier {
  SalesPerson? seller;
  final String? userId;
  final String? authToken;
  final String? serverIp;
  // http.Client client;

  SalesPersonProvider(this.serverIp, this.userId, this.authToken, this.seller);
  // SalesPersonProvider(
  //     this.serverIp, this.userId, this.authToken, this.seller, this.client);

  Future<void> fetchAndSetSalesperson(http.Client client) async {
    // Future<void> fetchAndSetSalesperson() async {
    final response = await client.post(
        // final response = await http.post(
        Uri.parse("$serverIp/api/task/salesperson"),
        body: {"sellerId": userId},
        headers: {"x-access-token": authToken as String});
    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body) as Map<dynamic, dynamic>;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        throw Exception('Null Task for the Salesperson');
      }
      extractedData.forEach((sellerID, sellerData) {
        seller = new SalesPerson(
            id: sellerData["sellerId"]["_id"],
            firstName: sellerData["sellerId"]["firstName"],
            lastName: sellerData["sellerId"]["lastName"],
            dailyRoute: sellerData["dailyRoute"] as Map<String, dynamic>,
            dailyShops: sellerData["dailyShops"] as List<dynamic>,
            dailySalesTarget: sellerData["dailySalesTarget"].toDouble(),
            dailySalesProgression:
                sellerData["dailySalesProgression"].toDouble(),
            dailySales: [],
            dailyInventory: sellerData["dailyInventory"] as List<dynamic>);
      });
      notifyListeners();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed - Fetch Salesperson');
    }
  }

  SalesPerson? get person {
    return seller;
  }
}
