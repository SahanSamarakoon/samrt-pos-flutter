import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_pos/models/payment.dart';
import 'package:smart_pos/widgets/main_drawer.dart';
import 'package:smart_pos/widgets/sales_item_widget.dart';

class SalesScreen extends StatefulWidget {
  static const routeName = "/sales";

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  @override
  Widget build(BuildContext context) {
    final paymentData = Provider.of<PaymentsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Sales"),
      ),
      drawer: MainDrawer(),
      body: Column(children: [
        Card(
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total Daily Sales",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Text("${paymentData.dailySales().toStringAsFixed(2)} LKR"),
                ]),
          ),
        ),
        Container(
          width: double.infinity,
          height: 500,
          child: ListView.builder(
            itemBuilder: (ctx, index) => SalesItem(paymentData.payments[index]),
            itemCount: paymentData.payments.length,
          ),
        ),
      ]),
    );
  }
}
