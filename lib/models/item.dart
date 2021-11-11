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
  final String? serverIp;
  // http.Client client;
  ItemsProvider(this.serverIp, this.userId, this.authToken, this._items);
  // ItemsProvider(
  //     this.serverIp, this.userId, this.authToken, this._items, this.client);

  void fetchAndSetItems(List<dynamic> extractedData) {
    final List<Item> loadedItems = [];
    extractedData.forEach((item) {
      loadedItems.add(Item(
        id: item["productId"]["_id"],
        name: item["productId"]["itemName"],
        price: item["productId"]["unitPrice"].toDouble(),
        quantity: item["quantity"],
      ));
    });
    _items = loadedItems;
  }

  List<Item> get items {
    return [..._items];
  }

  // Item getItem(String itemId) {
  //   Item neededItem = _items.firstWhere((element) => element.id == itemId);
  //   return neededItem;
  // }

  int remainingItems() {
    int number = 0;
    items.forEach((element) => {number += element.quantity});
    return number;
  }

  // Future<void> updateQuantity(
  //     List<Map> itemsToModify, String sellerId, http.Client client) async {
  Future<void> updateQuantity(List<Map> itemsToModify, String sellerId) async {
    try {
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
          final response = await http.patch(
              // final response = await client.patch(
              Uri.parse("$serverIp/api/task/salesperson/updateInventory"),
              body: {
                "sellerId": userId,
                "itemIndex": neededItemIndex.toString(),
                "quantity": finalQnt.toString(),
              },
              headers: {
                "x-access-token": authToken as String
              });

          if (response.statusCode == 200) {
            _items[neededItemIndex].quantity = finalQnt;
            notifyListeners();
          } else {
            throw Exception('Failed - Update Quantity');
          }
        }
      });
    } catch (error) {
      throw Exception(error);
    }
  }

  Item findById(String itemId) {
    try {
      return _items.firstWhere((item) => item.id == itemId);
    } catch (error) {
      throw new Exception("No item found");
    }
  }

  int getItemReamingQnt(String itemId) {
    final item = _items.firstWhere((item) => item.id == itemId);
    return item.quantity;
  }
}
