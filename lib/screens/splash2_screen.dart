import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_pos/middleware/auth.dart';
import 'package:smart_pos/middleware/locationUpdate.dart';
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
          .fetchAndSetShops(seller!.dailyShops);
      Provider.of<ItemsProvider>(context, listen: false)
          .fetchAndSetItems(seller.dailyInventory);
      Provider.of<PaymentsProvider>(context, listen: false)
          .fetchAndSetPayments(seller.dailySalesProgression);
      Provider.of<LocationUpdate>(context, listen: false).autoUpdate();
      return Future.value(new TabScreen());
    } catch (error) {
      print(error);
      await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text("Error connecting to the server"),
                content: Text(
                    "Please check your internet connectivity and try agin after few seconds."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Provider.of<Auth>(context, listen: false).logout();
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed("/");
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
      loaderColor: Colors.white,
      backgroundColor: Color.fromRGBO(0, 150, 136, 1),
      seconds: 3,
      navigateAfterFuture: loadFromFuture(),
      title: const Text(
        'Smart POS',
        style: TextStyle(
          color: Colors.white,
          fontSize: 60,
          fontFamily: 'Righteous',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
