// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Payment {
  final String id;
  final String sellerId;
  final String shopId;
  final List<Map> transactions;
  final double total;
  final String dateTime;
  Payment(
      {required this.id,
      required this.sellerId,
      required this.shopId,
      required this.transactions,
      required this.total,
      required this.dateTime});
}

class PaymentsProvider with ChangeNotifier {
  double sales = 0;
  final String? userId;
  final String? authToken;
  List<Payment> _payments = [];

  final SERVER_IP = 'http://10.0.2.2:3000';

  PaymentsProvider(this.userId, this.authToken, this._payments);

  List<Payment> get payments {
    return [..._payments.reversed];
  }

  Future<void> fetchAndSetPayments(double extractedData) async {
    _payments = [];
    sales = extractedData;
    try {
      final response = await http.post(
          Uri.parse("$SERVER_IP/api/task/payments"),
          body: {"sellerId": userId},
          headers: {"x-access-token": authToken as String});
      final paymentData = json.decode(response.body) as List<dynamic>;

      // ignore: unnecessary_null_comparison
      if (paymentData == null) {
        return;
      }
      paymentData.forEach((payment) {
        _payments.add(new Payment(
          id: payment["_id"].toString(),
          sellerId: payment["sellerId"].toString(),
          shopId: payment["shopId"].toString(),
          total: payment["total"].toDouble(),
          dateTime: payment["dateTime"].toString(),
          transactions: (payment["transactions"] as List<dynamic>)
              .map((transaction) => transaction as Map)
              .toList(),
        ));
      });
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addPayment(String sellerId, String shopId, List<Map> transaction,
      double total, bool isOnline) async {
    sales += total;
    try {
      final responseSalesProgress = await http.patch(
          Uri.parse("$SERVER_IP/api/task/salesperson/updateSalesProgress"),
          body: {
            "sellerId": userId,
            "dailySalesProgression": sales.toString(),
          },
          headers: {
            "x-access-token": authToken as String
          });
      final responsePayment = await http
          .post(Uri.parse("$SERVER_IP/api/task/salesperson/addPayment"), body: {
        "sellerId": userId,
        "shopId": shopId,
        "total": total.toString(),
        "dateTime": DateTime.now().toIso8601String(),
        "dailySalesProgression": sales.toString(),
        "isOnline": isOnline.toString(),
        "transactions": jsonEncode(transaction),
      }, headers: {
        "x-access-token": authToken as String
      });

      if (responseSalesProgress.statusCode >= 400 ||
          responsePayment.statusCode >= 400) {
        sales -= total;
        // _payments.removeAt(0);
        notifyListeners();
      }
    } catch (error) {
      print(error);
      sales -= total;
      // _payments.removeAt(0);
      notifyListeners();
    }
    await fetchAndSetPayments(sales);
    notifyListeners();
  }

  double dailySales() {
    return sales;
  }
}

// Future<void> addPerson() async {
  //   var url = Uri.parse(
  //       'https://smart-pos-b9bdb-default-rtdb.asia-southeast1.firebasedatabase.app/salesperson.json');
  //   final response = await http.post(url,
  //       body: json.encode({
  // edited id  = sellerID firebase
  //   final newProduct = Product(
  //       id: jsonDecode(response.body)["name"],
  //       title: product.title,
  //       description: product.description,
  //       price: product.price,
  //       imageUrl: product.imageUrl);
    // _items.add(newProduct);
    // notifyListeners();
  // }
