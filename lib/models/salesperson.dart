import 'package:flutter/material.dart';

class SalesPerson {
  final String id;
  final String name;
  final double dialySalesTarget;
  SalesPerson({
    required this.id,
    required this.name,
    required this.dialySalesTarget,
  });
}

class SalesPersonProvider with ChangeNotifier {
  SalesPerson seller = new SalesPerson(
    id: "01",
    name: "Sahan",
    dialySalesTarget: 500.00,
  );

  SalesPerson get person {
    return seller;
  }
}
