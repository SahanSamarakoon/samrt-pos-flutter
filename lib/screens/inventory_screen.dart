import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
    final formatter = NumberFormat('###,##0.00');

    return SingleChildScrollView(
      child: Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          child: Column(children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Inventory in Hand',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                key: Key("titleText"),
              ),
            ),
            DataTable(
              key: Key("dataTable"),
              showBottomBorder: true,
              dividerThickness: 3,
              columnSpacing: 4,
              columns: [
                DataColumn(
                    label: Text('ID',
                        key: Key("idColum"),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary))),
                const DataColumn(
                  label: Text(''),
                ),
                DataColumn(
                    label: Text('Name',
                        key: Key("nameColum"),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary))),
                const DataColumn(
                  label: Text(''),
                ),
                DataColumn(
                    label: Text('Price',
                        key: Key("priceColum"),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary))),
                const DataColumn(
                  label: Text(''),
                ),
                DataColumn(
                    label: Text('Quantity',
                        key: Key("qntColum"),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary))),
              ],
              rows: itemData
                  .map(((item) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(item.id.substring(item.id.length - 5))),
                          const DataCell(VerticalDivider(thickness: 3)),
                          DataCell(Text(item.name)),
                          const DataCell(VerticalDivider(thickness: 3)),
                          DataCell(Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(formatter.format(item.price)),
                            ],
                          )),
                          const DataCell(VerticalDivider(thickness: 3)),
                          DataCell(Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("${item.quantity}"),
                            ],
                          )),
                        ],
                      )))
                  .toList(),
            ),
          ])),
    );
  }
}
