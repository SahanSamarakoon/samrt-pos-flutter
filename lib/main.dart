import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_pos/models/item.dart';
import 'package:smart_pos/models/payment.dart';
import 'package:smart_pos/models/salesperson.dart';
import 'package:smart_pos/models/shop.dart';
import 'package:smart_pos/screens/inventory_screen.dart';
import 'package:smart_pos/screens/maps_screen.dart';
import 'package:smart_pos/screens/payment_screen.dart';
import 'package:smart_pos/screens/sales_screen.dart';
import 'package:smart_pos/screens/shop_detail_screen.dart';
import 'package:smart_pos/screens/shops_screen.dart';
import 'package:smart_pos/screens/tabs_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => ShopsProvider()),
          ChangeNotifierProvider(create: (ctx) => ItemsProvider()),
          ChangeNotifierProvider(create: (ctx) => PaymentsProvider()),
          ChangeNotifierProvider(create: (ctx) => SalesPersonProvider()),
        ],
        child: MaterialApp(
          title: 'Smart POS',
          theme: ThemeData(
            primarySwatch: Colors.teal,
          ),
          routes: {
            "/": (ctx) => TabScreen(),
            InventoryScreen.routeName: (ctx) => InventoryScreen(),
            ShopsScreen.routeName: (ctx) => ShopsScreen(),
            MapsScreen.routeName: (ctx) => MapsScreen(),
            ShopDetailScreen.routeName: (ctx) => ShopDetailScreen(),
            PaymentScreen.routeName: (ctx) => PaymentScreen(),
            SalesScreen.routeName: (ctx) => SalesScreen(),
          },
        ));
  }
}
