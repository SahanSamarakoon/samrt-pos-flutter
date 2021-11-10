// @dart=2.9
// ignore_for_file: missing_return

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_pos/middleware/auth.dart';
import 'package:smart_pos/middleware/locationUpdate.dart';
import 'package:smart_pos/models/item.dart';
import 'package:smart_pos/models/payment.dart';
import 'package:smart_pos/models/salesperson.dart';
import 'package:smart_pos/models/shop.dart';
import 'package:smart_pos/screens/auth_screen.dart';
import 'package:smart_pos/screens/inventory_screen.dart';
import 'package:smart_pos/screens/maps_screen.dart';
import 'package:smart_pos/screens/payment_screen.dart';
import 'package:smart_pos/screens/qr_code_screen.dart';
import 'package:smart_pos/screens/sales_screen.dart';
import 'package:smart_pos/screens/shop_detail_screen.dart';
import 'package:smart_pos/screens/shops_screen.dart';
import 'package:smart_pos/screens/splash2_screen.dart';
import 'package:smart_pos/screens/tabs_screen.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'server.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final client = MockClient();
    // ignore: non_constant_identifier_names
    final SERVER_IP = 'http://10.0.2.2:3001';
    final String mockUserId = "61671c22346f6b3724faef50";
    final mockAuthToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYxNjcxYzIyMzQ2ZjZiMzcyNGZhZWY1MCIsImlhdCI6MTYzNTA5NjE1OSwiZXhwIjoxNjM1MTgyNTU5fQ.74owcnXSzDqGTNBm_JAIW24aIEiDt7ZcxrK2LcyLP1M";
    final String mockSellerRes =
        '{"task":{"_id":"615029f317f6cfe930749f90","sellerId":{"_id":"61671c22346f6b3724faef50","firstName":"Sahan","lastName":"Samarakoon"},"dailyRoute":{"originLocation":["6.797432747855229","79.88881319239222"],"destinationLocation":["6.7949617004984875","79.90075531945777"],"_id":"6167196af10633a59126815c","origin":"Katubedda","destination":"UOM"},"dailySalesProgression":550,"dailySalesTarget":15000,"dailyShops":[{"isCovered":true,"shopId":{"location":["6.795074327733778","79.90080262368436"],"_id":"61673501f10633a591268164","address":"A address","shopName":"A Store","owner":"Mr. A Owner","phoneNo":111111111,"email":"xprnypnblck@gmail.com","city":"Moratuwa","route":"6167196af10633a59126815c"}},{"isCovered":false,"shopId":{"location":["6.795841377219869","79.88783682536616"],"_id":"6167364cf10633a59126816a","address":"B address","shopName":"B Store","owner":"Mr. B Owner","phoneNo":111111112,"email":"xprnypnblck@gmail.com","city":"Moratuwa","route":"6167196af10633a59126815c"}},{"isCovered":false,"shopId":{"location":["6.798637901355828","79.88874341196359"],"_id":"617316798f40637612bac4ca","address":"C address","shopName":"C Store","owner":"Mr. C Owner","phoneNo":111111113,"email":"xprnypnblck@gmail.com","city":"Moratuwa","route":"6167196af10633a59126815c"}},{"isCovered":false,"shopId":{"location":["6.793393905101009","79.88697430696742"],"_id":"61673700f10633a59126816e","address":"D address","shopName":"D Store","owner":"Mr. D Owner","phoneNo":111111114,"email":"xprnypnblck@gmail.com","city":"Moratuwa","route":"6167196af10633a59126815c"}}],"dailyInventory":[{"productId":{"_id":"616874417a10179ca894e8fa","itemName":"A Item","unitPrice":100},"quantity":48},{"productId":{"_id":"616874c07a10179ca894e8fb","itemName":"B Item","unitPrice":50},"quantity":123},{"productId":{"_id":"616874e77a10179ca894e8fc","itemName":"C Item","unitPrice":150},"quantity":8},{"productId":{"_id":"6173174d8f40637612bac4cf","itemName":"D Item","unitPrice":200},"quantity":98}]}}';
    final String mockRes =
        '{"id":"61671c22346f6b3724faef50","firstName":"Sahan","lastName":"Samarakoon","email":"sahan.samarakoon.4@gmail.com","roles":[],"accessToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYxNjcxYzIyMzQ2ZjZiMzcyNGZhZWY1MCIsImlhdCI6MTYzNTA5NjE1OSwiZXhwIjoxNjM1MTgyNTU5fQ.74owcnXSzDqGTNBm_JAIW24aIEiDt7ZcxrK2LcyLP1M","expiresIn":"86400"}';
    final String mockPaymentList =
        '[{"_id":"616da296d9f30137446e8548","sellerId":"61671c22346f6b3724faef50","shopId":{"_id":"61673501f10633a591268164","shopName":"A Store"},"total":550,"dateTime":"2021-10-23T16:36:37.850Z","transactions":[{"id":{"_id":"616874417a10179ca894e8fa","itemName":"A Item","unitPrice":100},"quantity":1},{"id":{"_id":"616874c07a10179ca894e8fb","itemName":"B Item","unitPrice":50},"quantity":1},{"id":{"_id":"616874e77a10179ca894e8fc","itemName":"C Item","unitPrice":150},"quantity":1}],"isOnline":false,"__v":0}]';
    when(client.post(Uri.parse("$SERVER_IP/api/task/payments"),
            body: {"sellerId": mockUserId},
            headers: {"x-access-token": mockAuthToken}))
        .thenAnswer((_) async => http.Response(mockPaymentList, 200));
    when(client.post(Uri.parse("$SERVER_IP/api/task/salesperson"),
            body: {"sellerId": mockUserId},
            headers: {"x-access-token": mockAuthToken}))
        .thenAnswer((_) async => http.Response(mockSellerRes, 200));
    when(client.post(Uri.parse("$SERVER_IP/api/auth/signin"),
            body: {"email": "test@test.com", "password": "Test123"}))
        .thenAnswer((_) async => http.Response(mockRes, 200));
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, LocationUpdate>(
            update: (ctx, auth, previousSalesperson) => LocationUpdate(
              auth.SERVER_IP,
              auth.userId,
              auth.token,
            ),
            create: (_) {},
          ),
          ChangeNotifierProxyProvider<Auth, SalesPersonProvider>(
            update: (ctx, auth, previousSalesperson) => SalesPersonProvider(
              auth.SERVER_IP,
              auth.userId,
              auth.token,
              previousSalesperson == null ? null : previousSalesperson.seller,
              // auth.client
            ),
            create: (_) {},
          ),
          ChangeNotifierProxyProvider<Auth, ItemsProvider>(
            update: (ctx, auth, previousSalesperson) => ItemsProvider(
              auth.SERVER_IP,
              auth.userId,
              auth.token,
              previousSalesperson == null ? [] : previousSalesperson.items,
              // auth.client
            ),
            create: (_) {},
          ),
          ChangeNotifierProxyProvider<Auth, ShopsProvider>(
            update: (ctx, auth, previousItems) => ShopsProvider(
              auth.SERVER_IP,
              auth.userId,
              auth.token,
              previousItems == null ? [] : previousItems.items,
              // auth.client
            ),
            create: (_) {},
          ),
          ChangeNotifierProxyProvider<Auth, PaymentsProvider>(
            update: (ctx, auth, previousPaymnets) => PaymentsProvider(
              auth.SERVER_IP,
              auth.userId,
              auth.token,
              previousPaymnets == null ? [] : previousPaymnets.payments,
              // auth.client
            ),
            create: (_) {},
          ),
        ],
        child: Consumer<Auth>(
            builder: (ctx, auth, _) => MaterialApp(
                  title: 'Smart POS',
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSwatch(
                      primarySwatch: Colors.teal,
                    ).copyWith(secondary: Colors.white),
                  ),
                  home: auth.isAuth
                      ? Splash()
                      : FutureBuilder(
                          future: auth.tryAutoLogin(),
                          builder: (ctx, authResultSnapshot) =>
                              authResultSnapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : AuthScreen(),
                        ),
                  debugShowCheckedModeBanner: false,
                  routes: {
                    TabScreen.routeName: (ctx) => TabScreen(),
                    InventoryScreen.routeName: (ctx) => InventoryScreen(),
                    ShopsScreen.routeName: (ctx) => ShopsScreen(),
                    MapsScreen.routeName: (ctx) => MapsScreen(),
                    ShopDetailScreen.routeName: (ctx) => ShopDetailScreen(),
                    PaymentScreen.routeName: (ctx) => PaymentScreen(),
                    SalesScreen.routeName: (ctx) => SalesScreen(),
                    QrCodeScreen.routeName: (ctx) => QrCodeScreen(),
                    AuthScreen.routeName: (ctx) => AuthScreen(),
                  },
                )));
  }
}
