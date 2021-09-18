import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_pos/models/salesperson.dart';
import 'package:smart_pos/screens/sales_screen.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final seller = Provider.of<SalesPersonProvider>(context).person;
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Hello, ${seller.name}"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.money),
            title: Text("Sales"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(SalesScreen.routeName);
            },
          ),
          Divider(),
          // ListTile(
          //   leading: Icon(Icons.account_balance),
          //   title: Text("Account"),
          //   onTap: () {
          //     // Navigator.of(context)
          //     //     .pushReplacementNamed(Account.routeName);
          //   },
          // ),
          // Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
