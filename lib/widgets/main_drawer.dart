import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_pos/models/salesperson.dart';
import 'package:smart_pos/screens/auth_screen.dart';
import 'package:smart_pos/screens/sales_screen.dart';
import 'package:smart_pos/screens/tabs_screen.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final seller =
        Provider.of<SalesPersonProvider>(context, listen: false).person;
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Hello, ${seller.name}"),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              Navigator.of(context).popAndPushNamed(TabScreen.routeName);
              // Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.money),
            title: const Text("Sales"),
            onTap: () {
              Navigator.of(context).popAndPushNamed(SalesScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              Navigator.of(context).popAndPushNamed(AuthScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
