import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_pos/models/item.dart';
import 'package:smart_pos/models/payment.dart';
import 'package:smart_pos/models/salesperson.dart';
import 'package:smart_pos/models/shop.dart';
import 'package:smart_pos/widgets/add_invoice.dart';

class PaymentScreen extends StatefulWidget {
  double total = 0;
  final List<Map> items = [];
  final List<Map> itemsToModify = [];
  static const routeName = "/payemnt";

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  void _startAddNewItem(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: AddToInvoice(addNewItem),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void addNewItem(String id, Item item, int quantity) {
    var index =
        widget.items.indexWhere((itemInvoice) => itemInvoice["id"] == id);
    widget.itemsToModify.add({"id": id, "quantity": quantity});
    widget.total += (quantity * item.price);
    if (index >= 0) {
      setState(() {
        widget.items[index] = {
          "id": id,
          "name": item.name,
          "ppi": item.price,
          "quantity": widget.items[index]["quantity"] + quantity
        };
      });
    } else {
      setState(() {
        widget.items.add({
          "id": id,
          "name": item.name,
          "ppi": item.price,
          "quantity": quantity
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final shop = ModalRoute.of(
      context,
    )!
        .settings
        .arguments as ShopItem;
    final seller =
        Provider.of<SalesPersonProvider>(context, listen: false).person;
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Invoice"),
        actions: [
          IconButton(
              onPressed: () {
                _startAddNewItem(context);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(15),
            width: double.infinity,
            child: Column(children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text('Inovice for ${shop.title}',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
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
                      label: Text('P.I. Price',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor))),
                  DataColumn(
                    label: Text(''),
                  ),
                  DataColumn(
                      label: Text('Qnt',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor))),
                  DataColumn(
                    label: Text(''),
                  ),
                  DataColumn(
                      label: Text('Price',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor))),
                ],
                rows: widget.items
                    .map(((item) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(item["id"])),
                            DataCell(VerticalDivider(thickness: 3)),
                            DataCell(Text(item["name"])),
                            DataCell(VerticalDivider(thickness: 3)),
                            DataCell(Text("${item["ppi"]}")),
                            DataCell(VerticalDivider(thickness: 3)),
                            DataCell(Text("${item["quantity"]}")),
                            DataCell(VerticalDivider(thickness: 3)),
                            DataCell(Text("${item["ppi"] * item["quantity"]}")),
                          ],
                        )))
                    .toList(),
              ),
              SizedBox(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    _startAddNewItem(context);
                  },
                  child: const Text(
                    '+ New Item',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Total : ${widget.total}",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )),
            ])),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () => {
          showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text("Confirm the Payment method",
                        style: TextStyle(color: Colors.black)),
                    content: Text("What is the customer's payment method ?"),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          },
                          child: Text("Pay Online")),
                      ElevatedButton(
                          onPressed: () {
                            Provider.of<ShopsProvider>(context, listen: false)
                                .checkShop(shop.id);
                            Provider.of<ItemsProvider>(context, listen: false)
                                .updateQuantity(widget.itemsToModify);
                            Provider.of<PaymentsProvider>(context,
                                    listen: false)
                                .addPayment(seller.id, shop.id,
                                    widget.itemsToModify, widget.total);
                            Navigator.of(ctx).pop(true);
                            Navigator.of(ctx).pop();
                            Navigator.of(ctx).pop();
                          },
                          child: Text("Pay by Money"))
                    ],
                  ))
        },
      ),
    );
  }
}
