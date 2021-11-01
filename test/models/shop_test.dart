// ignore_for_file: non_constant_identifier_names

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_pos/models/shop.dart';

import 'server.mocks.dart';

//Mock Server requests/respones
final SERVER_IP = 'http://10.0.2.2:3000';
final ShopsProvider mockShopsProvider =
    ShopsProvider(SERVER_IP, mockUserId, mockAuthToken, []);
final String mockUserId = "614f8d020c645489164c376d";
final mockAuthToken =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYxNGY4ZDAyMGM2NDU0ODkxNjRjMzc2ZCIsImlhdCI6MTYzMzEyNTIzMCwiZXhwIjoxNjMzMjExNjMwfQ.m9JLztIX0jpFHhAkgrOYbuBiIeSxa8EITBiqfX43cw4";
final List<dynamic> mockShopList = [
  {
    "isCovered": true,
    "shopId": {
      "location": ["6.795074327733778", "79.90080262368436"],
      "_id": "61673501f10633a591268164",
      "address": "A address",
      "shopName": "A Store",
      "owner": "Mr. A Owner",
      "phoneNo": 111111111,
      "email": "xprnypnblck@gmail.com",
      "city": "Moratuwa",
      "route": "6167196af10633a59126815c"
    }
  },
  {
    "isCovered": false,
    "shopId": {
      "location": ["6.795841377219869", "79.88783682536616"],
      "_id": "6167364cf10633a59126816a",
      "address": "B address",
      "shopName": "B Store",
      "owner": "Mr. B Owner",
      "phoneNo": 111111112,
      "email": "xprnypnblck@gmail.com",
      "city": "Moratuwa",
      "route": "6167196af10633a59126815c"
    }
  },
  {
    "isCovered": false,
    "shopId": {
      "location": ["6.798637901355828", "79.88874341196359"],
      "_id": "617316798f40637612bac4ca",
      "address": "C address",
      "shopName": "C Store",
      "owner": "Mr. C Owner",
      "phoneNo": 111111113,
      "email": "xprnypnblck@gmail.com",
      "city": "Moratuwa",
      "route": "6167196af10633a59126815c"
    }
  },
  {
    "isCovered": false,
    "shopId": {
      "location": ["6.793393905101009", "79.88697430696742"],
      "_id": "61673700f10633a59126816e",
      "address": "D address",
      "shopName": "D Store",
      "owner": "Mr. D Owner",
      "phoneNo": 111111114,
      "email": "xprnypnblck@gmail.com",
      "city": "Moratuwa",
      "route": "6167196af10633a59126815c"
    }
  }
];
@GenerateMocks([http.Client])
void main() {
  mockShopsProvider.fetchAndSetShops(mockShopList);
  group('Fetch And Set Shops - ', () {
    var mockShopId = "61673700f10633a59126816e";
    test('Returns a List of Shop Items if completes successfully', () async {
      expect(mockShopsProvider.items, isA<List<ShopItem>>());
    });

    test('Returns a Shop Item if completes successfully', () {
      expect(mockShopsProvider.findById(mockShopId), isA<ShopItem>());
    });

    test('Returns a integer if completes successfully', () {
      expect(mockShopsProvider.uncoveredShops(), isA<int>());
    });

    test('Returns a List of locations if completes successfully', () {
      expect(mockShopsProvider.getShopLocations(), isA<List<List>>());
    });
  });
  group('Check Shop - ', () {
    final client = MockClient();
    var mockShopId = "61673700f10633a59126816e";
    var mockShopIndex = 3;
    test('Returns true if a shop checked completes successfully', () async {
      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client
          .patch(Uri.parse("$SERVER_IP/api/task/salesperson/checkShop"), body: {
        "sellerId": mockUserId,
        "shopIndex": mockShopIndex.toString(),
        "isCovered": "true",
      }, headers: {
        "x-access-token": mockAuthToken
      })).thenAnswer((_) async => http.Response("Done", 200));
      await mockShopsProvider.checkShop(mockShopId, mockUserId, client);
      expect(mockShopsProvider.findById(mockShopId).isCovered, true);
    });

    test('Throws an exception if the http call completes with an error', () {
      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client
          .patch(Uri.parse("$SERVER_IP/api/task/salesperson/checkShop"), body: {
        "sellerId": mockUserId,
        "shopIndex": mockShopIndex.toString(),
        "isCovered": "true",
      }, headers: {
        "x-access-token": mockAuthToken
      })).thenAnswer((_) async => http.Response("Error", 500));

      expect(mockShopsProvider.checkShop(mockShopId, mockUserId, client),
          throwsException);
    });
  });
}
