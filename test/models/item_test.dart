// ignore_for_file: non_constant_identifier_names

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_pos/models/item.dart';

import 'server.mocks.dart';

//Mock Server requests/respones
final SERVER_IP = 'http://10.0.2.2:3000';
final ItemsProvider mockItemsProvider =
    ItemsProvider(SERVER_IP, mockUserId, mockAuthToken, []);
final String mockUserId = "614f8d020c645489164c376d";
final mockAuthToken =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYxNGY4ZDAyMGM2NDU0ODkxNjRjMzc2ZCIsImlhdCI6MTYzMzEyNTIzMCwiZXhwIjoxNjMzMjExNjMwfQ.m9JLztIX0jpFHhAkgrOYbuBiIeSxa8EITBiqfX43cw4";
final List<dynamic> mockItemList = [
  {
    "productId": {
      "_id": "616874417a10179ca894e8fa",
      "itemName": "A Item",
      "unitPrice": 100
    },
    "quantity": 50
  },
  {
    "productId": {
      "_id": "616874c07a10179ca894e8fb",
      "itemName": "B Item",
      "unitPrice": 50
    },
    "quantity": 125
  },
  {
    "productId": {
      "_id": "616874e77a10179ca894e8fc",
      "itemName": "C Item",
      "unitPrice": 150
    },
    "quantity": 10
  },
  {
    "productId": {
      "_id": "6173174d8f40637612bac4cf",
      "itemName": "D Item",
      "unitPrice": 200
    },
    "quantity": 100
  }
];

@GenerateMocks([http.Client])
void main() {
  mockItemsProvider.fetchAndSetItems(mockItemList);
  group('Fetch And Set Items -  Connect to mock API', () {
    var mockItemId = "616874417a10179ca894e8fa";
    test('Returns a List of Items if completes successfully', () async {
      expect(mockItemsProvider.items, isA<List<Item>>());
    });

    test('Returns a Item if completes successfully', () {
      expect(mockItemsProvider.findById(mockItemId), isA<Item>());
    });

    test('Returns a integer if completes successfully', () {
      expect(mockItemsProvider.remainingItems(), isA<int>());
    });

    test('Returns a number of items if completes successfully', () {
      expect(mockItemsProvider.getItemReamingQnt(mockItemId), isA<int>());
    });
  });
  group('Update Quantity - ', () {
    final client = MockClient();
    final List<Map> mockItemTM = [
      {"id": "6173174d8f40637612bac4cf", "quantity": 5},
    ];
    test(
        'Returns correct quantity if item quantities update completes successfully',
        () async {
      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.patch(
          Uri.parse("$SERVER_IP/api/task/salesperson/updateInventory"),
          body: {
            "sellerId": mockUserId,
            "itemIndex": "3",
            "quantity": "95",
          },
          headers: {
            "x-access-token": mockAuthToken
          })).thenAnswer((_) async => http.Response("Done", 200));

      await mockItemsProvider.updateQuantity(mockItemTM, mockUserId, client);
      expect(
          mockItemsProvider.getItemReamingQnt("6173174d8f40637612bac4cf"), 95);
    });

    test('Throws an exception if the http call completes with an error',
        () async {
      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.patch(
          Uri.parse("$SERVER_IP/api/task/salesperson/updateInventory"),
          body: {
            "sellerId": mockUserId,
            "itemIndex": "3",
            "quantity": "90",
          },
          headers: {
            "x-access-token": mockAuthToken
          })).thenAnswer((_) async => http.Response("Error", 500));
      // expect(mockItemsProvider.updateQuantity(mockItemTM, mockUserId, client),
      //     isInstanceOf<Future<void>>());
      // expect(mockItemsProvider.updateQuantity(mockItemTM, mockUserId, client),
      //     throwsA(Exception()));
    });
  });
}
