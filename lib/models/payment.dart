// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Payment {
  final String id;
  final String sellerId;
  final String shopId;
  final String shopName;
  final List<Map> transactions;
  final double total;
  final String dateTime;
  final bool isOnline;
  Payment(
      {required this.id,
      required this.sellerId,
      required this.shopId,
      required this.shopName,
      required this.transactions,
      required this.total,
      required this.dateTime,
      required this.isOnline});
}

class PaymentsProvider with ChangeNotifier {
  double sales = 0;
  final String? userId;
  final String? authToken;
  final String? serverIp;
  List<Payment> _payments = [];
  // http.Client client;

  PaymentsProvider(this.serverIp, this.userId, this.authToken, this._payments);
  // PaymentsProvider(
  //     this.serverIp, this.userId, this.authToken, this._payments, this.client);

  List<Payment> get payments {
    return [..._payments.reversed];
  }

  // Future<void> fetchAndSetPayments(
  //     double extractedData, http.Client client) async {
  Future<void> fetchAndSetPayments(double extractedData) async {
    _payments = [];
    sales = extractedData;
    final response = await http.post
        // final response = await client.post
        (Uri.parse("$serverIp/api/task/payments"),
            body: {"sellerId": userId},
            headers: {"x-access-token": authToken as String});

    if (response.statusCode == 200) {
      final paymentData = json.decode(response.body) as List<dynamic>;
      if (paymentData == null) {
        throw Exception('Failed - Null Payments');
      }
      paymentData.forEach((payment) {
        _payments.add(new Payment(
          id: payment["_id"].toString(),
          sellerId: payment["sellerId"].toString(),
          shopId: payment["shopId"]["_id"].toString(),
          shopName: payment["shopId"]["shopName"].toString(),
          total: payment["total"].toDouble(),
          dateTime: payment["dateTime"].toString(),
          isOnline: payment["isOnline"],
          transactions: (payment["transactions"] as List<dynamic>)
              .map((transaction) => transaction as Map)
              .toList(),
        ));
      });
      notifyListeners();
    } else {
      throw Exception('Failed - Fetch Payments');
    }
  }

// DateTime mockDateTime
  // Future<void> addPayment(
  //     String sellerId,
  //     String shopId,
  //     List<Map> transaction,
  //     double total,
  //     bool isOnline,
  //     http.Client client,
  //     DateTime mockDateTime) async {
  Future<void> addPayment(
    String sellerId,
    String shopId,
    List<Map> transaction,
    double total,
    bool isOnline,
  ) async {
    final responseSalesProgress = await http.patch(
        // final responseSalesProgress = await client.patch(
        Uri.parse("$serverIp/api/task/salesperson/updateSalesProgress"),
        body: {
          "sellerId": userId,
          "dailySalesProgression": (sales + total).toString(),
        },
        headers: {
          "x-access-token": authToken as String
        });

    final responsePayment = await http.post
        // final responsePayment = await client.post
        (Uri.parse("$serverIp/api/task/salesperson/addPayment"), body: {
      "sellerId": userId,
      "shopId": shopId,
      "total": total.toString(),
      // "dateTime": mockDateTime.toIso8601String(),
      "dateTime": DateTime.now().toIso8601String(),
      "isOnline": isOnline.toString(),
      "transactions": jsonEncode(transaction),
    }, headers: {
      "x-access-token": authToken as String
    });

    if (responseSalesProgress.statusCode == 200 ||
        responsePayment.statusCode == 200) {
      sales += total;
      await fetchAndSetPayments(sales);
      notifyListeners();
    } else {
      throw Exception('Failed - Add Payments || SalesProgress');
    }
  }

  double dailySales() {
    return sales;
  }

  double moneyInTheHand() {
    double money = 0.0;
    _payments.forEach((element) {
      if (element.isOnline == false) {
        money += element.total;
      }
    });
    return money;
  }
}
