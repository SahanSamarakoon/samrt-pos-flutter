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
    return Scaffold(
        appBar: AppBar(
          title: Text(shop.title),
        ),
        body: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    height: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: MapWidegt(shop.location, 18),
                    )),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: InkWell(
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              shop.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor),
                            ),
                            Divider(),
                            Text(shop.cp,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            Text(shop.address),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: new Icon(Icons.phone),
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    setState(() {
                                      _makePhoneCall('tel:${shop.telephone}');
                                    });
                                  },
                                ),
                                FloatingActionButton(
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
