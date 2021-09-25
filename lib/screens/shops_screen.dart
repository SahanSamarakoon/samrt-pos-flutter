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
    final mediaQuery = MediaQuery.of(context);
    final shopData = Provider.of<ShopsProvider>(context);
    return Column(children: [
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: double.infinity,
          height: (mediaQuery.size.height - mediaQuery.padding.top) * 0.4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: MapWidegt(shopData.getShopLocations(), 14),
          )),
      Container(
        width: double.infinity,
        height: (mediaQuery.size.height - mediaQuery.padding.top) * 0.39,
        child: ListView.builder(
          itemBuilder: (ctx, index) =>
              ShopItemWidget(shopData.items[index], shopData.checkShop),
          itemCount: shopData.items.length,
        ),
      ),
    ]);
  }
}
