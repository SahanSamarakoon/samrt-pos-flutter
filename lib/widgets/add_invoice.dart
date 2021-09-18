import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:smart_pos/models/item.dart';

class AddToInvoice extends StatefulWidget {
  final Function addNewItem;

  AddToInvoice(this.addNewItem);
  @override
  _AddToInvoiceState createState() => _AddToInvoiceState();
}

class _AddToInvoiceState extends State<AddToInvoice> {
  final _amountController = TextEditingController();

  void _submitData(Item choosenItem) {
    widget.addNewItem(
        choosenItem.id, choosenItem, int.parse(_amountController.text));

    Navigator.of(context).pop();
  }

  late Item _selectedValue;

  @override
  Widget build(BuildContext context) {
    final itemsList = Provider.of<ItemsProvider>(context, listen: false).items;
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text("Choose an Item"),
                  ),
                ],
              ),
              DropdownButtonFormField(
                value: itemsList[0],
                hint: Text(
                  'Choose An Item',
                ),
                isExpanded: true,
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value as Item;
                  });
                },
                onSaved: (value) {
                  setState(() {
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
              TextField(
                decoration: InputDecoration(labelText: "Amount"),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(_selectedValue),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
                child: Text(
                  "Add to Invoice",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => _submitData(_selectedValue),
              )
            ],
          ),
        ),
      ),
    );
  }
}
