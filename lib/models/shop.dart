import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShopItem {
  final String id;
  final String title;
  final String address;
  final String cp;
  final String telephone;
  final List<double> location;
  bool isCovered;
  ShopItem(
      {required this.id,
      required this.title,
      required this.address,
      required this.cp,
      required this.telephone,
      required this.location,
      required this.isCovered});
}

class ShopsProvider with ChangeNotifier {
  List<ShopItem> _items = [];

  void fetchAndSetProducts(List<Map> extractedData) {
    final List<ShopItem> loadedShops = [];
    extractedData.forEach((shop) {
      loadedShops.add(ShopItem(
          id: shop["id"],
          title: shop["title"],
          address: shop["address"],
          cp: shop["cp"],
          telephone: shop["telephone"],
          location: (shop["location"] as List<dynamic>)
              .map((location) => location as double)
              .toList(),
          isCovered: shop["isCovered"]));
    });
    _items = loadedShops;
  }

  List<ShopItem> get items {
    return [..._items];
  }

  Future<void> checkShop(String shopId, String sellerId) async {
    final shopIndex = _items.indexWhere((shop) => shop.id == shopId);
    _items[shopIndex].isCovered = true;
    notifyListeners();
    var url = Uri.parse(
        'https://smart-pos-b9bdb-default-rtdb.asia-southeast1.firebasedatabase.app/salesperson/$sellerId/dailyShops/$shopIndex.json');
    try {
      final response = await http.patch(url,
          body: json.encode({
            "isCovered": true,
          }));
      print(response);
      if (response.statusCode >= 400) {
        _items[shopIndex].isCovered = false;
        notifyListeners();
      }
    } catch (error) {
      _items[shopIndex].isCovered = false;
      notifyListeners();
    }
  }

  ShopItem findById(String shopId) {
    return _items.firstWhere((shop) => shop.id == shopId);
  }

  int uncoveredShops() {
    int number = items.where((e) => e.isCovered == false).length;
    return number;
  }

  List<List> getShopLocations() {
    List<List> locations = [];
    _items.forEach((shop) {
      locations.add(shop.location);
    });
    return locations;
  }
}
