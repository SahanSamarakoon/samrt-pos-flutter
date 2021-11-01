// ignore_for_file: non_constant_identifier_names

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_pos/middleware/auth.dart';

import '../models/server.mocks.dart';

//Mock Server requests/respones
final SERVER_IP = 'http://10.0.2.2:3001';
final String mockRes =
    '{"id":"61671c22346f6b3724faef50","firstName":"Sahan","lastName":"Samarakoon","email":"sahan.samarakoon.4@gmail.com","roles":[],"accessToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYxNjcxYzIyMzQ2ZjZiMzcyNGZhZWY1MCIsImlhdCI6MTYzNTA5NjE1OSwiZXhwIjoxNjM1MTgyNTU5fQ.74owcnXSzDqGTNBm_JAIW24aIEiDt7ZcxrK2LcyLP1M","expiresIn":"86400"}';
@GenerateMocks([http.Client])
void main() {
  final Auth mockAuthProvider = Auth();
  group('Authetication -', () {
    final client = MockClient();

    test('Returns true if the http call completes successfully', () async {
      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.post(Uri.parse("$SERVER_IP/api/auth/signin"),
              body: {"email": "test", "password": "test"}))
          .thenAnswer((_) async => http.Response(mockRes, 200));

      await mockAuthProvider.signin("test", "test", client);
      expect(mockAuthProvider.isAuth, true);
    });
    test('Returns User ID as a String if completes successfully', () {
      expect(mockAuthProvider.userId, isA<String>());
    });

    test('Returns token as a String if completes successfully', () {
      expect(mockAuthProvider.token, isA<String>());
    });

    test('Returns false if logout funtion completes successfully', () async {
      await mockAuthProvider.logout();
      expect(mockAuthProvider.isAuth, false);
    });
    test('Throws an exception if the http call completes with an error',
        () async {
      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.post(Uri.parse("$SERVER_IP/api/auth/signin"),
              body: {"email": "test", "password": "test"}))
          .thenAnswer((_) async => http.Response(mockRes, 500));

      expect(mockAuthProvider.signin("test", "test", client), throwsException);
    });
    test('Throws an exception if the email is wrong', () async {
      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.post(Uri.parse("$SERVER_IP/api/auth/signin"),
              body: {"email": "wrongtest", "password": "test"}))
          .thenAnswer((_) async => http.Response("Error", 404));

      expect(mockAuthProvider.signin("wrongtest", "test", client),
          throwsException);
    });

    test('Throws an exception if the password is wrong', () async {
      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.post(Uri.parse("$SERVER_IP/api/auth/signin"),
              body: {"email": "test", "password": "wrongtest"}))
          .thenAnswer((_) async => http.Response("Error", 401));

      expect(mockAuthProvider.signin("test", "wrongtest", client),
          throwsException);
    });
  });
}
