import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:smart_pos/models/payment.dart';

class SalesItem extends StatefulWidget {
  final Payment payment;
  final int index;
  SalesItem(this.index, this.payment);

  @override
  _SalesItemState createState() => _SalesItemState();
}

class _SalesItemState extends State<SalesItem> {
  var _expanded = false;
  final formatter = NumberFormat('###,000.00');
  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key('card'),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: ListTile(
              title: Text("Invoice ID - ${widget.payment.id}",
                  key: Key('idText'),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                children: [
                  Text(
                    "Shop ID - ${widget.payment.shopId}\nShop Name - ${widget.payment.shopName}",
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          "Total Sales",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Chip(
                          key: Key('onlineChip'),
                          label: Text(
                            widget.payment.isOnline ? "Online" : "By Hand",
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: widget.payment.isOnline
                              ? Colors.green
                              : Colors.amber,
                        ),
                        const Spacer(),
                        Chip(
                          key: Key('chip'),
                          label: Text(
                            formatter.format(widget.payment.total) + " LKR",
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                      ]),
                ],
              ),
              trailing: IconButton(
                key: Key('expandButton'),
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
          ),
          if (_expanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: max(widget.payment.transactions.length * 85, 125),
              child: DataTable(
                key: Key('dataTable'),
                showBottomBorder: true,
                dividerThickness: 3,
                columnSpacing: 4,
                columns: [
                  DataColumn(
                      label: Text('ID',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary))),
                  const DataColumn(
                    label: Text(''),
                  ),
                  DataColumn(
                      label: Text('Name',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary))),
                  const DataColumn(
                    label: Text(''),
                  ),
                  DataColumn(
                      label: Text('Unit\nPrice',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary))),
                  const DataColumn(
                    label: Text(''),
                  ),
                  DataColumn(
                      label: Text('Qnt',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary))),
                  const DataColumn(
                    label: Text(''),
                  ),
                  DataColumn(
                      label: Text('Price',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary))),
                ],
                rows: widget.payment.transactions
                    .map(((item) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(item["id"]["_id"]
                                .substring(item["id"]["_id"].length - 5))),
                            const DataCell(VerticalDivider(thickness: 3)),
                            DataCell(Text(item["id"]["itemName"])),
                            const DataCell(VerticalDivider(thickness: 3)),
                            DataCell(Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(formatter.format(item["id"]["unitPrice"])),
                              ],
                            )),
                            const DataCell(VerticalDivider(thickness: 3)),
                            DataCell(Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("${item["quantity"]}"),
                              ],
                            )),
                            const DataCell(VerticalDivider(thickness: 3)),
                            DataCell(Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(formatter.format(
                                    item["id"]["unitPrice"] * item["quantity"]))
                              ],
                            )),
                          ],
                        )))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
