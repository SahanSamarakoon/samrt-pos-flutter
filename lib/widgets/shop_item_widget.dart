import 'package:flutter/material.dart';
import 'package:smart_pos/models/shop.dart';
import 'package:smart_pos/screens/shop_detail_screen.dart';

class ShopItemWidget extends StatefulWidget {
  final ShopItem shop;
  final Function checkShop;
  ShopItemWidget(this.shop, this.checkShop);
  @override
  _ShopItemWidgetState createState() => _ShopItemWidgetState();
}

class _ShopItemWidgetState extends State<ShopItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
        child: Column(
          children: [
            ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(ShopDetailScreen.routeName,
                      arguments: widget.shop.id);
                },
                title: Text(
                  "${widget.shop.title}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("${widget.shop.address}"),
                trailing: Checkbox(
                  activeColor: Theme.of(context).colorScheme.primary,
                  onChanged: (bool? value) {
                    setState(() {
                      widget.checkShop(widget.shop.id);
                    });
                  },
                  value: widget.shop.isCovered,
                ))
          ],
        ));
  }
}
