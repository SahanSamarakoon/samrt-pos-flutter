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
  List<Payment> _payments = [];
  List<Payment> get payments {
    return [..._payments];
  }

  void fetchAndSetPayments(double extractedData) {
    sales = extractedData;
  }

  Future<void> addPayment(String sellerId, String shopId, List<Map> transaction,
      double total) async {
    sales += total;
    _payments.insert(
        0,
        Payment(
            id: DateTime.now().toIso8601String(),
            sellerId: sellerId,
            shopId: shopId,
            transactions: transaction,
            total: total,
            dateTime: DateTime.now().toIso8601String()));
    notifyListeners();
    final urlSalesProgress = Uri.parse(
        'https://smart-pos-b9bdb-default-rtdb.asia-southeast1.firebasedatabase.app/salesperson/$sellerId.json');
    final urlPayment = Uri.parse(
        'https://smart-pos-b9bdb-default-rtdb.asia-southeast1.firebasedatabase.app/payment.json');
    try {
      final responseSalesProgress = await http.patch(urlSalesProgress,
          body: json.encode({
            "dailySalesProgression": sales,
          }));
      final responsePayment = await http.post(urlPayment,
          body: json.encode({
            // "id": DateTime.now().toIso8601String(),
            "sellerId": sellerId,
            "shopId": shopId,
            "transactions": transaction,
            "total": total,
            "dateTime": DateTime.now().toIso8601String(),
          }));
      if (responseSalesProgress.statusCode >= 400 ||
          responsePayment.statusCode >= 400) {
        sales -= total;
        _payments.removeAt(0);
        notifyListeners();
      }
    } catch (error) {
      sales -= total;
      _payments.removeAt(0);
      notifyListeners();
    }
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
