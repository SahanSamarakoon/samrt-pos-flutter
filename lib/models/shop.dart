import 'package:flutter/material.dart';

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
      this.isCovered = false});
}

class ShopsProvider with ChangeNotifier {
  List<ShopItem> _items = [
    ShopItem(
        id: "001",
        title: "A Store",
        address: "A address",
        cp: "Mr. A Owner",
        telephone: "0111111111",
        location: [6.795074327733778, 79.90080262368436]),
    ShopItem(
        id: "002",
        title: "B Store",
        address: "B address",
        cp: "Mr. B Owner",
        telephone: "0111111112",
        location: [6.795841377219869, 79.88783682536616]),
    ShopItem(
        id: "003",
        title: "C Store",
        address: "C address",
        cp: "Mr. C Owner",
        telephone: "0111111113",
        location: [6.798637901355828, 79.88874341196359]),
    ShopItem(
        id: "004",
        title: "D Store",
        address: "D address",
        cp: "Mr. D Owner",
        telephone: "0111111114",
        location: [6.793393905101009, 79.88697430696742]),
  ];
  List<ShopItem> get items {
    return [..._items];
  }

  void checkShop(String id) {
    final shopIndex = _items.indexWhere((shop) => shop.id == id);
    _items[shopIndex].isCovered = true;
    notifyListeners();
  }

  ShopItem findById(String shopId) {
    return _items.firstWhere((shop) => shop.id == shopId);
  }

  int uncoveredShops() {
    int number = items.where((e) => e.isCovered == false).length;
    return number;
  }
}
