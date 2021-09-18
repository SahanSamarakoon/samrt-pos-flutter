import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_pos/models/shop.dart';
import 'package:smart_pos/widgets/map_widget.dart';
import 'package:smart_pos/widgets/shop_item_widget.dart';

class ShopsScreen extends StatefulWidget {
  static const routeName = "/shops";

  @override
  _ShopsScreenState createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen> {
  @override
  Widget build(BuildContext context) {
    final shopData = Provider.of<ShopsProvider>(context);
    return Column(children: [
      Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          height: 300,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: MapWidegt([6.795074327733778, 79.90080262368436], 11),
          )),
      Container(
        width: double.infinity,
        height: 225,
        child: ListView.builder(
          itemBuilder: (ctx, index) =>
              ShopItemWidget(shopData.items[index], shopData.checkShop),
          itemCount: shopData.items.length,
        ),
      ),
    ]);
  }
}
