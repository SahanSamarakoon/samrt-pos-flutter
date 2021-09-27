// ignore_for_file: non_constant_identifier_names
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
  final String? userId;
  final String? authToken;
  final SERVER_IP = 'http://10.0.2.2:3000';

  ShopsProvider(this.userId, this.authToken, this._items);

  void fetchAndSetProducts(Map<String, dynamic> extractedData) {
    final List<ShopItem> loadedShops = [];
    extractedData.forEach((shopId, shopData) {
      loadedShops.add(ShopItem(
          id: shopId,
          title: shopData["title"],
          address: shopData["address"],
          cp: shopData["cp"],
          telephone: shopData["telephone"],
          location: (shopData["location"] as List<dynamic>)
              .map((location) => location as double)
              .toList(),
          isCovered: shopData["isCovered"]));
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
    try {
      final response = await http
          .patch(Uri.parse("$SERVER_IP/api/task/salesperson/checkShop"), body: {
        "sellerId": userId,
        "shopId": shopId,
        "isCovered": "true",
      }, headers: {
        "x-access-token": authToken as String
      });
      if (response.statusCode >= 400) {
        _items[shopIndex].isCovered = false;
        notifyListeners();
      }
    } catch (error) {
      print(error);
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
