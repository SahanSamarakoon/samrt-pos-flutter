// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_pos/middleware/auth.dart';
import 'package:smart_pos/models/salesperson.dart';
import 'package:smart_pos/screens/auth_screen.dart';
import 'package:smart_pos/screens/sales_screen.dart';
import 'package:smart_pos/screens/tabs_screen.dart';

class MainDrawer extends StatelessWidget {
  Key key;
  MainDrawer(this.key);
  @override
  Widget build(BuildContext context) {
    final seller =
        Provider.of<SalesPersonProvider>(context, listen: false).person;
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Hello, ${seller!.firstName}"),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            key: Key('home'),
            onTap: () {
              Navigator.of(context).popAndPushNamed(TabScreen.routeName);
              // Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.money),
            title: const Text("Sales"),
            key: Key('sales'),
            onTap: () {
              Navigator.of(context).popAndPushNamed(SalesScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            key: Key('logout'),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => AuthScreen()),
                ModalRoute.withName('/'),
              );
            },
          ),
        ],
      ),
    );
  }
}
