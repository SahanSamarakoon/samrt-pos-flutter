import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:smart_pos/models/item.dart';
import 'package:smart_pos/models/payment.dart';
import 'package:smart_pos/models/salesperson.dart';
import 'package:smart_pos/models/shop.dart';
import 'package:smart_pos/screens/qr_code_screen.dart';
import 'package:smart_pos/widgets/add_invoice.dart';

class PaymentScreen extends StatefulWidget {
  final List<Map> items = [];
  final List<Map> itemsToModify = [];
  static const routeName = "/payemnt";

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  double total = 0;
  late Item qrItem;

  void setQrCode(String qr) {
    try {
      qrItem = Provider.of<ItemsProvider>(context, listen: false).findById(qr);
      _startAddNewItem(context, qrItem);
    } catch (error) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text("Item not found"),
                content: Text(
                    "Scanned item ID does not exist in your inventory. Please scan a valid item ID."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text("OK"))
                ],
              ));
    }
  }

  void _startAddNewItem(BuildContext ctx, Item initialItem) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          key: Key("modal"),
          onTap: () {},
          child: AddToInvoice(_addNewItem, initialItem),
          behavior: HitTestBehavior.deferToChild,
        );
      },
    );
  }

  void _addNewItem(String id, Item item, int quantity) {
    var index =
        widget.items.indexWhere((itemInvoice) => itemInvoice["id"] == id);
    widget.itemsToModify.add({"id": id, "quantity": quantity});
    total += (quantity * item.price);
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Added the Entry"),
      duration: const Duration(seconds: 3),
    ));
  }

  void _removeItem(String itemIdToRemove) {
    setState(() {
      final itemPrice = widget.items
          .firstWhere((item) => item["id"] == itemIdToRemove)["ppi"];
      final itemQauntity = widget.itemsToModify
          .firstWhere((item) => item["id"] == itemIdToRemove)["quantity"];
      total -= (itemPrice * itemQauntity);
      widget.items.removeWhere((item) => item["id"] == itemIdToRemove);
      widget.itemsToModify.removeWhere((item) => item["id"] == itemIdToRemove);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Removed the Entry"),
      duration: const Duration(seconds: 3),
    ));
  }

  Future<void> _updateSalesperson(String shopId, String sellerId,
      [bool isOnline = false]) async {
    try {
      await Provider.of<ShopsProvider>(context, listen: false)
          .checkShop(shopId, sellerId)
          .timeout(const Duration(seconds: 10));
      await Provider.of<ItemsProvider>(context, listen: false)
          .updateQuantity(widget.itemsToModify, sellerId)
          .timeout(const Duration(seconds: 10));
      await Provider.of<PaymentsProvider>(context, listen: false)
          .addPayment(sellerId, shopId, widget.itemsToModify, total, isOnline)
          .timeout(const Duration(seconds: 10));
    } catch (error) {
      print(error);
      await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text("Error connecting to the server"),
                content: Text(
                    "Please check your internet connectivity and try agin after few seconds."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text("OK"))
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('###,##0.00');
    final shop = ModalRoute.of(
      context,
    )!
        .settings
        .arguments as ShopItem;
    final seller =
        Provider.of<SalesPersonProvider>(context, listen: false).person;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Invoice"),
        actions: [
          IconButton(
              key: Key("addNewButton"),
              onPressed: () {
                _startAddNewItem(
                    context,
                    Provider.of<ItemsProvider>(context, listen: false)
                        .items[0]);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text('Invoice for ${shop.title}',
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold)),
              ),
              DataTable(
                key: Key("dataTable"),
                showCheckboxColumn: false,
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
                rows: widget.items
                    .map(((item) => DataRow(
                          onSelectChanged: (_) {
                            _removeItem(item["id"]);
                          },
                          cells: <DataCell>[
                            DataCell(Text(
                                item["id"].substring(item["id"].length - 5))),
                            const DataCell(VerticalDivider(thickness: 3)),
                            DataCell(Text(item["name"])),
                            const DataCell(VerticalDivider(thickness: 3)),
                            DataCell(Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [Text(formatter.format((item["ppi"])))],
                            )),
                            const DataCell(VerticalDivider(thickness: 3)),
                            DataCell(Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [Text("${item["quantity"]}")],
                            )),
                            const DataCell(VerticalDivider(thickness: 3)),
                            DataCell(Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(formatter
                                    .format(item["ppi"] * item["quantity"]))
                              ],
                            )),
                          ],
                        )))
                    .toList(),
              ),
              const SizedBox(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(QrCodeScreen.routeName,
                        arguments: setQrCode);
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "+ ",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        const WidgetSpan(
                          child: Icon(
                            Icons.qr_code,
                            size: 18,
                            key: Key("qrButton"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    primary: Theme.of(context).colorScheme.primary,
                    onPrimary: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Total : " + formatter.format(total) + " LKR",
                    key: Key("total"),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )),
            ])),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        key: Key("floatingButton"),
        foregroundColor: Theme.of(context).colorScheme.secondary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.check),
        onPressed: () => {
          if (widget.items.length == 0 || widget.itemsToModify.length == 0)
            {null}
          else
            {
              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                      key: Key("alertDialog"),
                      title: const Text("Confirm the Invoice",
                          style: TextStyle(color: Colors.black)),
                      content: Container(
                        height: 115,
                        child: Column(
                          children: [
                            const Text(
                                "Confirm the invoice with selecting the customer's payment method."),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        Navigator.of(ctx).pop(true);
                                        showDialog(
                                          //prevent outside touch
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            //prevent Back button press
                                            return WillPopScope(
                                              onWillPop: null,
                                              child: AlertDialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                elevation: 0,
                                                content: Container(
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                        await _updateSalesperson(
                                            shop.id, seller!.id, true);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("Issued the Invoice"),
                                          duration: const Duration(seconds: 3),
                                        ));
                                      },
                                      child: const Text("Pay Online")),
                                  ElevatedButton(
                                      onPressed: () async {
                                        Navigator.of(ctx).pop(true);
                                        showDialog(
                                          //prevent outside touch
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            //prevent Back button press
                                            return WillPopScope(
                                              onWillPop: null,
                                              child: AlertDialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                elevation: 0,
                                                content: Container(
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                        await _updateSalesperson(
                                            shop.id, seller!.id);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("Issued the Invoice"),
                                          duration: const Duration(seconds: 3),
                                        ));
                                      },
                                      child: const Text("Pay by Hand"))
                                ],
                              ),
                            )
                          ],
                        ),
                      )))
            }
        },
      ),
    );
  }
}
