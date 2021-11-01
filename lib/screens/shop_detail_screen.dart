import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_pos/models/shop.dart';
import 'package:smart_pos/screens/payment_screen.dart';
import 'package:smart_pos/widgets/map_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopDetailScreen extends StatefulWidget {
  static const routeName = "/shop-detail";

  @override
  _ShopDetailScreenState createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final shopId = ModalRoute.of(context)!.settings.arguments as String;
    final shop =
        Provider.of<ShopsProvider>(context, listen: false).findById(shopId);
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(shop.title),
        ),
        body: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    height:
                        (mediaQuery.size.height - mediaQuery.padding.top) * 0.5,
                    child: ClipRRect(
                      key: Key("shopMapWidget"),
                      borderRadius: BorderRadius.circular(15),
                      child: MapWidegt([shop.location], 20),
                    )),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: InkWell(
                    child: SizedBox(
                      width: double.infinity,
                      height:
                          (mediaQuery.size.height - mediaQuery.padding.top) *
                              0.3125,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              shop.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            const Divider(),
                            Text(shop.cp,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            Text(shop.address),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.phone),
                                  color: Theme.of(context).colorScheme.primary,
                                  onPressed: () {
                                    setState(() {
                                      _makePhoneCall('tel:${shop.telephone}');
                                    });
                                  },
                                ),
                                FloatingActionButton(
                                    key: Key("invoiceButton"),
                                    foregroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    child: const Icon(Icons.payment),
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                          PaymentScreen.routeName,
                                          arguments: shop);
                                    }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}
