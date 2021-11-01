import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:smart_pos/models/item.dart';
import 'package:smart_pos/models/salesperson.dart';
import 'package:smart_pos/models/shop.dart';
import 'package:smart_pos/screens/maps_screen.dart';
import 'package:smart_pos/widgets/dialy_goal_progression__widget.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = "/dashboard";
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final shopCount = Provider.of<ShopsProvider>(context).uncoveredShops();
    final itemCount = Provider.of<ItemsProvider>(context).remainingItems();
    final seller =
        Provider.of<SalesPersonProvider>(context, listen: false).person;
    final formatter = NumberFormat('###,##0.00');
    final mediaQuery = MediaQuery.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, ${seller!.firstName} ${seller.lastName}",
                      key: Key("greetingText"),
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    Row(
                      children: [
                        const Text(
                          "Daily Sales Target  ",
                          key: Key("salesTargetText"),
                          style: TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87),
                        ),
                        Chip(
                          label: Text(
                            formatter.format(seller.dailySalesTarget) + " LKR",
                            key: Key("targetAmount"),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    )
                  ]),
            ),
          ],
        ),
        Container(
            width: (mediaQuery.size.height - mediaQuery.padding.top) * 0.3125,
            height: (mediaQuery.size.height - mediaQuery.padding.top) * 0.3125,
            child: DialyGoalProgress()),
        Container(
          padding: const EdgeInsets.only(top: 15),
          child: OutlinedButton(
            key: Key("showRouteButton"),
            child: RichText(
              text: TextSpan(
                children: [
                  const WidgetSpan(
                    child: const Icon(Icons.map, size: 18),
                  ),
                  TextSpan(
                    text: " Show Route",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, MapsScreen.routeName);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Card(
              margin: EdgeInsets.symmetric(vertical: 15),
              key: Key("shopsProgression"),
              child: InkWell(
                child: SizedBox(
                  width: (mediaQuery.size.width) * 0.45,
                  height:
                      (mediaQuery.size.height - mediaQuery.padding.top) * 0.17,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Shops Progression',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const Divider(),
                        Text('$shopCount',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25)),
                        const Text("Shops left")
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 15),
              key: Key("inventoryProgression"),
              child: InkWell(
                child: SizedBox(
                  width: (mediaQuery.size.width) * 0.45,
                  height:
                      (mediaQuery.size.height - mediaQuery.padding.top) * 0.17,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Inventory Progression',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const Divider(),
                        Text('$itemCount',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25)),
                        const Text("Items left")
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
