import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:smart_pos/models/payment.dart';
import 'package:smart_pos/models/salesperson.dart';
import 'package:smart_pos/widgets/main_drawer.dart';
import 'package:smart_pos/widgets/sales_item_widget.dart';

class SalesScreen extends StatefulWidget {
  static const routeName = "/sales";

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  @override
  void initState() {
    final seller =
        Provider.of<SalesPersonProvider>(context, listen: false).person;
    Provider.of<PaymentsProvider>(context, listen: false)
        .fetchAndSetPayments(seller!.dailySalesProgression);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final paymentData = Provider.of<PaymentsProvider>(context);
    var formatter = NumberFormat('###,##0.00');
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Sales Information"),
      ),
      drawer: MainDrawer(),
      body: Column(children: [
        Card(
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    "Total Daily Sales",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      formatter.format(paymentData.dailySales()) + " LKR",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ]),
          ),
        ),
        Container(
          width: double.infinity,
          height: (mediaQuery.size.height - mediaQuery.padding.top) * 0.725,
          child: ListView.builder(
            itemBuilder: (ctx, index) =>
                SalesItem(index, paymentData.payments[index]),
            itemCount: paymentData.payments.length,
          ),
        ),
      ]),
    );
  }
}
