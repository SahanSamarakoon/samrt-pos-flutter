import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smart_pos/models/payment.dart';

class SalesItem extends StatefulWidget {
  final Payment payment;
  SalesItem(this.payment);

  @override
  _SalesItemState createState() => _SalesItemState();
}

class _SalesItemState extends State<SalesItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(
              "Shop ID - ${widget.payment.shopId}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Total Sales -${widget.payment.total} LKR"),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.payment.transactions.length * 20 + 20, 100),
              child: ListView(
                children: widget.payment.transactions
                    .map((product) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Product ID - ${product["id"]}",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${product["quantity"]}x",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            )
                          ],
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
