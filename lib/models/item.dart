import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Item {
  final String id;
  final String name;
  final double price;
  int quantity;
  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });
}

class ItemsProvider with ChangeNotifier {
  List<Item> _items = [];

  void fetchAndSetItems(List<Map> extractedData) {
    final List<Item> loadedItems = [];
    extractedData.forEach((itemExtract) {
      loadedItems.add(Item(
        id: itemExtract["id"],
        name: itemExtract["name"],
        price: itemExtract["price"].toDouble(),
        quantity: itemExtract["quantity"],
      ));
    });
    _items = loadedItems;
  }

  List<Item> get items {
    return [..._items];
  }

  Item getItem(String itemId) {
    Item neededItem = _items.firstWhere((element) => element.id == itemId);
    return neededItem;
  }

  int remainingItems() {
    int number = 0;
    items.forEach((element) => {number += element.quantity});
    return number;
  }

  Future<void> updateQuantity(List<Map> itemsToModify, String sellerId) async {
    int neededItemIndex;
    int stockQnt;
    int modifyQnt;
    int finalQnt;
    var url;
    itemsToModify.forEach((itemTM) async {
      neededItemIndex = _items.indexWhere((item) => item.id == itemTM["id"]);
      if (neededItemIndex >= 0) {
        stockQnt = _items[neededItemIndex].quantity;
        modifyQnt = itemTM["quantity"] as int;
        finalQnt = stockQnt - modifyQnt;
        _items[neededItemIndex].quantity -= itemTM["quantity"] as int;
        notifyListeners();
        url = Uri.parse(
            'https://smart-pos-b9bdb-default-rtdb.asia-southeast1.firebasedatabase.app/salesperson/$sellerId/dailyInventory/$neededItemIndex.json');
        try {
          final response = await http.patch(url,
              body: json.encode({
                "quantity": finalQnt,
              }));
          if (response.statusCode >= 400) {
            _items[neededItemIndex].quantity = stockQnt;
            notifyListeners();
          }
        } catch (error) {
          _items[neededItemIndex].quantity = stockQnt;
          notifyListeners();
        }
      }
    });
  }

  Item findById(String itemId) {
    return _items.firstWhere((item) => item.id == itemId);
  }

  int getItemReamingQnt(String itemId) {
    final item = _items.firstWhere((item) => item.id == itemId);
    return item.quantity;
  }
}
