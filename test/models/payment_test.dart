// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_pos/models/payment.dart';

import 'server.mocks.dart';

//Mock Server requests/respones
final SERVER_IP = 'http://10.0.2.2:3000';
final String mockUserId = "61671c22346f6b3724faef50";
final mockAuthToken =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYxNGY4ZDAyMGM2NDU0ODkxNjRjMzc2ZCIsImlhdCI6MTYzMzEyNTIzMCwiZXhwIjoxNjMzMjExNjMwfQ.m9JLztIX0jpFHhAkgrOYbuBiIeSxa8EITBiqfX43cw4";
final String mockPaymentList =
    '[{"_id":"616da296d9f30137446e8548","sellerId":"61671c22346f6b3724faef50","shopId":{"_id":"61673501f10633a591268164","shopName":"A Store"},"total":550,"dateTime":"2021-10-23T16:36:37.850Z","transactions":[{"id":{"_id":"616874417a10179ca894e8fa","itemName":"A Item","unitPrice":100},"quantity":1},{"id":{"_id":"616874c07a10179ca894e8fb","itemName":"B Item","unitPrice":50},"quantity":1},{"id":{"_id":"616874e77a10179ca894e8fc","itemName":"C Item","unitPrice":150},"quantity":1}],"isOnline":false,"__v":0}]';
@GenerateMocks([http.Client])
void main() {
  group('Fetch And Set Payments - ', () {
    final PaymentsProvider mockPaymentsProvider =
        PaymentsProvider(SERVER_IP, mockUserId, mockAuthToken, []);
    final client = MockClient();
    test(
        'Returns a List of Payments and double for dailySales if completes successfully',
        () async {
      when(client.post(Uri.parse("$SERVER_IP/api/task/payments"),
              body: {"sellerId": mockUserId},
              headers: {"x-access-token": mockAuthToken}))
          .thenAnswer((_) async => http.Response(mockPaymentList, 200));
      await mockPaymentsProvider.fetchAndSetPayments(1500.00, client);
      expect(mockPaymentsProvider.payments, isA<List<Payment>>());
      expect(mockPaymentsProvider.dailySales(), isA<double>());
      expect(mockPaymentsProvider.dailySales(), 1500.00);
      expect(mockPaymentsProvider.moneyInTheHand(), isA<double>());
      expect(mockPaymentsProvider.dailySales(), 1500.00);
    });
    test('Throws an exception if the http call completes with an error', () {
      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.post(Uri.parse("$SERVER_IP/api/task/payments"),
              body: {"sellerId": mockUserId},
              headers: {"x-access-token": mockAuthToken}))
          .thenAnswer((_) async => http.Response("Error", 500));

      expect(mockPaymentsProvider.fetchAndSetPayments(1500.00, client),
          throwsException);
    });
  });
  group('Make Payment - ', () {
    final client = MockClient();
    final PaymentsProvider mockPaymentsProvider =
        PaymentsProvider(SERVER_IP, mockUserId, mockAuthToken, []);
    final String mockShopId = "61673700f10633a59126816e";
    final List<Map> mockTransaction = [{}];
    final double mockTotal = 500.00;
    final double mockSales = 00.00;
    final bool mockIsOnline = true;
    final DateTime mockDateTime = DateTime.now();
    test('Returns mockSales+mockTotal if completes successfully', () async {
      // Use Mockito to return a successful response when it calls the
      // provided http.Client.

      when(client.patch(
          Uri.parse("$SERVER_IP/api/task/salesperson/updateSalesProgress"),
          body: {
            "sellerId": mockUserId,
            "dailySalesProgression": (mockTotal + mockSales).toString(),
          },
          headers: {
            "x-access-token": mockAuthToken
          })).thenAnswer((_) async => http.Response("Done", 200));

      when(client
          .post(Uri.parse("$SERVER_IP/api/task/salesperson/addPayment"), body: {
        "sellerId": mockUserId,
        "shopId": mockShopId,
        "total": mockTotal.toString(),
        "dateTime": mockDateTime.toIso8601String(),
        "isOnline": mockIsOnline.toString(),
        "transactions": jsonEncode(mockTransaction),
      }, headers: {
        "x-access-token": mockAuthToken
      })).thenAnswer((_) async => http.Response("Done", 200));

      await mockPaymentsProvider.addPayment(mockUserId, mockShopId,
          mockTransaction, mockTotal, mockIsOnline, client, mockDateTime);
      expect(mockPaymentsProvider.dailySales(), mockSales + mockTotal);
    });

    test('Throws an exception if the http call completes with an error', () {
      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.patch(
          Uri.parse("$SERVER_IP/api/task/salesperson/updateSalesProgress"),
          body: {
            "sellerId": mockUserId,
            "dailySalesProgression": (mockSales + mockTotal * 2).toString(),
          },
          headers: {
            "x-access-token": mockAuthToken
          })).thenAnswer((_) async => http.Response("Error", 500));

      when(client
          .post(Uri.parse("$SERVER_IP/api/task/salesperson/addPayment"), body: {
        "sellerId": mockUserId,
        "shopId": mockShopId,
        "total": mockTotal.toString(),
        "dateTime": mockDateTime.toIso8601String(),
        "isOnline": mockIsOnline.toString(),
        "transactions": jsonEncode(mockTransaction),
      }, headers: {
        "x-access-token": mockAuthToken
      })).thenAnswer((_) async => http.Response("Error", 500));

      expect(
          mockPaymentsProvider.addPayment(mockUserId, mockShopId,
              mockTransaction, mockTotal, mockIsOnline, client, mockDateTime),
          throwsException);
    });
  });
}
