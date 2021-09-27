import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SalesPerson {
  final String id;
  final String name;
  final Map<String, dynamic> dailyRoute;
  final Map<String, dynamic> dailyShops;
  final double dailySalesTarget;
  final double dailySalesProgression;
  final List<Map> dailySales;
  final Map<String, dynamic> dailyInventory;
  SalesPerson(
      {required this.id,
      required this.name,
      required this.dailyRoute,
      required this.dailyShops,
      required this.dailySalesTarget,
      required this.dailySalesProgression,
      required this.dailySales,
      required this.dailyInventory});
}

class SalesPersonProvider with ChangeNotifier {
  SalesPerson? seller;
  final String? userId;
  final String? authToken;

  SalesPersonProvider(this.userId, this.authToken, this.seller);
  // ignore: non_constant_identifier_names
  final SERVER_IP = 'http://10.0.2.2:3000';
  // final SERVER_IP = 'http://localhost:3000';

  Future<void> fetchAndSetSalesperson() async {
    try {
      final response = await http.post(
          Uri.parse("$SERVER_IP/api/task/salesperson"),
          body: {"sellerId": userId},
          headers: {"x-access-token": authToken as String});
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((sellerID, sellerData) {
        seller = new SalesPerson(
            id: sellerID,
            name: sellerData["name"],
            dailyRoute: sellerData["dailyRoute"] as Map<String, dynamic>,
            dailyShops: (sellerData["dailyShops"] as Map<String, dynamic>),
            dailySalesTarget: sellerData["dailySalesTarget"].toDouble(),
            dailySalesProgression:
                sellerData["dailySalesProgression"].toDouble(),
            dailySales: [],
            dailyInventory:
                (sellerData["dailyInventory"] as Map<String, dynamic>));
      });
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  SalesPerson? get person {
    return seller;
  }

  void removePerson() {
    seller = null;
  }
}
