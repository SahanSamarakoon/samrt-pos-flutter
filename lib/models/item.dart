import 'package:flutter/material.dart';

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
  List<Item> _items = [
    Item(
      id: "001",
      name: "A Item",
      price: 100.00,
      quantity: 100,
    ),
    Item(
      id: "002",
      name: "B Item",
      price: 200.00,
      quantity: 50,
    ),
    Item(
      id: "003",
      name: "C Item",
      price: 50.00,
      quantity: 20,
    ),
    Item(
      id: "004",
      name: "D Item",
      price: 150.00,
      quantity: 150,
    ),
  ];

  List<Item> get items {
    return [..._items];
  }

  void updateList() {
    _items[3] = Item(
      id: "024",
      name: "D Item",
      price: 15.00,
      quantity: 15,
    );
    notifyListeners();
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

  void updateQuantity(List<Map> itemsToModify) {
    int neededItemIndex;
    itemsToModify.forEach((itemTM) => {
          neededItemIndex =
              _items.indexWhere((item) => item.id == itemTM["id"]),
          if (neededItemIndex >= 0)
            {_items[neededItemIndex].quantity -= itemTM["quantity"] as int}
        });

    notifyListeners();
  }
}
