import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_pos/models/item.dart';

class InventoryScreen extends StatefulWidget {
  static const routeName = "/inventory";

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  Widget build(BuildContext context) {
    final itemData = Provider.of<ItemsProvider>(context).items;

    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.all(15),
          width: double.infinity,
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Text('Inventory',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ),
            DataTable(
              showBottomBorder: true,
              dividerThickness: 3,
              columnSpacing: 4,
              columns: [
                DataColumn(
                    label: Text('ID',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor))),
                DataColumn(
                  label: Text(''),
                ),
                DataColumn(
                    label: Text('Name',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor))),
                DataColumn(
                  label: Text(''),
                ),
                DataColumn(
                    label: Text('Per Item Price',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor))),
                DataColumn(
                  label: Text(''),
                ),
                DataColumn(
                    label: Text('Quantity',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor))),
              ],
              rows: itemData
                  .map(((item) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(item.id)),
                          DataCell(VerticalDivider(thickness: 3)),
                          DataCell(Text(item.name)),
                          DataCell(VerticalDivider(thickness: 3)),
                          DataCell(Text("${item.price}")),
                          DataCell(VerticalDivider(thickness: 3)),
                          DataCell(Text("${item.quantity}")),
                        ],
                      )))
                  .toList(),
            ),
          ])),
    );
  }
}
