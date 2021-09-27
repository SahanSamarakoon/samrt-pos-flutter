// ignore_for_file: non_constant_identifier_names
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
  final String? userId;
  final String? authToken;
  final SERVER_IP = 'http://10.0.2.2:3000';
  ItemsProvider(this.userId, this.authToken, this._items);

  void fetchAndSetItems(Map<String, dynamic> extractedData) {
    final List<Item> loadedItems = [];
    extractedData.forEach((itemId, itemExtract) {
      loadedItems.add(Item(
        id: itemId,
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

    itemsToModify.forEach((itemTM) async {
      neededItemIndex = _items.indexWhere((item) => item.id == itemTM["id"]);
      if (neededItemIndex >= 0) {
        stockQnt = _items[neededItemIndex].quantity;
        modifyQnt = itemTM["quantity"] as int;
        finalQnt = stockQnt - modifyQnt;
        _items[neededItemIndex].quantity -= itemTM["quantity"] as int;
        notifyListeners();
        try {
          final response = await http.patch(
              Uri.parse("$SERVER_IP/api/task/salesperson/updateInventory"),
              body: {
                "sellerId": userId,
                "itemId": itemTM["id"],
                "quantity": finalQnt.toString(),
              },
              headers: {
                "x-access-token": authToken as String
              });
          print(response.body);
          if (response.statusCode >= 400) {
            _items[neededItemIndex].quantity = stockQnt;
            notifyListeners();
          }
        } catch (error) {
          print(error);
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
