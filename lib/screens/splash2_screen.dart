import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_pos/models/item.dart';
import 'package:smart_pos/models/payment.dart';
import 'package:smart_pos/models/salesperson.dart';
import 'package:smart_pos/models/shop.dart';
import 'package:smart_pos/screens/tabs_screen.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future<Widget> loadFromFuture() async {
    try {
      await Provider.of<SalesPersonProvider>(context, listen: false)
          .fetchAndSetSalesperson();
      final seller =
          Provider.of<SalesPersonProvider>(context, listen: false).person;
      Provider.of<ShopsProvider>(context, listen: false)
          .fetchAndSetProducts(seller.dailyShops);
      Provider.of<ItemsProvider>(context, listen: false)
          .fetchAndSetItems(seller.dailyInventory);
      Provider.of<PaymentsProvider>(context, listen: false)
          .fetchAndSetPayments(seller.dailySalesProgression);
      return Future.value(new TabScreen());
    } catch (error) {
      await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text("Error connecting to the server"),
                content: Text(
                    "Please check your internet connectivity and try agin after few seconds."),
                actions: [
                  TextButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: Text("OK"))
                ],
              ));
      return Future.error(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterFuture: loadFromFuture(),
      title: const Text(
        'Smart POS',
        textScaleFactor: 4,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
      ),
      // image: new Image.network(
      //     'https://www.geeksforgeeks.org/wp-content/uploads/gfg_200X200.png'),
      // photoSize: 100.0,
      loaderColor: Colors.teal,
    );
  }
}
