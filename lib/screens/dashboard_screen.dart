import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    final seller = Provider.of<SalesPersonProvider>(context).person;
    return SingleChildScrollView(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, ${seller.name}",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Daily sales target : ${seller.dialySalesTarget} LKR",
                      style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          color: Colors.black87),
                    ),
                  ]),
            ),
          ],
        ),
        Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            width: 250,
            height: 250,
            child: DialyGoalProgress()),
        Container(
          child: OutlinedButton(
            child: RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: Icon(Icons.map, size: 20),
                  ),
                  TextSpan(
                    text: " Show Route Details",
                    style: TextStyle(color: Theme.of(context).primaryColor),
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
              child: InkWell(
                child: SizedBox(
                  width: 175,
                  height: 125,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Shops Progression',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        Divider(),
                        Text('$shopCount',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25)),
                        Text("shops left")
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: InkWell(
                child: SizedBox(
                  width: 175,
                  height: 125,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Inventory Progression',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        Divider(),
                        Text('$itemCount',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25)),
                        Text("items left")
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    ));
  }
}
