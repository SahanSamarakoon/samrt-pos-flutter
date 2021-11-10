import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:smart_pos/models/item.dart';

class AddToInvoice extends StatefulWidget {
  final Function addNewItem;
  final Item initialItem;

  AddToInvoice(this.addNewItem, this.initialItem);
  @override
  _AddToInvoiceState createState() => _AddToInvoiceState();
}

class _AddToInvoiceState extends State<AddToInvoice> {
  final _from = GlobalKey<FormState>();
  var _editedItem = Item(
    id: "",
    name: "",
    quantity: 0,
    price: 0.00,
  );
  late Item _selectedValue;

  void _submitData() {
    final _isValidated = _from.currentState!.validate();
    if (!_isValidated) {
      return;
    }
    _from.currentState!.save();
    widget.addNewItem(_editedItem.id, _editedItem, _editedItem.quantity);

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _selectedValue = widget.initialItem;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _editedItem = _selectedValue;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final itemsList = Provider.of<ItemsProvider>(context, listen: false).items;
    final mediaQuery = MediaQuery.of(context);
    final remainingQnt = Provider.of<ItemsProvider>(context, listen: false)
        .getItemReamingQnt(_selectedValue.id);

    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: mediaQuery.viewInsets.bottom + 50),
          child: Form(
            key: _from,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: Text("Choose Item"),
                ),
                Container(
                  child: DropdownButtonFormField(
                    value: _selectedValue,
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value as Item;
                      });
                    },
                    onSaved: (value) {
                      setState(() {
                        _editedItem = Item(
                            id: _selectedValue.id,
                            name: _selectedValue.name,
                            price: _selectedValue.price,
                            quantity: 0);
                        _selectedValue = value as Item;
                      });
                    },
                    items: itemsList.map((Item item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(
                          item.id,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Row(
                  children: [
                    const Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text("Item Name",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Spacer(),
                    const Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text("Item Price",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      _selectedValue.name,
                      key: Key("nameField"),
                    ),
                    Spacer(),
                    Text(
                      _selectedValue.price.toString(),
                      key: Key("priceField"),
                    ),
                  ],
                ),
                const Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text("Quantity"),
                ),
                TextFormField(
                  key: Key("qntField"),
                  decoration:
                      InputDecoration(contentPadding: const EdgeInsets.all(10)),
                  initialValue: "1",
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submitData(),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a quantity";
                    }
                    if (int.tryParse(value) == null) {
                      return "Please enter a valid number";
                    }
                    if (int.parse(value) <= 0) {
                      return "Please enter a valid number greater than 0";
                    }
                    if (int.parse(value) > remainingQnt) {
                      return "Please enter a lower or same number as\nremaining stock in the inventory\nRemaing stock:$remainingQnt ";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedItem = Item(
                        id: _selectedValue.id,
                        name: _selectedValue.name,
                        price: _selectedValue.price,
                        quantity: int.parse(value as String));
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  key: Key("addButton"),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text(
                    "Add to Invoice",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => _submitData(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
