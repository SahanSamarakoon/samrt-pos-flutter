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
  final String? serverIp;
  // http.Client client;

  ShopsProvider(this.serverIp, this.userId, this.authToken, this._items);
  // ShopsProvider(
  //     this.serverIp, this.userId, this.authToken, this._items, this.client);

  void fetchAndSetShops(List<dynamic> extractedData) {
    final List<ShopItem> loadedShops = [];
    extractedData.forEach((shop) {
      loadedShops.add(ShopItem(
          id: shop["shopId"]["_id"].toString(),
          title: shop["shopId"]["shopName"],
          address: shop["shopId"]["address"],
          cp: shop["shopId"]["owner"],
          telephone: shop["shopId"]["phoneNo"].toString(),
          location: (shop["shopId"]["location"] as List<dynamic>)
              .map((location) => double.parse(location))
              .toList(),
          isCovered: shop["isCovered"]));
    });
    _items = loadedShops;
  }

  List<ShopItem> get items {
    return [..._items];
  }

  Future<void> checkShop(
      String shopId, String sellerId, http.Client client) async {
    // Future<void> checkShop(String shopId, String sellerId) async {
    final shopIndex = _items.indexWhere((shop) => shop.id == shopId);
    final response = await client.patch
        // final response = await http
        //     .patch
        (Uri.parse("$serverIp/api/task/salesperson/checkShop"), body: {
      "sellerId": userId,
      "shopIndex": shopIndex.toString(),
      "isCovered": "true",
    }, headers: {
      "x-access-token": authToken as String
    });
    if (response.statusCode == 200) {
      _items[shopIndex].isCovered = true;
      notifyListeners();
    } else {
      throw Exception('Failed - Check Shop');
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
