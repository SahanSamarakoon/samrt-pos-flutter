// ignore_for_file: non_constant_identifier_names

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_pos/models/salesperson.dart';

import 'server.mocks.dart';

//Mock Server requests/respones
final SERVER_IP = 'http://10.0.2.2:3000';
final SalesPerson? mockSeller = null;
final String mockUserId = "614f8d020c645489164c376d";
final mockAuthToken =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYxNGY4ZDAyMGM2NDU0ODkxNjRjMzc2ZCIsImlhdCI6MTYzMzEyNTIzMCwiZXhwIjoxNjMzMjExNjMwfQ.m9JLztIX0jpFHhAkgrOYbuBiIeSxa8EITBiqfX43cw4";
final String mockRes =
    '{"task":{"_id":"615029f317f6cfe930749f90","sellerId":{"_id":"61671c22346f6b3724faef50","firstName":"Sahan","lastName":"Samarakoon"},"dailyRoute":{"originLocation":["6.797432747855229","79.88881319239222"],"destinationLocation":["6.7949617004984875","79.90075531945777"],"_id":"6167196af10633a59126815c","origin":"Katubedda","destination":"UOM"},"dailySalesProgression":1100,"dailySalesTarget":15000,"dailyShops":[{"isCovered":true,"shopId":{"location":["6.795074327733778","79.90080262368436"],"_id":"61673501f10633a591268164","address":"A address","shopName":"A Store","owner":"Mr. A Owner","phoneNo":111111111,"email":"xprnypnblck@gmail.com","city":"Moratuwa","route":"6167196af10633a59126815c"}},{"isCovered":false,"shopId":{"location":["6.795841377219869","79.88783682536616"],"_id":"6167364cf10633a59126816a","address":"B address","shopName":"B Store","owner":"Mr. B Owner","phoneNo":111111112,"email":"xprnypnblck@gmail.com","city":"Moratuwa","route":"6167196af10633a59126815c"}},{"isCovered":false,"shopId":{"location":["6.798637901355828","79.88874341196359"],"_id":"617316798f40637612bac4ca","address":"C address","shopName":"C Store","owner":"Mr. C Owner","phoneNo":111111113,"email":"xprnypnblck@gmail.com","city":"Moratuwa","route":"6167196af10633a59126815c"}},{"isCovered":false,"shopId":{"location":["6.793393905101009","79.88697430696742"],"_id":"61673700f10633a59126816e","address":"D address","shopName":"D Store","owner":"Mr. D Owner","phoneNo":111111114,"email":"xprnypnblck@gmail.com","city":"Moratuwa","route":"6167196af10633a59126815c"}}],"dailyInventory":[{"productId":{"_id":"616874417a10179ca894e8fa","itemName":"A Item","unitPrice":100},"quantity":48},{"productId":{"_id":"616874c07a10179ca894e8fb","itemName":"B Item","unitPrice":50},"quantity":123},{"productId":{"_id":"616874e77a10179ca894e8fc","itemName":"C Item","unitPrice":150},"quantity":8},{"productId":{"_id":"6173174d8f40637612bac4cf","itemName":"D Item","unitPrice":200},"quantity":98}]}}';
@GenerateMocks([http.Client])
void main() {
  group('Fetch And Set Salesperson - ', () {
    final client = MockClient();
    var mockSalesPerson =
        SalesPersonProvider(SERVER_IP, mockUserId, mockAuthToken, mockSeller);
    test('Returns a Salesperson if the http call completes successfully',
        () async {
      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.post(Uri.parse("$SERVER_IP/api/task/salesperson"),
              body: {"sellerId": mockUserId},
              headers: {"x-access-token": mockAuthToken}))
          .thenAnswer((_) async => http.Response(mockRes, 200));

      await mockSalesPerson.fetchAndSetSalesperson(client);
      expect(mockSalesPerson.person, isA<SalesPerson?>());
    });

    test('Throws an exception if the http call completes with an error', () {
      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.post(Uri.parse("$SERVER_IP/api/task/salesperson"),
              body: {"sellerId": mockUserId},
              headers: {"x-access-token": mockAuthToken}))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(mockSalesPerson.fetchAndSetSalesperson(client), throwsException);
    });
  });
}
