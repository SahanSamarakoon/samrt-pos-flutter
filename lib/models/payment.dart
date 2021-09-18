import 'package:flutter/material.dart';

class Payment {
  final String id;
  final String sellerId;
  final String shopId;
  final List<Map> transactions;
  final double total;
  final DateTime dateTime;
  Payment(
      {required this.id,
      required this.sellerId,
      required this.shopId,
      required this.transactions,
      required this.total,
      required this.dateTime});
}

class PaymentsProvider with ChangeNotifier {
  List<Payment> _payments = [];
  List<Payment> get payments {
    return [..._payments];
  }

  void addPayment(
      String sellerId, String shopId, List<Map> transaction, double total) {
    _payments.insert(
        0,
        Payment(
            id: DateTime.now().toString(),
            sellerId: sellerId,
            shopId: shopId,
            transactions: transaction,
            total: total,
            dateTime: DateTime.now()));
    notifyListeners();
  }

  double dailySales() {
    double sales = 0;
    _payments.forEach((element) => {sales += element.total});
    return sales;
  }
}
