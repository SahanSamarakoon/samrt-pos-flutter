import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SalesPerson {
  final String id;
  final String name;
  final Map<String, dynamic> dailyRoute;
  final List<Map> dailyShops;
  final double dailySalesTarget;
  final double dailySalesProgression;
  final List<Map> dailySales;
  final List<Map> dailyInventory;
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
  late final seller;

  Future<void> fetchAndSetSalesperson() async {
    var url = Uri.parse(
        'https://smart-pos-b9bdb-default-rtdb.asia-southeast1.firebasedatabase.app/salesperson.json');

    try {
      final response = await http.get(url);
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
            dailyShops: (sellerData["dailyShops"] as List<dynamic>)
                .map((shop) => shop as Map)
                .toList(),
            dailySalesTarget: sellerData["dailySalesTarget"].toDouble(),
            dailySalesProgression:
                sellerData["dailySalesProgression"].toDouble(),
            dailySales: [],
            dailyInventory: (sellerData["dailyInventory"] as List<dynamic>)
                .map((inventory) => inventory as Map)
                .toList());
      });
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  SalesPerson get person {
    return seller;
  }

  // SalesPerson seller = new SalesPerson(
  //     id: "001",
  //     name: "Sahan",
  //     dailyRoute: {
  //       "SOURCE_LOCATION": [6.797432747855229, 79.88881319239222],
  //       "DEST_LOCATION": [6.7949617004984875, 79.90075531945777]
  //     },
  //     dailyShops: [
  //       {
  //         "id": "001",
  //         "title": "A Store",
  //         "address": "A address",
  //         "cp": "Mr. A Owner",
  //         "telephone": "0111111111",
  //         "location": [6.795074327733778, 79.90080262368436],
  //         "isCovered": false
  //       },
  //       {
  //         "id": "002",
  //         "title": "B Store",
  //         "address": "B address",
  //         "cp": "Mr. B Owner",
  //         "telephone": "0111111112",
  //         "location": [6.795841377219869, 79.88783682536616],
  //         "isCovered": false
  //       },
  //       {
  //         "id": "003",
  //         "title": "C Store",
  //         "address": "C address",
  //         "cp": "Mr. C Owner",
  //         "telephone": "0111111113",
  //         "location": [6.798637901355828, 79.88874341196359],
  //         "isCovered": false
  //       },
  //       {
  //         "id": "004",
  //         "title": "D Store",
  //         "address": "D address",
  //         "cp": "Mr. D Owner",
  //         "telephone": "0111111114",
  //         "location": [6.793393905101009, 79.88697430696742],
  //         "isCovered": false
  //       }
  //     ],
  //     dailySalesTarget: 5000.00,
  //     dailySalesProgression: 0.00,
  //     dailySales: [],
  //     dailyInventory: [
  //       {
  //         "id": "001",
  //         "name": "A Item",
  //         "price": 100.00,
  //         "quantity": 100,
  //       },
  //       {
  //         "id": "002",
  //         "name": "B Item",
  //         "price": 200.00,
  //         "quantity": 50,
  //       },
  //       {
  //         "id": "003",
  //         "name": "C Item",
  //         "price": 50.00,
  //         "quantity": 25,
  //       },
  //       {
  //         "id": "004",
  //         "name": "D Item",
  //         "price": 150.00,
  //         "quantity": 150,
  //       }
  //     ]);

  // Future<void> addPerson() async {
  //   var url = Uri.parse(
  //       'https://smart-pos-b9bdb-default-rtdb.asia-southeast1.firebasedatabase.app/salesperson.json');
  //   final response = await http.post(url,
  //       body: json.encode({
  //edited id  = sellerID firebase
  //         "id": "001",
  //         "name": "Sahan",
  //         "dailyRoute": {
  //           "SOURCE_LOCATION": [6.797432747855229, 79.88881319239222],
  //           "DEST_LOCATION": [6.7949617004984875, 79.90075531945777]
  //         },
  //         "dailyShops": [
  //           {
  //             "id": "001",
  //             "title": "A Store",
  //             "address": "A address",
  //             "cp": "Mr. A Owner",
  //             "telephone": "0111111111",
  //             "location": [6.795074327733778, 79.90080262368436],
  //             "isCovered": false
  //           },
  //           {
  //             "id": "002",
  //             "title": "B Store",
  //             "address": "B address",
  //             "cp": "Mr. B Owner",
  //             "telephone": "0111111112",
  //             "location": [6.795841377219869, 79.88783682536616],
  //             "isCovered": false
  //           },
  //           {
  //             "id": "003",
  //             "title": "C Store",
  //             "address": "C address",
  //             "cp": "Mr. C Owner",
  //             "telephone": "0111111113",
  //             "location": [6.798637901355828, 79.88874341196359],
  //             "isCovered": false
  //           },
  //           {
  //             "id": "004",
  //             "title": "D Store",
  //             "address": "D address",
  //             "cp": "Mr. D Owner",
  //             "telephone": "0111111114",
  //             "location": [6.793393905101009, 79.88697430696742],
  //             "isCovered": false
  //           }
  //         ],
  //         "dailySalesTarget": 5000.00,
  //         "dailySalesProgression": 0.00,
  //         "dailySales": [],
  //         "dailyInventory": [
  //           {
  //             "id": "001",
  //             "name": "A Item",
  //             "price": 100.00,
  //             "quantity": 100,
  //           },
  //           {
  //             "id": "002",
  //             "name": "B Item",
  //             "price": 200.00,
  //             "quantity": 50,
  //           },
  //           {
  //             "id": "003",
  //             "name": "C Item",
  //             "price": 50.00,
  //             "quantity": 25,
  //           },
  //           {
  //             "id": "004",
  //             "name": "D Item",
  //             "price": 150.00,
  //             "quantity": 150,
  //           }
  //         ]
  //       }));
  //   // final newProduct = Product(
  //   //     id: jsonDecode(response.body)["name"],
  //   //     title: product.title,
  //   //     description: product.description,
  //   //     price: product.price,
  //   //     imageUrl: product.imageUrl);
  //   // _items.add(newProduct);
  //   // notifyListeners();
  // }
}
